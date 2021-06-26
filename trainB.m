experiments
%normalise all data
normPos=normalisation(posExamples);
normNeg=normalisation(negExamples);
%initialise other variables
iterations=5;
nImages=10;%expr.nPosTrain;%or 10
nNegativesPerImg=50;
%initialise trainingData.this is an upper bound on the size of training data
%upperBoundTrainData=expr.nPosTrain+expr.initialNegTrain+expr.width*expr.height*nImages*iterations/2;
upperBoundTrainData=expr.nPosTrain+expr.initialNegTrain+expr.nPosTrain*nNegativesPerImg;
bTrainData=zeros(upperBoundTrainData,expr.ftest.patchSize(1)*expr.ftest.patchSize(2));
bTrainLabels=zeros(upperBoundTrainData,1);

%get the initial positive data to the training  matrix
bTrainData(1:expr.nPosTrain,:)=normPos(1:expr.nPosTrain,:);
bTrainLabels(1:expr.nPosTrain)=ones(expr.nPosTrain,1);
previousEnd=expr.nPosTrain+expr.initialNegTrain;%record where the total trainSet ends
%add the initial neg patches to the training matrix
bTrainData(expr.nPosTrain+1:previousEnd,:)=normNeg(1:expr.initialNegTrain,:);
bTrainLabels(expr.nPosTrain+1:expr.nPosTrain+expr.initialNegTrain)=-ones(expr.initialNegTrain,1);

ex=-1;
pars=sprintf('-t 0 -c 1e%d',ex);
totalPatches=expr.height*expr.width;%find out how many patches each img has
allNegPatches=zeros(nImages*totalPatches,expr.ftest.patchSize(1)*expr.ftest.patchSize(2));%upper bound on the neg testData
%posMean=zeros(2,nImages);%initialise a matrix that will hold the mean point of the pos patch in each img
start=0;
for i=1:iterations
    i
    model=svmtrain(bTrainLabels(1:previousEnd),bTrainData(1:previousEnd,:),pars);
    %%%%imgIndex=((i-1)*nImages+1):((i-1)*nImages+nImages);%choose next 5 imgs to train on.store their indices
    morePatchesEnd=0;
    %test the classifier on this 5 imgs using a sliding%window(matrix15^2by....)
    for k=start+1:start+nImages%extract the neg patches from the chosen 5 imgs
      
        %%%%[candidatePoints,heig,wid]=findAllNegPoints(expr.ftest,P(:,:,imgIndex(k)),expr.imgDimensions);
        [candidatePoints,heig,wid]=findAllNegPoints(expr.ftest,P(:,:,k),expr.imgDimensions);
                
%       plot the uncertain region
%         figure(50);
%         imagesc(FIMGS(:,:,imgIndex(k)));
%         colormap gray;
%         hold on;
%         scatter(candidatePoints(:,1),candidatePoints(:,2),'.','red');%xcol yrow 
        
        %%%%negPatches=extractPatch(candidatePoints,expr.ftest.patchSize,FIMGS(:,:,imgIndex(k)));
        negPatches=extractPatch(candidatePoints,expr.ftest.patchSize,FIMGS(:,:,k));
        
        %add the new neg patches to the matrix holding older neg patches
        nPatchesOfCurrentImg=size(negPatches,1);
        allNegPatches(morePatchesEnd+1:morePatchesEnd+nPatchesOfCurrentImg,:)=negPatches;
        morePatchesEnd=morePatchesEnd+nPatchesOfCurrentImg;
        start=start+nImages;
    end
    %test ur classifier on these new neg patches
    testNeg=normalisation(allNegPatches(1:morePatchesEnd,:));%normalise the extractedPatches
    testLabels=-ones(size(testNeg,1),1);%create -1 labels for the new negPatches
    [predLabels,ac,re]=svmpredict(testLabels,testNeg,model);%test on the neg patches. prints out the accuracy
    %check whether any example was misclassified as positive
    misclas=(predLabels==1);%marks all data that has been misclassified as pos
    misclasIndices=find(misclas);%finds indices of those examples
    nNew=numel(misclasIndices);
    nNew
    if (nNew==0)%if no data is misclassified then break
        break;
    end
    %randomly select 10 out of the candidate points that have been misclassified
    if (nNew<=nNegativesPerImg)
        selected=misclasIndices;
        nChosen=nNew;
    else
        nChosen=nNegativesPerImg;
        %selectedIndices=randi([1 nNew],1,nChosen);
        jumble=randperm(nNew);
        selectedIndices=jumble(1:nChosen);
        selected=misclasIndices(selectedIndices);
    end
    bTrainData(previousEnd+(1:nChosen),:)=testNeg(selected,:);
    bTrainLabels(previousEnd+(1:nNew),:)=-1;
    previousEnd=previousEnd+nChosen;

    
    %bTrainData(previousEnd+(1:nNew),:)=testNeg(newDataIndices,:);
    %add their labels too
    %bTrainLabels(previousEnd+(1:nNew),:)=-1;
    %previousEnd=previousEnd+nNew;
end
%check accuracy
previousEnd
[kalo]=svmpredict(bTrainLabels(1:previousEnd),bTrainData(1:previousEnd,:),model);
any1s=sum(kalo==1)%checkes whether any example was classified as positive

ok=bTrainData(1:previousEnd,:);

figure(22);
imagesc(blockofpics(ok',expr.ftest.patchSize));
colormap gray;


%train the spatial model
for j=1:expr.nPosTrain
    xy(:,j)=findMeanOfPos(expr.ftest,P(:,:,j));%get the features xy coordinates for all the training imgs
end

xyMean=[mean(xy(1,:));mean(xy(2,:))];%find the mean of all the x and y coordinates of the feature according to training imgs
xyVar=[var(xy(1,:));var(xy(2,:))];%find var of all x and y coordinates of the feature according to trainging imgs