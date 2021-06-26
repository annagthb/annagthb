view=0;

%sift_extract_initial

experiments;
step=opts.sift.sigma;
%ptsz=[6 6]; % [half-width half-height]%patchsize
for f=1:6
    %prepare to use the sift functions
    feat(f).pars=expr.descriptor(opts,expr.feature(f).patchSize);%find each cell's starting pixel(index) within a patch 12x12 and cell size 2x2
    feat(f).pars.patch=expr.feature(f);
end

%pt.imgs=FIMGS;
nImgs=size(FIMGS,3);

load('n1_model','xyMean','xyVar');
load('n1_siftmodel','model');
feat(1).model=model;feat(1).xyMean=xyMean;
feat(1).xyVar=xyVar;
load('m2_model','xyMean','xyVar');
load('m2_siftmodel','model');
feat(2).model=model;feat(2).xyMean=xyMean;
feat(2).xyVar=xyVar;
load('re3_model','xyMean','xyVar');
load('re3_siftmodel','model');
feat(3).model=model;feat(3).xyMean=xyMean;
feat(3).xyVar=xyVar;
load('le4_model','xyMean','xyVar');
load('le4_siftmodel','model');
feat(4).model=model;feat(4).xyMean=xyMean;
feat(4).xyVar=xyVar;
load('reb5_model','xyMean','xyVar');
load('reb5_siftmodel','model');
feat(5).model=model;feat(5).xyMean=xyMean;
feat(5).xyVar=xyVar;
load('leb6_model','xyMean','xyVar');
load('leb6_siftmodel','model');
feat(6).model=model;feat(6).xyMean=xyMean;
feat(6).xyVar=xyVar;


%prediction
truth=zeros(80,80);%initially mark all the pixels as negatives
nTest=100;
euclDist=zeros(nTest,1);
k=1;
euclDistClas=zeros(nTest,1);euclDistSpat=zeros(nTest,1);euclDistBoth=zeros(nTest,1);


res(1).title='classifier';
res(2).title='spatial model';
res(3).title='classifier and spatial model';
for i=datasetOpts.nPosTrain:datasetOpts.nPosTrain+nTest
    for f=1:4
        %classifier prediction(1 if above thres 0 otherwise) and probabilities for each pixel
        [clasPred res(1).conf]=feat(f).pars.classifierPredict(feat(f).model,double(FIMGS(:,:,i)),feat(f).pars);
        %spatial prediction(1 if above thres 0 otherwise) and prob for each pixel
        [spatialPred res(2).conf]=feat(f).pars.spatialPredict(double(FIMGS(:,:,i)),feat(f).xyMean,feat(f).xyVar); 
        %combine both probabilities
        res(3).conf=res(1).conf.*res(2).conf;
        bothPred=res(3).conf>0.9;%prediction above threshold

        %truth point
        [trueColRow]=findMeanOfPos(expr.feature(f),P(:,:,i));  
        trueX=round(trueColRow(1));
        trueY=round(trueColRow(2));
        truth(trueX,trueY)=1;%mark the ground truth pixel as positive
        feat(f).truex=trueX;feat(f).truey=trueY;

        %euclidean distance(clas, spat, both)
        %calculate euclidean distance between max clasPrediction and ground
        for t=1:3
            [res(t).maxConf,mIndex]=max(res(t).conf(:));%find the pixel with the maximum classifier probability | conf(:) is a 6400 col vector | max returns value and linear index
            [feat(f).yMax(t),feat(f).xMax(t)]=ind2sub(size(res(t).conf),mIndex);%convert linear index to 2d index
            if f==2%eucl distance for feature 2
                res(t).eucl(k)=sqrt((trueX-feat(f).xMax(t))^2+(trueY-feat(f).yMax(t))^2);
            end
            feat(f).res(t).conf=res(t).conf;
        end
    end
    k=k+1;
    if view   
        for r=1:3
            subplot(1,3,r);
            imagesc(repmat(FIMGS(:,:,i),[1 1 3]));%creates 3 copies of the img
            title(result(r).title);
            hold on;
            for f=1:4
    %            plot(feat(f).xTrue,feat(f).yTrue,'yx','linewidth',2','markersize',10);%plot groudn truth point
%                     if (k==1)
%                     [y,x]=find(clasPred);%pixels classified as positive above the threshold
%                     plot(x,y,'r+','linewidth',2,'markersize',10);%plot the pixels above the threshold
%                     else
               % plot(feat(f).xBoth,feat(f).yBoth,feat(f).col,'linewidth',5,'markersize',10);%plot the pixel with the maximum probability
               plot(feat(f).truex,feat(f).truey,'gx','linewidth',5,'markersize',12);
               plot(feat(f).xMax(r),feat(f).yMax(r),'rx','linewidth',5,'markersize',12); 


               axis image;
                %colorbar;
                drawnow;
            end

        end
        figure(2)
        subplot(1,4,1);
        imagesc(repmat(FIMGS(:,:,i),[1 1 3]));%creates 3 copies of the img
        axis image;
        hold on;
        plot(feat(2).truex,feat(2).truey,feat(2).col,'linewidth',2,'markersize',10);
        hold off;
        subplot(1,4,2);
        imagesc(feat(2).res(1).conf);
        title('classifier')
        axis image;
        subplot(1,4,3);
        imagesc(feat(2).res(2).conf);
        title('prior');
        axis image;
        subplot(1,4,4);
        imagesc(feat(2).res(3).conf);
        title('classifier and prior')
        axis image;
        pause;

        clf;

     end

end

%plot the euclidean distance threshold vs proportion of imgs graph
colour=['r','g','b'];
figure;
for p=1:3
    [s,sIndex]=sort(res(p).eucl);
    plot(s,(1:numel(s))/numel(s),colour(p),'markersize',10,'linewidth',2);
    grid;
    xlabel('Euclidean distance (in pixels)');
    ylabel('proportion of images within distance');
    axis([0 20 0 1]);
    hold on;
end
legend('classifier','spatial model','classifier and spatial model');


