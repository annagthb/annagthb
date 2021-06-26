function pt=sift_initialisation(datasetOpts,f)
step=f.pars.sift.sigma;
ptsz=f.pars.patch.patchSize/2;

w=floor(ptsz(2)/step)*step;%patch width(half)=6
h=floor(ptsz(1)/step)*step;%patch heig
xcells=numel(-w:step:w);
ycells=numel(-h:step:h);
nEls=xcells*ycells*f.pars.sift.bins+1;

pt.posExamples=zeros(datasetOpts.nPosTrain,nEls);
pt.posLabels=zeros(datasetOpts.nImages,1);
pt.negLabels=zeros(datasetOpts.nNegTrain,1);
pt.negExamples=zeros(datasetOpts.nNegTrain,nEls);
end