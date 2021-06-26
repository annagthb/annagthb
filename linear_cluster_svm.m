function [cluster nClusters]=linear_cluster_svm(posData,negData,trainOpts,datasetOpts,featPatchOpts,dataset,~)
%px
%(10,normalisation(posData(1:expr.nPosTrain,:),normalisation(negData(1:expr
%.initialNegTrain),50,10,feat(f));
%nNew= num of all negative train patches per iteration
%nImgs= num of imgs that we test on per iteration
    %linear_svm
    ptsz=featPatchOpts.patchSize;
   upperBound=size(posData,1)+trainOpts.nInitialNeg+datasetOpts.nPosTrain*trainOpts.nNewPerImg*trainOpts.iterations;
    data=zeros(upperBound,ptsz(1)*ptsz(2));
    labels=zeros(upperBound,1);
%     imgPatches=(datasetOpts.imgSize(1)-ptsz(1)+1)*(datasetOpts.imgSize(2)-ptsz(2)+1);%find out how many patches each img has
%     newPatches=zeros(trainOpts.imgsPerIteration*imgPatches,ptsz(1)*ptsz(2));

    %determine the num of clusters, cluster the data, find centroids
    [centroids,nClusters,qual]=find_n_clusters(posData');
    %[centroids,nClusters]=kmeans_cross_validation(5,posData,size(posData,1));
    %determine the cluster of each example
    [partition,~]=vgg_nearest_neighbour(posData',centroids);
    
    
     if ((featPatchOpts.i==1) || (featPatchOpts.i==2))
        ex=1e-1;
     else
        ex=1;
     end
    pars=sprintf('-t 0 -c %d',ex);
 
     accur=zeros(datasetOpts.nPosTrain,1);
    for c=1:nClusters
        indices=find(partition==c);%find the row index of all examples in posData that is in cluster c
        stop=numel(indices)+trainOpts.nInitialNeg;
        
        clusterExamples=posData(indices,1:size(posData,2));
        figure(c+5);
        imagesc(blockofpics(clusterExamples',ptsz));
        colormap gray;
        
        
        data(1:numel(indices),:)=clusterExamples;%posData(1:expr.nPosTrain);
        data(numel(indices)+1:stop,:)=negData(1:trainOpts.nInitialNeg,:);
        labels(1:numel(indices),:)=ones(numel(indices),1);
        labels(numel(indices)+1:stop)=-ones(trainOpts.nInitialNeg,1);

        
        
        for i=1:trainOpts.iterations
            model=svmtrain(labels(1:stop),data(1:stop,:),pars);%train with the new data
  
            w=model.SVs'*model.sv_coef;
            b=model.rho;
            for j=1:datasetOpts.nPosTrain
                negPixels=findAllNegPoints(featPatchOpts,dataset.imagePoints(:,:,j),datasetOpts.imgSize);%find all negs of img
                negPatches=extractPatch(dataset.images(:,:,j),featPatchOpts.patchSize,negPixels(:,1),negPixels(:,2));%extract them
                testNeg=normalisation(double(negPatches));%normalise extracted patches
            
                prob=w'*testNeg'-b;
                
                
                misclas=(prob>0);%find misclassifications
                misclasIndices=find(misclas);%find their indices
                nMisclas=numel(misclasIndices);%count them
                fprintf(' cluster:%d iteration:%d image:%d miscl:%d\n',c,i,j,nMisclas);
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
        cluster(c).model=model;
        clear model labels
        ok=data(1:stop,:);
        figure(c);
        imagesc(blockofpics(ok',ptsz));
        colormap gray;
    end
end