function [negPoints,hei,wid]=findAllNegPoints(f,points,imgsize)%,img)
%input1=features details
%input2=the coordinates of the points of the feature
%input3=the imgSize

    [meanColRow]=findMeanOfPos(f,points);
    negPoints=uncertainRegion(meanColRow,imgsize,f);%img);
    %find out the x's and y's that can give a patch
    height=imgsize(1)-f.patchSize(1);
    width=imgsize(2)-f.patchSize(2);
    %calculate new height and width
    rows=f.patchSize(1)/2+abs(f.meanRowOffset)+1:height;
    cols=f.patchSize(2)/2+1:width;
    hei=size(rows,2);
    wid=size(cols,2);
end