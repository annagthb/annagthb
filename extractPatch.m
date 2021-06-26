function out=extractPatch(img,pSize,meansX,meansY)
    %extract patches from a given img
    %give the mean coordinates of each patch and the patches will be extracted
    %input1=mean coordinates of the patch [row col]
    %input2=patchsize [height width]
    %input3=the img from where the patch will be extracted
    %output=a patch matrix of size pSize(1) by pSize(2)

    assert(all(mod(pSize,2)));%verifies that the patchSize width and height are odd numbers

    x=round(meansX);%round the means for each patch. col
    y=round(meansY);%row
    pw=(pSize(2)-1)/2;%the median of the width.col
    ph=(pSize(1)-1)/2;%the median of height.row
    n=numel(x);
   
    [X,Y]=meshgrid(-pw:pw,-ph:ph);%the mean of the patch is recorded as 0
    off=(X(:)*size(img,1)+Y(:))';%calculates linear index for each pixel of the patch size(img,2)=width
    
    center=(x-1)*size(img,1)+y;%-1;%calculates linear index of each mean
 
    pixelsIndices=ones(n,1)*off+center*ones(1,numel(off));%linear indices of the pixels of all the wanted patches.patch's pixels are stored in rows
    out=img(pixelsIndices);%prosthetei ta off indices me ta centers gia na vrei linear indices ton pixels tou kathe patch
end