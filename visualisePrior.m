x=1:80;
y=1:80;
probs=zeros(80,80);
for  f=1:4
    %name=sprintf('feature%d sift',f);%www dataset
    name=sprintf('mf%d spatial',f);%mturk
    %name=sprintf('wf%d spatial',f);%www
    load(name)
    feat(f).xmean=spatialModel(1,1);
    feat(f).ymean=spatialModel(2,1);
    feat(f).xvar=spatialModel(1,2);
    feat(f).yvar=spatialModel(2,2);
    
    probX=(1/sqrt(2*pi*feat(f).xvar))*exp(-(x-feat(f).xmean).^2/2*feat(f).xvar);%calculate all outputs of the gaussian pdf for each x=1:80
    probY=(1/sqrt(2*pi*feat(f).yvar))*exp(-(y-feat(f).ymean).^2/2*feat(f).yvar);%calculate all outputs of the gaussian pdf for eacy y=1:80
    
    all=allcomb(probX,probY);%combine all probs of X with all probs of Y to get the probs for all the pixels of the img
    conf=all(:,1).*all(:,2);
    conf=reshape(conf,80,80);
    conf=reshape(conf,[],1);%reshape into a column vector
    conf=(conf-min(conf))/(max(conf)-min(conf));%normalise between 0 and 1
    conf=reshape(log(conf),80,80);
     nums=conf(~isinf(conf));%convert to a col vector and discard any inf elements
    n=conf+abs(min(nums))+1;%transform them to positives
    n(n<0) = 0;%set any -inf elements to 0
    n=reshape(n,[],1);%reshape into a column vector
    n=(n-min(n))/(max(n)-min(n));%normalise between 0 and 1
    feat(f).prob=reshape(n,80,80);%reshape into a 80x80 mat
    
    figure(f*10)
    imagesc(feat(f).prob);
    axis image
    title(name)
  
  probs=max(probs,feat(f).prob);
end
figure(200)
imagesc(probs);
axis image
title(name)
clear


