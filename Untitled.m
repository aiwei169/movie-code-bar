clc;
clear all;
tic;
videopath='.\video\1.mkv';%视频路径
saveimgpath='.\frame\';%保存帧的路径
savepath='.\result\barcode1.jpg';%保存条形码图片的路径
savedatapath='.\result\barcode1.mat';%保存原条形码数据的路径
imshow(run(videopath,saveimgpath,savepath,savedatapath)/256)%生成条形码、显示条形码
toc;
function [barcode]=run(videopath,saveimgpath,savepath,savedatapath)%生成条形码
num=readvideo(videopath,saveimgpath);%获取总共有多少帧
imgpathtemp=strcat(saveimgpath,num2str(1),'.jpg');%获取第一帧
[h,~,~]=size(imread(imgpathtemp));%读取第一帧，获取电影画面的宽度
barcode=zeros(h,num,3);%初始化条形码
hh=waitbar(0,'制作条形码中');%初始化进度条
for i=1:num
    waitbar(i/num);%进度条
    imgpath=strcat(saveimgpath,num2str(i),'.jpg');%读取保存了的每一帧的图片
    barcode(:,i,:)=make(imread(imgpath));%读取每一帧的主色调
end
close(hh);%关闭进度条
save(savedatapath,'barcode');%保存条形码数据
imwrite(barcode/256,savepath);%保存条形码图片
imwrite(imresize(imread(savepath),[768,1366]),'barcode2.jpg');%保存电脑分辨率的条形码图片的路径
end
function [P]=make(I)%获取图像主色调
I=double(I);%要使用kmeans，所以换成double
[h,w,~]=size(I);
P=ones(h,1,3);%把每一帧的主色存为h乘以1的条形
for j=1:h
    temp=I(j,:,:);%获取每一行的像素点的RGB向量
    [~,c]=kmeans(reshape(temp,w,3),1,'distance','sqEuclidean');%c是聚类中心，也就是我们的主色调，这一帧所有像素点的颜色都里这个颜色附近
    c=roundn(c,0);
    P(j,1,:)=c;%分配这一条的RGB值
end
end
function [s]=readvideo(fileName,path)
obj=VideoReader(fileName);%读取视频
numFrames=obj.NumFrames;%获取帧的总数
s=0;
skep=roundn(obj.FrameRate,0);%每秒的帧数
if(skep>1)%如果每秒1帧，就不用减1，这里要取整减1是因为很多视频每秒帧数是小数
    skep=skep-1;
end
hh=waitbar(0,'读取视频，保存帧');%初始化进度条
sh=floor(numFrames/skep)+1;%总共要保存的帧数
for k = 1:skep:numFrames%读取数据,每秒只取一帧
    s=s+1;%按顺序给需要保存的帧命名,记录共有多少帧(秒)
    frame=read(obj,k);%读取帧
    imwrite(frame,strcat(path,num2str(s),'.jpg'));%保存帧
    waitbar(s/sh);%进度条
end
close(hh);%关闭进度条
end