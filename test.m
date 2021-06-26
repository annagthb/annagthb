%options
opts.feat.bins=8; % num orientation bins
opts.feat.signed=true; % signed/unsigned orientation
opts.feat.lin=true; % interpolation scheme
opts.feat.sigma=[2]; % size(s) of cells. 2x2. you can use different cell sizes to compute different HOGs(nmz en to xreiazomai)
opts.feat.norml2=1e-6; % normalization
ptsz=[5.5 11.5]; % [half-width half-height]%patchsize
experiments;

%prepare to use the sift functions
pt=sift_make(opts,ptsz);
%pt=plain_make();%the pixel value extract

%%%%%%%%%%%%%%%%%%%%%%%%%
%load the images,the locations of "x", and the labels for each "x"
I=imread('demo.png');
load('anna_faces.mat','FIMGS','P','pnames');
pt.imgs=FIMGS;

%prepare the img(create histograms)
H=pt.prep(opts,pt.imgs(:,:,1),pt);%create histograms for every pixel of the img(6400) giving 6400 cell histograms

%extract patches for the given xy coordinates
x=[30 50 67 50 32];
y=[40 30 22 55 64];
FD=pt.extract(opts,H,pt,x,y);%give it the calculated histograms of the whole img and the cell points of the patchSize and the xy coordinates of ur patch

%read the images
%prepare the images (for sift-> make and prep)
%extract patches
%classifier
%pt.model=pt.trainB;
%test