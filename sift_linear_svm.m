function [cluster nClusters]=sift_linear_svm(posData,negData,trainOpts,datasetOpts,featPatchOpts,dataset,pt)
%px
%(10,normalisation(posData(1:expr.nPosTrain,:),normalisation(negData(1:expr
%.initialNegTrain),50,10,feat(f));
%nNew= num of all negative train patches per iteration
%nImgs= num of imgs that we test on per iteration
    nClusters=1;

    step=pt.sift.sigma;
    ptsz=featPatchOpts.patchSize/2;

    w=floor(ptsz(2)/step)*step;%patch width(half)=6
    h=floor(ptsz(1)/step)*step;%patch heig
    xcells=numel(-w:step:w);
    ycells=numel(-h:step:h);
    nEls=xcells*ycells*pt.sift.bins+1;
    %linear_svm
    ptsz=featPatchOpts.patchSize;
    stop=size(posData,1)+trainOpts.nInitialNeg;
    upperBound=size(posData,1)+trainOpts.nInitialNeg+size(posData,1)*trainOpts.nNew;
    data=zeros(upperBound,nEls);
    imgPatches=(datasetOpts.imgSize(1)-ptsz(1)+1)*(datasetOpts.imgSize(2)-ptsz(2)+1);%find out how many patches each img has
    newPatches=zeros(trainOpts.imgsPerIteration*imgPatches,nEls);
    data(1:datasetOpts.nPosTrain,:)=posData;%posData(1:expr.nPosTrain);
    data(datasetOpts.nPosTrain+1:stop,:)=negData(1:trainOpts.nInitialNeg,:);%negData(1:expr.intialNegTrain,:);
    labels(1:datasetOpts.nPosTrain,:)=ones(datasetOpts.nPosTrain,1);
    labels(datasetOpts.nPosTrain+1:stop)=-ones(trainOpts.nInitialNeg,1);
    
    start=0;
    if ((featPatchOpts.i==3) | (featPatchOpts.i==4))
        ex=3;
    elseif (featPatchOpts.i==1)
        ex=15;
    else
        ex=1.5;
   end
    pars=sprintf('-t 0 -c %d',ex);
    ac=cross_validation(posData(1:datasetOpts.nPosTrain,:),negData(1:datasetOpts.nPosTrain+700,:),ex);
    %pars=linear_svm_cross_validation(posData(1:datasetOpts.nPosTrain,:),negData(1:2*datasetOpts.nPosTrain,:));
    for i=1:trainOpts.iterations
        fprintf('iteration: %d\n',i);
        model=svmtrain(labels,data(1:stop,:),pars);%train with the new data
        more=0;
        for j=start+1:start+trainOpts.imgsPerIteration
            fprintf('extracting from image: %d\n',j);
            negPixels=findAllNegPoints(featPatchOpts,dataset.imagePoints(:,:,j),datasetOpts.imgSize);%find all negs of img
            H=sift_prep(dataset.images(:,:,j),pt);
            negPatches=sift_extract(H,pt,negPixels(:,1)',negPixels(:,2)');
            %negPatches=extractPatch(dataset.images(:,:,j),featPatchOpts.patchSize,negPixels(:,1),negPixels(:,2));%extract them
            nPatches=size(negPatches',1);%count them
            newPatches(more+1:more+nPatches,:)=negPatches';%store them
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
        fprintf('size of training images: %d\n',stop);
    end
    cluster(nClusters).model=model;
end