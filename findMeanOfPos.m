function [meanColRow]=findMeanOfPos(patchPars,points)
%finds the mean point(xCol,yRow) of the feature
%we need the indices of where the coordinates of the feature labels are stored
% and the rowoffset of the mean row
%input1=feature details
%input2=labeled coordinates of thecurrent img
%output=(xCol,yRow) mean point of the feature
%   points(3,:)=[];
    %get the coordinates of the feature points that have been labelled
    %find out where the positive patch is,according to the labeledcoordinates
    %(1,1)=lnx (2,1)=lny (1,2)=bnx (2,2)=bny (1,3)=rnx (2,3)=rny
    coordinates(1:2,1:numel(patchPars.pointsIndices))=points(:,patchPars.pointsIndices);
    %calculate meanCol and meanRow
    meanColRow(1)=mean(coordinates(1,:));
    meanColRow(2)=mean(coordinates(2,:))+patchPars.meanRowOffset;
    
end
