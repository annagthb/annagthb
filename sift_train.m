
experiments;
%ptsz=[6 6]; % [half-width half-height]%patchsize
ptsz=expr.ftest.patchSize/2;
step=opts.sift.sigma;
w=floor(ptsz(2)/step)*step;%patch width(half)=6
h=floor(ptsz(1)/step)*step;%patch heig
xcells=numel(-w:step:w);
ycells=numel(-h:step:h);
nEls=xcells*ycells*opts.sift.bins+1;
%prepare to use the sift functions
pt=sift_make(opts,expr.ftest.patchSize);%find each cell's starting pixel(index) within a patch 12x12 and cell size 2x2
pt.patch=expr.ftest;
%load imgs
load('anna_faces.mat','FIMGS','P','pnames');
%pt.imgs=FIMGS;
nImgs=size(FIMGS,3);

%normalise the extracted data
normPos=normalisation(posExamples);
normNeg=normalisation(negExamples);
%initialisations
iterations=5;
nImages=10;
nNegativesPerIteration=50;
upperBoundTrainData=expr.nPosTrain+expr.initialNegTrain+expr.nPosTrain*nNegativesPerIteration;
trainData=zeros(upperBoundTrainData,nEls);
trainLabels=zeros(upperBoundTrainData,1);

%get initial train data
trainData(1:expr.nPosTrain,:)=normPos(1:expr.nPosTrain,:);
trainLabels(1:expr.nPosTrain)=ones(expr.nPosTrain,1);
previousEnd=expr.nPosTrain+expr.initialNegTrain;
trainData(expr.nPosTrain+1:previousEnd,:)=normNeg(1:expr.initialNegTrain,:);
trainLabels(expr.nPosTrain+1:expr.nPosTrain+expr.initialNegTrain)=negLabels(expr.initialNegTrain,1);

ex=-1;
pars=sprintf('-t 0 -c 1e%d',ex);
totalPatches=expr.height*expr.width;%find out how many patches each img has
allNegPatches=zeros(nImages*totalPatches,nEls);
start=0;
for i=1:iterations
    i
    model=svmtrain(trainLabels(1:previousEnd),trainData(1:previousEnd,:),pars);
    morePatchesEnd=0;
    for k=start+1:start+nImages
        [candidatePoints,heig,wid]=findAllNegPoints(expr.ftest,P(:,:,k),expr.imgDimensions);
        H=sift_prep(FIMGS(:,:,k),pt);%
        negPatches=sift_extract(H,pt,candidatePoints(:,1)',candidatePoints(:,2)');
        nPatchesOfCurrentImg=size(negPatches',1);
        allNegPatches(morePatchesEnd+1:morePatchesEnd+nPatchesOfCurrentImg,:)=negPatches';
        morePatchesEnd=morePatchesEnd+nPatchesOfCurrentImg;
        start=start+nImages;
        if (start>expr.nPosTrain)
            start=0;
        end
    end
    testNeg=normalisation(allNegPatches(1:morePatchesEnd,:));
    testLabels=-ones(size(testNeg,1),1);
    [predLabels,ac,re]=svmpredict(testLabels,testNeg,model);
    newData=(predLabels==1);
    newDataIndices=find(newData);
    nNew=numel(newDataIndices);
    nNew
    if (nNew==0)
        break
    end
    if (nNew<=nNegativesPerIteration)
        selected=newDataIndices;
        nChosen=nNew;
    else
        nChosen=nNegativesPerIteration;
        jumble=randperm(nNew);
        selectedIndices=jumble(1:nChosen);
        selected=newDataIndices(selectedIndices);
    end
    trainData(previousEnd+(1:nChosen),:)=testNeg(selected,:);
    trainLabels(previousEnd+(1:nNew),:)=-1;
    previousEnd=previousEnd+nChosen;
    
end    
previousEnd
[kalo]=svmpredict(trainLabels(1:previousEnd),trainData(1:previousEnd,:),model);
any1s=sum(kalo==1)%checkes whether any example was classified as positive