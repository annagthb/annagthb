%load data
load('frontal_faces','i','p','d','pnames');%,'pnames');
%fimgs is a 3 dimensional array with 1609 arrays oof 80x80 elements
%images=imgs with visible feature 500x500
%points=their points
%pointr=their radius
%pname=feature names
%imgs=imgs with visible feature scaled to 80x80
%ps=their scaled points
%pointRd=their radius
n=size(i,3);
%pnamess are the labels for eyes nose etc and they are 19 (LN,BN,RN etc)
%np=numel(pnames);
%p is a 3 dimensional array 2x19 that stores the positions(x,y) of the 'x's
%for the 1609 images
images=i;
points=p;
pointr=d;
clear i p d

%goes through all the images(using the 3rd dimension of the array FIMGS(::i)
for i=1:n
    %displays the image in position i of the FIMGS array
	imagesc(images(:,:,i));
	hold on;
    
    %plots the "x" positions of the features on the image
	plot(points(1,:,i),points(2,:,i),'r.','linewidth',2,'markersize',10);
%     for j=1:size(points,2)%1..24
%         sds=1;
%        
%       [x,y]=mre_ellipse(points(1,j,i),points(2,j,i),pointr(1,j,i)*sds,pointr(2,j,i)*sds);
%         plot(x,y,'y-');
%     end
    %pointr(1,:,i)'
    
    
    
    
    %(1,1)=lnx (2,1)=lny (1,2)=bnx (2,2)=bny (1,3)=rnx (2,3)=rny
    %drawPatch(expr.ftest,P(:,:,i));
    %writes the labels on the image j=1..19(the 19 labels we have) for each
    %image
    %for j=1:np
    %   text(P(1,j,i),P(2,j,i),sprintf('%s (%d)',pnames{j},j),'color','y');
	%end
	hold off;
	axis image;
	colormap gray;
    drawnow;
    pause;
end

