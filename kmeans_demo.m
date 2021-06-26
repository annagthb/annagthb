% VGG_KMEANS_DEMO A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 30 Nov 02

C1 = [ .8 .8 ];  S1 = [.1 0; 0 .1]; N1 = 1000;
C2 = [ .1 .6 ];  S2 = [.04 0; 0 .1]; N2 = 200;
C3 = [ .5 .3 ];  S3 = [.1 0; 0 .1]; N3 = 2000;

X1 = S1 * randn(2, N1) + repmat(C1(:), 1, N1);
X2 = S2 * randn(2, N2) + repmat(C2(:), 1, N2);
X3 = S3 * randn(2, N3) + repmat(C3(:), 1, N3);

Y = [X1 X2 X3];

clf
plot(Y(1,:), Y(2,:), '.')
set(gcf, 'doublebuffer','on');

axis([0 1 0 1]);
axis equal

while 1
  tic
  [C, sse] = vgg_kmeans(Y, 2, 'verbose', 1);
  toc
 
  [c,d2] = vgg_nearest_neighbour(Y,C);%c= cluster for each point
  plot(Y(1,c==1),Y(2,c==1),'r.');
  hold on
  plot(Y(1,c==2),Y(2,c==2),'g.');
  plot(Y(1,c==3),Y(2,c==3),'b.');

  plot(C(1,:), C(2,:), 'ro');
     
  hold off
  s=silhouette(Y',c);
  ms=mean(s);
  
  pause
end


