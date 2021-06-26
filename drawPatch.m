function drawPatch(f,points)
%input1=the details of the feature(structure type) you want to extract
%input2=the points coordinates for the given img
%result=a rectangle around the patch of the feature

    coordinates(1:2,1:numel(f.pointsIndices))=points(:,f.pointsIndices);
    meanx=mean(coordinates(1,:));
    meany=mean(coordinates(2,:))+f.meanRowOffset;
    xcol=ceil(meanx-f.patchSize(2)/2);
    yrow=round(meany-f.patchSize(1)/2);
	plot(meanx,meany,'gx','linewidth',2','markersize',10);
    rectangle('Position',[xcol yrow f.patchSize(2) f.patchSize(1)])%x y width height
  
end