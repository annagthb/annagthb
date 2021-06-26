
experiments;
%ptsz=[6 6]; % [half-width half-height]%patchsize
%ptsz=expr.ftest.patchSize/2;
step=opts.sift.sigma;

%prepare to use the sift functions
pt=sift_make(opts,ptsz);%find each cell's starting pixel(index) within a patch 12x12 and cell size 2x2
%load imgs
load('anna_faces.mat','FIMGS','P','pnames');
%pt.imgs=FIMGS;
nImgs=size(FIMGS,3);
%initialisations
nNegativesPerImg=3;
nNegatives=nImgs*nNegativesPerImg;
posLabels=zeros(nImgs,1);
w=floor(ptsz(2)/step)*step;%patch width(half)=6
h=floor(ptsz(1)/step)*step;%patch heig
xcells=numel(-w:step:w);
ycells=numel(-h:step:h);
nEls=xcells*ycells*opts.sift.bins+1;
posExamples=zeros(nImgs,nEls);
posLabels=zeros(nImgs,1);
negLabels=zeros(nNegatives,1);
negExamples=zeros(nNegatives,nEls);


pt=expr.descriptor(opts,expr.ftest.patchSize);
pt.patch=expr.ftest;
%create 2 matrices 1 with positive examples and 1 with negatives
for i=1:nImgs
    %prepare the img
    %prepare the img(create histograms)
    H=pt.prep(FIMGS(:,:,i),pt);
    
    %extract positive patches
    patch=pt.extractPositive(H,pt,P(:,:,i));
    posExamples(i,:)=patch';
    posLabels(i)=1;
     
    %extract negative patches
    currentIndex=(i-1)*nNegativesPerImg;%find out where next neg should be stored
    patches=pt.extractNegative(H,pt,P(:,:,i),nNegativesPerImg,FIMGS(:,:,i));
    negExamples(currentIndex+1:currentIndex+nNegativesPerImg,:)=patches';
    negLabels(currentIndex+1:currentIndex+nNegativesPerImg)=-1;
end