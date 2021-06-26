feature(1).pointsIndices=[9 10 11]; %exp2
feature(2).pointsIndices=[12 13 14 15];%left right top bottom exp2
feature(3).pointsIndices=[1 2 3 4];%exp2
feature(4).pointsIndices=[5 6 7 8];%exp2

%nose
feature(1).name='nose';
feature(1).i=1;
%feature(1).patchSize=[15 15];%row col
feature(1).patchSize=[19 19]; %elextike me cross val
feature(1).uncertainRegionRadius=15;
feature(1).meanRowOffset=-4;

%mouth
feature(2).name='mouth';
feature(2).i=2;
%feature(2).patchSize=[11 23];%row col
feature(2).patchSize=[17 25];
feature(2).uncertainRegionRadius=15;%15;
feature(2).meanRowOffset=2;

%left eye
feature(3).name='rightEye';
feature(3).i=3;
feature(3).patchSize=[15 15];%[7 15];
feature(3).uncertainRegionRadius=10;
feature(3).meanRowOffset=0;

%right eye
feature(4).name='leftEye';
feature(4).i=4;
feature(4).patchSize=[15 15];
feature(4).uncertainRegionRadius=10;
feature(4).meanRowOffset=0;



expr.feature=feature;
%expr.descriptor=@sift_make;
%expr.descriptor=@plain_make;
expr.descriptor=@sift_cluster_make;
%expr.descriptor=@plain_cluster_make;
expr.ftest=expr.feature(2);
% expr.height=expr.imgDimensions(1)-expr.ftest.patchSize(1)+1;
% expr.width=expr.imgDimensions(2)-expr.ftest.patchSize(2)+1;

%hog options
opts.sift.bins=8;%8; % num orientation bins
opts.sift.signed=true; % signed/unsigned orientation
opts.sift.lin=true; % interpolation scheme
opts.sift.sigma=[4]; % size(s) of cells. 2x2. you can use different cell sizes to compute different HOGs(nmz en to xreiazomai)
opts.sift.norml2=1e-6; % normalization

%load images
% load('frontal_faces','i','p','d','pnames');
% dataset.images=uint8(i);
% dataset.imagePoints=p;
% clear i p d pnames

%load images
load('anna_faces.mat','FIMGS','P','pnames');
dataset.images=FIMGS;
dataset.imagePoints=P;
% clear FIMGS P pnames

datasetOpts.nImages=size(dataset.images,3);
datasetOpts.imgSize=size(dataset.images(:,:,1));
datasetOpts.nPosTrain=750;%1000;
datasetOpts.nTest=143;
datasetOpts.nNegPerImg=3;
datasetOpts.nNegTrain=datasetOpts.nPosTrain*datasetOpts.nNegPerImg;

trainOpts.iterations=10;
trainOpts.nNew=50;%100%new patches added to the training set per iteration
trainOpts.nNewPerImg=2;
trainOpts.imgsPerIteration=10;%20 %30
trainOpts.nInitialNeg=250;



