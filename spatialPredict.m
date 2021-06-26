function [prediction spConf]=spatialPredict(img,xyMean,xyVar)
%input img= the image where you want to detect the feature
%input fMeanX and fMeanY= the mean of all the labeled X(or Y) coordinates of the given feature in the
%training set (needed to calculate the gaussian pdf)
%input fVarX and fVarY= the var of all the labeled X(or Y) coordinates in
%the training set(needed to calculate the gaussian pdf)

%prediction=    the pixels that have probability above some threshold
%conf=          confidence probability for every pixel of the image

    x=1:size(img,2);
    y=1:size(img,1);
    xMean=xyMean(1);yMean=xyMean(2);xVar=xyVar(1);yVar=xyVar(2);
    
    probX=(1/sqrt(2*pi*xVar))*exp(-(x-xMean).^2/2*xVar);%calculate all outputs of the gaussian pdf for each x=1:80
    probY=(1/sqrt(2*pi*yVar))*exp(-(y-yMean).^2/2*yVar);%calculate all outputs of the gaussian pdf for eacy y=1:80
    
    all=allcomb(probX,probY);%combine all probs of X with all probs of Y to get the probs for all the pixels of the img
    probs=all(:,1).*all(:,2);%for each pixel, multiply the prob of its x coordinate * prob of y coordinate (0..0,0167)
   conf=reshape(probs,80,80);
    n=reshape(conf,[],1);%reshape into a column vector
    n=(n-min(n))/(max(n)-min(n));%normalise between 0 and 1
    %spConf=reshape(n,80,80);%reshape into a 80x80 matrix
    %imagesc(spConf);
    conf=reshape(log(n),80,80);%reshape the logarithm of the calculated prob vector into a 80x80 matrix 
    [predLinear,ind]=max(conf(:));%find the pixel that gives the max multiplication probability
    [py,px] = ind2sub([80 80],ind);%find the pixels x and y coordinates
    %maxPred=[py,px];%you can return this
    
    nums=conf(~isinf(conf));%convert to a col vector and discard any inf elements
    n=conf+abs(min(nums))+1;%transform them to positives
    n(n<0) = 0;%set any -inf elements to 0
    n=reshape(n,[],1);%reshape into a column vector
    n=(n-min(n))/(max(n)-min(n));%normalise between 0 and 1
    spConf=reshape(n,80,80);%reshape into a 80x80 matrix
    
    threshold=0.9;
    prediction=spConf>threshold;%a 80x80 matrix with values=1 if pixel classified as pos or value=0 if pixel classified negative
end