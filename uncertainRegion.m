function candidatePoints=uncertainRegion(deadPoint,imgsize,f)%,img)
% *candidatePoints=an nby2 matrix containing all possible points that can 
%  give a negative patch
% *deadPoint=the mean point of the positive patch of the feature we are 
%  looking
% *radius=the radius of the dead region
% *imgSize=an 1by2 vector containing x(height) and y(width) of the img
% *pSize=the patch size
%   ie:
%     imgsize=[80 80];
%     deadPoint=[40 40];
%     radius=5;
%     pSize=[15 15];

    %find out the x's and y's that can give a patch
    height=imgsize(1)-f.patchSize(1)/2;
    width=imgsize(2)-f.patchSize(2)/2;
    %create the rows and cols
    rows=f.patchSize(1)/2+abs(f.meanRowOffset)+1:height;
    cols=f.patchSize(2)/2+1:width;
    %create all the possible points
    allPoints=allcomb(cols,rows);%1,1;1,2;1,3...2,1;2,2;2,3...(all by 2 matrix)
    %caclulate for each point, its distance from the dead point
    %implements the formula (x-xo)^2+(y-yo)^2=radius^2
    distance=sqrt((allPoints(:,1)-deadPoint(1)).^2+(allPoints(:,2)-deadPoint(2)).^2);
    %pick only the points that have distance>radius
    candidatePoints=round(allPoints(distance>f.uncertainRegionRadius,:));
    %returns it as x=col, y=row
    
% %     see a visualised example
% %     uncertainRegion([deadPoint(2) deadPoint(1)],5,[80 80],exp.ftest)
%         figure(52);
%         imagesc(img);
%         colormap gray;
%         hold on;
%         scatter(candidatePoints(:,1),candidatePoints(:,2),'.','red');
% %     x=candidate1=col y=candidate2=row
end

