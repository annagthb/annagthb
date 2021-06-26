function out=sift_extractNegative(H,pt,imgPoints,n,img)
    [meanColRow]=findMeanOfPos(pt.patch,imgPoints);
    %find out all the points that give a negative patch
    negativePoints=uncertainRegion(meanColRow,size(img),pt.patch);%,img);
    %choose n points at random from the negative set
    jumble=randperm(size(negativePoints,1));
    chosen=jumble(1:n);
    %find out which point is at the chosen index
    patchMeans=negativePoints((chosen),:);
    x=round(patchMeans(:,1))';
    y=round(patchMeans(:,2))';
    %extract the patch at the chosen point
    out=sift_extract(H,pt,x,y)';  
end