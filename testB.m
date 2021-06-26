view=0;
load('m2_model','model','xyMean','xyVar');
load('anna_faces','FIMGS','P');
experiments;

%prediction
truth=zeros(80,80);%initially mark all the pixels as negatives
nTest=100;
euclDist=zeros(nTest,1);
k=1;

euclDistClas=zeros(nTest,1);euclDistSpat=zeros(nTest,1);euclDistBoth=zeros(nTest,1);
for i=expr.nPosTrain:expr.nPosTrain+nTest
% for i=1:expr.nPosTrain

    %classifier prediction and probabilities for each pixel
    [clasPred clasConf]=classifierPredict(model,double(FIMGS(:,:,i)),expr.ftest);
    %spatial prediction
    [spatialPred spatialConf]=spatialPredict(double(FIMGS(:,:,i)),xyMean,xyVar); 
   
    %combine both probabilities
    bothConf=clasConf.*spatialConf;
    bothPred=bothConf>0.9;
    
    %truth point
    [trueColRow]=findMeanOfPos(expr.ftest,P(:,:,i));  
    trueX=round(trueColRow(1));
    trueY=round(trueColRow(2));
    truth(trueX,trueY)=1;%mark the ground truth pixel as positive
    
    %calculate euclidean distance between max clasPrediction and ground
    [maxClas,mIndex]=max(clasConf(:));%find the pixel with the maximum classifier probability | conf(:) is a 6400 col vector | max returns value and linear index
    [yClas,xClas]=ind2sub(size(clasConf),mIndex);%convert linear index to 2d index
    euclDistClas(k)=sqrt((trueX-xClas)^2+(trueY-yClas)^2);
    %calucalte euclidean distance between max spatialPrediction and ground
    [maxSpat,mIndex]=max(spatialConf(:));%find the pixel with the maximum classifier probability | conf(:) is a 6400 col vector | max returns value and linear index
    [ySpat,xSpat]=ind2sub(size(spatialConf),mIndex);%convert linear index to 2d index
    euclDistSpat(k)=sqrt((trueX-xSpat)^2+(trueY-ySpat)^2);
    %calculate euclidean distance between max spatial*classifier prediction and ground truth
    [maxBoth,mIndex]=max(bothConf(:));%find the pixel with the maximum classifier probability | conf(:) is a 6400 col vector | max returns value and linear index
    [yBoth,xBoth]=ind2sub(size(bothConf),mIndex);%convert linear index to 2d index
    euclDistBoth(k)=sqrt((trueX-xBoth)^2+(trueY-yBoth)^2);
    k=k+1;
    
    if view
        ev=(clasPred~=truth);%find the ones that have been misclassified
        misclas=numel(find(ev))%count how many have been misclassified by finding their linear indices
        
        subplot(211);
        imagesc(repmat(FIMGS(:,:,i),[1 1 3]));%creates 3 copies of the img
        hold on;
        plot(trueX,trueY,'yo','linewidth',2','markersize',10);%plot groudn truth point
        [y,x]=find(bothPred);%pixels classified as positive above the threshold
        plot(x,y,'r+','linewidth',2,'markersize',10);%plot the pixels above the threshold
        plot(xBoth,yBoth,'gx','linewidth',2,'markersize',10);%plot the pixel with the maximum probability
        hold off;
        axis image;
        colorbar;
        subplot(212);
        imagesc(bothConf);%plot prob for each pixel        
        axis image;
        colorbar;
        %colormap jet;
        drawnow;
        pause;
    end
    
end

%plot the euclidean distance threshold vs proportion of imgs graph
[s,sIndex]=sort(euclDistClas);
plot(s,(1:numel(s))/numel(s));
grid;
xlabel('Euclidean distance (in pixels)');
ylabel('proportion of images within distance');
figure
[s,sIndex]=sort(euclDistSpat);
plot(s,(1:numel(s))/numel(s));
grid;
xlabel('Euclidean distance (in pixels)');
ylabel('proportion of images within distance');
figure
[s,sIndex]=sort(euclDistBoth);
plot(s,(1:numel(s))/numel(s));
grid;
xlabel('Euclidean distance (in pixels)');
ylabel('proportion of images within distance');