function [cluster nClusters]=linear_svm(posData,negData,trainOpts,datasetOpts,featPatchOpts,dataset,siftOpts)
%px
%(10,normalisation(posData(1:expr.nPosTrain,:),normalisation(negData(1:expr
%.initialNegTrain),50,10,feat(f));
%nNew= num of all negative train patches per iteration
%nImgs= num of imgs that we test on per iteration
    %linear_svm
    nClusters=1;
    
    ptsz=featPatchOpts.patchSize;
    stop=size(posData,1)+trainOpts.nInitialNeg;
    upperBound=size(posData,1)+trainOpts.nInitialNeg+size(posData,1)*trainOpts.nNew;
    data=zeros(upperBound,ptsz(1)*ptsz(2));
    imgPatches=(datasetOpts.imgSize(1)-ptsz(1)+1)*(datasetOpts.imgSize(2)-ptsz(2)+1);%find out how many patches each img has
    newPatches=zeros(trainOpts.imgsPerIteration*imgPatches,ptsz(1)*ptsz(2));
    data(1:datasetOpts.nPosTrain,:)=posData;%posData(1:expr.nPosTrain);
    data(datasetOpts.nPosTrain+1:stop,:)=negData(1:trainOpts.nInitialNeg,:);%negData(1:expr.intialNegTrain,:);
    labels(1:datasetOpts.nPosTrain,:)=ones(datasetOpts.nPosTrain,1);
    labels(datasetOpts.nPosTrain+1:stop)=-ones(trainOpts.nInitialNeg,1);
    
    start=0;
    ex=-1;
    pars=sprintf('-t 0 -c 1e%d',ex);
    %pars=linear_svm_cross_validation(posData(1:datasetOpts.nPosTrain,:),negData(1:datasetOpts.nPosTrain+700,:));
    for i=1:trainOpts.iterations
        model=svmtrain(labels,data(1:stop,:),pars);%train with the new data
        more=0;
        for j=start+1:start+trainOpts.imgsPerIteration
            negPixels=findAllNegPoints(featPatchOpts,dataset.imagePoints(:,:,j),datasetOpts.imgSize);%find all negs of img
            negPatches=extractPatch(dataset.images(:,:,j),featPatchOpts.patchSize,negPixels(:,1),negPixels(:,2));%extract them
            nPatches=size(negPatches,1);%count them
            newPatches(more+1:more+nPatches,:)=negPatches;%store them
            more=more+nPatches;
            start=start+trainOpts.imgsPerIteration;
            if (start>datasetOpts.nPosTrain)
                start=0;
            end
        end
        testNeg=normalisation(newPatches(1:more,:));%normalise extracted patches
        testLab=-ones(size(testNeg,1),1);
        predictedLabels=svmpredict(testLab,testNeg,model);%test on them
        misclas=(predictedLabels==1);%find misclassifications
        misclasIndices=find(misclas);%find their indices
        nMisclas=numel(misclasIndices);%count them
        if (nMisclas==0)
            break;
        end
        if (nMisclas<=trainOpts.nNew)%nNew is per iteration
            selected=misclasIndices;%choose all of them
            nSelected=nMisclas;
        else
            nSelected=trainOpts.nNew;%choose nNew random of them
            jumble=randperm(nMisclas);
            selectedIndices=jumble(1:nSelected);
            selected=misclasIndices(selectedIndices);
        end
        data(stop+(1:nSelected),:)=testNeg(selected,:);
        labels(stop+(1:nSelected),:)=-1;
        stop=stop+nSelected;
    end
    cluster(nClusters).model=model;
 ok=data(1:stop,:);
        figure(10);
        imagesc(blockofpics(ok',ptsz));
        colormap gray;
end