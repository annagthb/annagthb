function [cluster nClusters]=linear_svm4(posData,negData,trainOpts,datasetOpts,featPatchOpts,dataset,~)
%gia kathe image tests and selectes 2 from the misclassifications
%px
%(10,normalisation(posData(1:expr.nPosTrain,:),normalisation(negData(1:expr
%.initialNegTrain),50,10,feat(f));
%nNew= num of all negative train patches per iteration
%nImgs= num of imgs that we test on per iteration
    %linear_svm
    nClusters=1;
    
    ptsz=featPatchOpts.patchSize;
    stop=size(posData,1)+trainOpts.nInitialNeg;
    %upperBound=size(posData,1)+trainOpts.nInitialNeg+size(posData,1)*trainOpts.nNew;
    upperBound=size(posData,1)+trainOpts.nInitialNeg+datasetOpts.nPosTrain*trainOpts.nNewPerImg*trainOpts.iterations;
    data=zeros(upperBound,ptsz(1)*ptsz(2));
    %imgPatches=(datasetOpts.imgSize(1)-ptsz(1)+1)*(datasetOpts.imgSize(2)-ptsz(2)+1);%find out how many patches each img has
    %newPatches=zeros(trainOpts.imgsPerIteration*imgPatches,ptsz(1)*ptsz(2));

    data(1:datasetOpts.nPosTrain,:)=posData;%posData(1:expr.nPosTrain);
    data(datasetOpts.nPosTrain+1:stop,:)=negData(1:trainOpts.nInitialNeg,:);%negData(1:expr.intialNegTrain,:);
    labels(1:datasetOpts.nPosTrain,:)=ones(datasetOpts.nPosTrain,1);
    labels(datasetOpts.nPosTrain+1:stop)=-ones(trainOpts.nInitialNeg,1);
    
    %start=0;
   
%    if ((featPatchOpts.i==1) || (featPatchOpts.i==2))
%         ex=1e-1;
%    else
%        ex=1e-1;
%    end
    ex=1e-1;
    pars=sprintf('-t 0 -c %d',ex);
    %cros val g patch size
%     fprintf('ptsz:[%d %d]\n',ptsz(1),ptsz(2));
%    [pars,accc]=linear_svm_cross_validation(posData(1:datasetOpts.nPosTrain,:),negData(1:datasetOpts.nPosTrain+2000,:));
%     pars=linear_svm_cross_validation(posData(1:datasetOpts.nPosTrain,:),negData(1:datasetOpts.nPosTrain+700,:));
    accur=zeros(datasetOpts.nPosTrain,1);
    for i=1:trainOpts.iterations
        model=svmtrain(labels,data(1:stop,:),pars);%train with the new data
        w=model.SVs'*model.sv_coef;
        b=model.rho;
        for j=1:datasetOpts.nPosTrain
            
            negPixels=findAllNegPoints(featPatchOpts,dataset.imagePoints(:,:,j),datasetOpts.imgSize);%find all negs of img
            negPatches=extractPatch(dataset.images(:,:,j),featPatchOpts.patchSize,negPixels(:,1),negPixels(:,2));%extract them
           testNeg=normalisation(double(negPatches));
%             
%             figure(300);
%     imagesc(blockofpics(testNeg',ptsz));
%     colormap gray;
            
            prob=w'*testNeg'-b;
            %prob=(prob-min(prob))/(max(prob)-min(prob));
            %prob=reshape(prob,[80 80]);
            
            
            %predictedLabels=svmpredict(testLab,testNeg,model);%test on them
            misclas=(prob>0);%find misclassifications
            misclasIndices=find(misclas);%find their indices
            nMisclas=numel(misclasIndices);%count them
            
            fprintf('iteration:%d image:%d miscl:%d\n',i,j,nMisclas);
            if (nMisclas==0)
                accur(j)=1;
            else
                accur(j)=0;
                %trainOpts.nNewPerImg=i;
                nSelected=trainOpts.nNewPerImg;
                if (nMisclas<nSelected)
                    nSelected=nMisclas;
                end
                jumble=randperm(nMisclas);
                selectedIndices=jumble(1:nSelected);
                selected=misclasIndices(selectedIndices);

                data(stop+(1:nSelected),:)=testNeg(selected,:);
                labels(stop+(1:nSelected),:)=-1;
                stop=stop+nSelected;
            end
            
        end
        
        if (mean(accur)==1)
            break;
        end
    end
    stop
    cluster(nClusters).model=model;
    ok=data(1:datasetOpts.nPosTrain,:);
    figure(200);
    imagesc(blockofpics(ok',ptsz));
    colormap gray;
   
end