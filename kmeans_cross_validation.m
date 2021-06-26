function [centroids bestN]=kmeans_cross_validation(kfold,data,nData)%3 5 10
    foldSize=floor(nData/kfold);
    lastFoldSize=foldSize+mod(nData,foldSize);
    maxNumOfClusters=5;
    initialisationIterations=6;
    
    distance=inf;
    for i=1:maxNumOfClusters%1..6
        for j=1:kfold%1..5
            if j~=kfold
                fsize=foldSize;
            else
                fsize=lastFoldSize;
            end    
            start=(j-1)*foldSize;%calculate start of test fold
            test=data(start+1:start+fsize,:);
            temp=data;
            temp(start+1:start+fsize,:)=[];
            train=temp;
            
            %train the clusters with the train data
            sseA=inf;
            for k=1:initialisationIterations%run it 5 times to get the best initialisation with min sse
            [clusterCentres, sse]=vgg_kmeans(train',i);
                if sse<sseA
                    sseA=sse;
                    centres=clusterCentres;
                end
            end
            %test the accuracy(distance) on the test data
            [partition,dist]=vgg_nearest_neighbour(test',clusterCentres);
            foldMean(j)=mean(dist);
        end
        clusMean(i)=mean(foldMean);%1 tropos
         %%%%%%
         intraDist=zeros(i,1);%find the min intra. sum ola
         allintra=0;
         for s=1:size(clusterCentres,1)%go through all dimensions
                 for t=1:size(test,1)%for all test examples
                    clu=partition(t);
                    if (s==clu)
                        intraDist(clu)=intraDist(clu)+(test(t,s)-clusterCentres(s,clu))^2;%gt ta matrices mou en anapoda
                    end
                 end
                 allintra=allintra+intraDist(clu);%sum(sum((x-m)^2))
         end
         
        interDist=0;%find the max inter
        nd=0;
        comb=zeros(factorial(i),1);
        r=1;
        for m=1:i-1%for all num of cl 1..4
            for b=m+1:i%for remaining num of cl 2..5
                for s=1:size(clusterCentres,1)%dimension of the data 1..225
                    nd=nd+(clusterCentres(s,m)-clusterCentres(s,b))^2;
                end
                comb(r)=nd;
                r=r+1;
                interDist=interDist+nd;%sum(sum((ci-cj)^2))
                nd=0;
            end
        end
        %value=allintra/interDist;%sum of distances
        value=allintra/mean(comb);%mean of distances
    %%%%%%%%%%
            
        if (value<distance)
            bestN=i;
            distance=value;
            centroids=centres;
        end
    end
end