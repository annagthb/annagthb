%graphs
load('results f3 sift','feature');
cluster(1).feature=feature;
load('results f3 sift 2clusters','feature');
cluster(2).feature=feature;
load('results f3 sift 3clusters','feature');
cluster(3).feature=feature;
% load('results f3 sift 4clusters','feature');
% cluster(4).feature=feature;

colour=['r','g','b','k'];

f=3;
for c=1:3
    [s,sIndex]=sort(cluster(c).feature(f).res(1).eucl);%res1=classifier
            plot(s,(1:numel(s))/numel(s),colour(c),'markersize',10,'linewidth',2);
            
            xlabel('Euclidean distance (in pixels)');
            ylabel('proportion of images within distance');
            axis([0 50 0 1]);
            hold on;
        
end 

grid
legend('1','2','3','4');