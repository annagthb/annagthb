%sift_test
%prediction
load('sift_mmodel','model');
view=0;
truth=zeros(80,80);%initially mark all the pixels as negatives
nTest=100;

pt=sift_make(opts,expr.ftest.patchSize);
pt.patch=expr.ftest;
euclDistClas=zeros(nTest,1);euclDistSpat=zeros(nTest,1);euclDistBoth=zeros(nTest,1);
for i=expr.nPosTrain:expr.nPosTrain+nTest
% for i=1:expr.nPosTrain

    %classifier prediction and probabilities for each pixel
    [clasPred clasConf]=pt.classifierPredict(model,double(FIMGS(:,:,i)),pt); 
    %truth point
    [trueColRow]=findMeanOfPos(pt.patch,P(:,:,i));  
    trueX=round(trueColRow(1));
    trueY=round(trueColRow(2));
    truth(trueX,trueY)=1;%mark the ground truth pixel as positive
    
    %calculate euclidean distance between max clasPrediction and ground
    [maxClas,mIndex]=max(clasConf(:));%find the pixel with the maximum classifier probability | conf(:) is a 6400 col vector | max returns value and linear index
    [yClas,xClas]=ind2sub(size(clasConf),mIndex);%convert linear index to 2d index
     euclDistClas(i)=sqrt((trueX-xClas)^2+(trueY-yClas)^2);
    if view
        subplot(211);
        imagesc(repmat(FIMGS(:,:,i),[1 1 3]));%creates 3 copies of the img
        hold on;
        plot(trueX,trueY,'yx','linewidth',2','markersize',10);%plot groudn truth point
%         [y,x]=find(clasPred);%pixels classified as positive above the threshold
%         plot(x,y,'r+','linewidth',2,'markersize',10);%plot the pixels above the threshold
        plot(xClas,yClas,'rx','linewidth',2,'markersize',10);%plot the pixel with the maximum probability
        hold off;
        axis image;
        colorbar;
        subplot(212);
        imagesc(clasConf);%plot prob for each pixel        
        axis image;
        colorbar;
        %colormap jet;
        drawnow;
        pause;
    end
end

figure
[s,sIndex]=sort(euclDistClas);
plot(s,(1:numel(s))/numel(s));
grid;
xlabel('Euclidean distance (in pixels)');
ylabel('proportion of images within distance');
axis([0 50 0 1]);