experiments;
%loads the images, the labels, and the position of the 'x'
load('anna_faces.mat','FIMGS','P','pnames');
%fimgs is a 3 dimensional array with 1609 arrays oof 80x80 elements
n=size(FIMGS,3);

%pnamess are the labels for eyes nose etc and they are 19 (LN,BN,RN etc)
np=numel(pnames);
%p is a 3 dimensional array 2x19 that stores the positions(x,y) of the 'x's
%for the 1609 images

%goes through all the images(using the 3rd dimension of the array FIMGS(::i)
for i=1:n
    %displays the image in position i of the FIMGS array
	imagesc(FIMGS(:,:,i));
	hold on;
    
    %plots the "x" positions of the features on the image
	plot(P(1,:,i),P(2,:,i),'r.','linewidth',2,'markersize',10);
    %(1,1)=lnx (2,1)=lny (1,2)=bnx (2,2)=bny (1,3)=rnx (2,3)=rny
    drawPatch(expr.ftest,P(:,:,i));
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

