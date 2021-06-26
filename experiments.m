feature(1).pointsIndices=[5 6 7];%left bottom right exp1
feature(2).pointsIndices=[8 9 18 19]; %exp1
feature(3).pointsIndices=[1 2 14 15];%left right top bottom exp1
feature(4).pointsIndices=[3 4 16 17];%exp1


%feature(1).pointsIndices=[9 10 11]; %exp2
%feature(2).pointsIndices=[12 13 14 15];%left right top bottom exp2
%feature(3).pointsIndices=[1 2 3 4];%exp2
%feature(4).pointsIndices=[5 6 7 8];%exp2

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
feature(3).name='rEye';
feature(3).i=3;
feature(3).patchSize=[15 15];%[7 15];
feature(3).uncertainRegionRadius=10;
feature(3).meanRowOffset=0;

%right eye
feature(4).name='lEye';
feature(4).i=4;
feature(4).patchSize=[15 15];
feature(4).uncertainRegionRadius=10;
feature(4).meanRowOffset=0;

% %left eyebrow
% feature(5).name='rEyebrow';
% feature(5).i=5;
% feature(5).patchSize=[7 15];
% feature(5).pointsIndices=[10 11];
% %feature(1).pointsIndices=[21 22];
% feature(5).uncertainRegionRadius=10;
% feature(5).meanRowOffset=0;
% 
% %right eyebrow
% feature(6).name='lEyebrow';
% feature(6).i=6;
% feature(6).patchSize=[7 15];
% feature(6).pointsIndices=[12 13];
% %feature(1).pointsIndices=[23 24];
% feature(6).uncertainRegionRadius=10;
% feature(6).meanRowOffset=0;

% %left ear
% feature(7).name='rightEar';
% feature(7).patchSize=[7 15];
% feature(7).pointsIndices=[17 18];
% feature(7).uncertainRegionRadius=10;
% feature(7).meanRowOffset=0;

% %right ear
% feature(8).name='lEar';
% feature(8).patchSize=[7 15];
% feature(8).pointsIndices=[19 20];
% feature(8).uncertainRegionRadius=10;
% feature(8).meanRowOffset=0;

% %chin
% feature(9).name='chin';
% feature(9).patchSize=[7 15];
% feature(9).pointsIndices=[16];
% feature(9).uncertainRegionRadius=10;
% feature(9).meanRowOffset=0;

%experiment1
% expr1.feature=feature;
% expr1.imgDimensions=[80 80];
% expr1.nImgsUsedForTraining=500;
% expr1.nPosTrain=500;%the num of pos training data
% expr1.initialNegTrain=250;%num of intial negative training data
% exp1.classifier=....

expr.feature=feature;
expr.descriptor=@sift_make;
%expr.descriptor=@plain_make;
%expr.descriptor=@sift_cluster_make;
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
load('anna_faces.mat','FIMGS','P','pnames');
dataset.images=FIMGS;
dataset.imagePoints=P;
% clear FIMGS P pnames
% load('frontal_faces','i','p','d','pnames');
% dataset.images=i;
% dataset.imagePoints=p;

datasetOpts.nImages=size(dataset.images,3);
datasetOpts.imgSize=size(dataset.images(:,:,1));
datasetOpts.nPosTrain=1100%1100;%1000;
datasetOpts.nTest=500;
datasetOpts.nNegPerImg=3;
datasetOpts.nNegTrain=datasetOpts.nPosTrain*datasetOpts.nNegPerImg;

trainOpts.iterations=10%10;
trainOpts.nNew=50;%100%new patches added to the training set per iteration
trainOpts.nNewPerImg=2;
trainOpts.imgsPerIteration=10;%20 %30
trainOpts.nInitialNeg=250;



