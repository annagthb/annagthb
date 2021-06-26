function out=sift_extractPositive(H,pt,imgPoints)
    [meanColRow]=findMeanOfPos(pt.patch,imgPoints);
    %extract the patch at the calculated mean
    x=round(meanColRow(1));
    y=round(meanColRow(2));
    out=sift_extract(H,pt,x,y)';
end