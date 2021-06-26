%graphs
load('results plain single','feature');
method(1).feature=feature;
load('results plain mixture','feature');
method(2).feature=feature;
load('results sift single','feature');
method(3).feature=feature;
load('results sift mixture','feature');
method(4).feature=feature;
%plot euclidean distance of feature 2
colour=['r','g','b','k'];
titles={'classifier','spatial','combination'};
experiments;

for f=1:4%1=plainSingle 2=plainMixture 3=siftSingle 4=siftMixture
    for m=1:2:3%pass the spatial%for each of the 3 models plot its 4 training methods 
             %       *classifier->plainSing plainMixt siftSing siftMixtr
             %       *spatial->plainSing plainMixt siftSing siftMixtr         
             %       *both->plainSing plainMixt siftSing siftMixtr                       
        num=str2num(sprintf('%d%d',f,m));
        figure(num);
        for r=1:4
            [s,sIndex]=sort(method(r).feature(f).res(m).eucl);
            plot(s,(1:numel(s))/numel(s),colour(r),'markersize',10,'linewidth',2);
            grid;
            xlabel('Euclidean distance (in pixels)');
            ylabel('proportion of images within distance');
            axis([0 50 0 1]);
            hold on;
        end
         grid;
        legend('gray level descriptor','gray level mixture ','hog descriptor','hog mixture');
        ok=cell2mat(titles(m));
        name=sprintf('%s %s',feature(f).name,ok);
        title(name);
    end
end

