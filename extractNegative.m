function out=extractNegative(img,pars,points,n,ok)
%input1=the details of the feature(structure type) you want to extract neg
%input2=the points coordinates for the given img
%input3=img you want to extract the patch from
%out=a negative patch of the given feature in the given image

    [meanColRow]=findMeanOfPos(pars.patch,points);
    %find out all the points that give a negative patch
    negativePoints=uncertainRegion(meanColRow,size(img),pars.patch);%,img);
    %choose n points at random from the negative set
    jumble=randperm(size(negativePoints,1));
    chosen=jumble(1:n);
    %find out which point is at the chosen index
    patchMeans=negativePoints((chosen),:);
    %extract the patch at the chosen point
    out=extractPatch(img,pars.patch.patchSize,patchMeans(:,1),patchMeans(:,2));  
end