function [cluster nClusters]=sift_linear_svm4(posData,negData,trainOpts,datasetOpts,featPatchOpts,dataset,pt)
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
   
    stop=size(posData,1)+trainOpts.nInitialNeg;
    %upperBound=size(posData,1)+trainOpts.nInitialNeg+size(posData,1)*trainOpts.nNew;
    upperBound=size(posData,1)+trainOpts.nInitialNeg+datasetOpts.nPosTrain*trainOpts.nNewPerImg*trainOpts.iterations;
    data=zeros(upperBound,nEls);
%     imgPatches=(datasetOpts.imgSize(1)-ptsz(1)+1)*(datasetOpts.imgSize(2)-ptsz(2)+1);%find out how many patches each img has
%     newPatches=zeros(trainOpts.imgsPerIteration*imgPatches,nEls);
    
    data(1:datasetOpts.nPosTrain,:)=posData;%posData(1:expr.nPosTrain);
    data(datasetOpts.nPosTrain+1:stop,:)=negData(1:trainOpts.nInitialNeg,:);%negData(1:expr.intialNegTrain,:);
    labels(1:datasetOpts.nPosTrain,:)=ones(datasetOpts.nPosTrain,1);
    labels(datasetOpts.nPosTrain+1:stop)=-ones(trainOpts.nInitialNeg,1);

    if ((featPatchOpts.i==3) || (featPatchOpts.i==4)) %eyes
        ex=3;
    elseif (featPatchOpts.i==1) %nose
        ex=15;
    else %mouth
        ex=1.5;
   end
    pars=sprintf('-t 0 -c %d',ex);
    ex=15
%     ac=cross_validation(posData(1:datasetOpts.nPosTrain,:),negData(1:datasetOpts.nPosTrain+700,:),ex);
%      fprintf('bins:%d cells:%d\n',pt.sift.bins,pt.sift.sigma(1));
%     [pars,accc]=linear_svm_cross_validation(posData(1:datasetOpts.nPosTrain,:),negData(1:2*datasetOpts.nPosTrain,:));
%     accur=zeros(datasetOpts.nPosTrain,1);
    for i=1:trainOpts.iterations
        model=svmtrain(labels,data(1:stop,:),pars);%train with the new data
        w=model.SVs'*model.sv_coef;
        b=model.rho;
        for j=1:datasetOpts.nPosTrain
            
            negPixels=findAllNegPoints(featPatchOpts,dataset.imagePoints(:,:,j),datasetOpts.imgSize);%find all negs of img
            H=sift_prep(dataset.images(:,:,j),pt);
            testNeg=sift_extract(H,pt,negPixels(:,1)',negPixels(:,2)');
            %negPatches=extractPatch(dataset.images(:,:,j),featPatchOpts.patchSize,negPixels(:,1),negPixels(:,2));%extract them
           
         prob=w'*testNeg-b;
        testNeg=testNeg';
       
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
     %model=svmtrain(labels,data(1:stop,:),pars);%train with the latest data
    stop
    cluster(nClusters).model=model;
    
end