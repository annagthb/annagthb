function [centroids bestN bestQuality]=find_n_clusters(data)

    %for i=1:n find the best partition(min sse) for each i (5 runs)
    iter=7;
    maxN=5;
    sseA=inf(maxN,1);
    %n = struct('clusterCentres', {[],[],[],[],[],[]});
    n=struct('clusterCentres',{});
    for i=1:maxN
        for j=1:iter%run it 5 times to get the best initialisation
            [clusterCentres, sse]=vgg_kmeans(data,i);
            if sse<sseA(i)
                sseA(i)=sse;
                n(i).clusterCentres=clusterCentres;
            end
        end
    end

    %for each i(best partition now found) find best i which has the max
    %mean(silhouette)
%     qual=zeros(maxN,1);
%     for i=1:maxN
%         [clusteredPoints,dist]=vgg_nearest_neighbour(data,n(i).clusterCentres);
%         s=silhouette(data',clusteredPoints);
%         qual(i)=mean(s);
%     end
%     [bestQuality, bestN]=max(qual);
%     centroids=n(bestN).clusterCentres;
%     bestQuality%max silhouette value
%     bestN%best n(index of maxQuality)
%    sseA(bestN)%sum of squared distances
ok=2;
centroids=n(ok).clusterCentres;
bestN=ok;
bestQuality=0;
end