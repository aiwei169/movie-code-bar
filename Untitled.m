clc;
clear all;
tic;
videopath='.\video\1.mkv';%��Ƶ·��
saveimgpath='.\frame\';%����֡��·��
savepath='.\result\barcode1.jpg';%����������ͼƬ��·��
savedatapath='.\result\barcode1.mat';%����ԭ���������ݵ�·��
imshow(run(videopath,saveimgpath,savepath,savedatapath)/256)%���������롢��ʾ������
toc;
function [barcode]=run(videopath,saveimgpath,savepath,savedatapath)%����������
num=readvideo(videopath,saveimgpath);%��ȡ�ܹ��ж���֡
imgpathtemp=strcat(saveimgpath,num2str(1),'.jpg');%��ȡ��һ֡
[h,~,~]=size(imread(imgpathtemp));%��ȡ��һ֡����ȡ��Ӱ����Ŀ��
barcode=zeros(h,num,3);%��ʼ��������
hh=waitbar(0,'������������');%��ʼ��������
for i=1:num
    waitbar(i/num);%������
    imgpath=strcat(saveimgpath,num2str(i),'.jpg');%��ȡ�����˵�ÿһ֡��ͼƬ
    barcode(:,i,:)=make(imread(imgpath));%��ȡÿһ֡����ɫ��
end
close(hh);%�رս�����
save(savedatapath,'barcode');%��������������
imwrite(barcode/256,savepath);%����������ͼƬ
imwrite(imresize(imread(savepath),[768,1366]),'barcode2.jpg');%������Էֱ��ʵ�������ͼƬ��·��
end
function [P]=make(I)%��ȡͼ����ɫ��
I=double(I);%Ҫʹ��kmeans�����Ի���double
[h,w,~]=size(I);
P=ones(h,1,3);%��ÿһ֡����ɫ��Ϊh����1������
for j=1:h
    temp=I(j,:,:);%��ȡÿһ�е����ص��RGB����
    [~,c]=kmeans(reshape(temp,w,3),1,'distance','sqEuclidean');%c�Ǿ������ģ�Ҳ�������ǵ���ɫ������һ֡�������ص����ɫ���������ɫ����
    c=roundn(c,0);
    P(j,1,:)=c;%������һ����RGBֵ
end
end
function [s]=readvideo(fileName,path)
obj=VideoReader(fileName);%��ȡ��Ƶ
numFrames=obj.NumFrames;%��ȡ֡������
s=0;
skep=roundn(obj.FrameRate,0);%ÿ���֡��
if(skep>1)%���ÿ��1֡���Ͳ��ü�1������Ҫȡ����1����Ϊ�ܶ���Ƶÿ��֡����С��
    skep=skep-1;
end
hh=waitbar(0,'��ȡ��Ƶ������֡');%��ʼ��������
sh=floor(numFrames/skep)+1;%�ܹ�Ҫ�����֡��
for k = 1:skep:numFrames%��ȡ����,ÿ��ֻȡһ֡
    s=s+1;%��˳�����Ҫ�����֡����,��¼���ж���֡(��)
    frame=read(obj,k);%��ȡ֡
    imwrite(frame,strcat(path,num2str(s),'.jpg'));%����֡
    waitbar(s/sh);%������
end
close(hh);%�رս�����
end