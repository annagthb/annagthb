function pt = sift_make(opts,sz)
%extracts the cells
sz=sz/2;
pt.sift=opts.sift;
pt.norml2=pt.sift.norml2;

pt.x=[];
pt.y=[];
pt.z=[];
n=numel(pt.sift.sigma);
for i=1:n
    step=pt.sift.sigma(i);%cell space(size) 2x2
    w=floor(sz(1)/step)*step;%patch width(half)=6
    h=floor(sz(2)/step)*step;%patch height(half)=6
    [X,Y]=meshgrid(-w:step:w,-h:step:h);%-6 -4 -2 0 2 4 6=7 gia to x kai 7 g to y. 7*7=49 points. 1 gia to pou xekina kathe cell mesa sto patch
    pt.x=[pt.x ; X(:)];%concatenates new x with the old ones and creates a col vector
    pt.y=[pt.y ; Y(:)];
    pt.z=[pt.z ; ones(numel(X),1)*i];%[11111122222223333333nnnnnnn]
end

pt.prep=@sift_prep;
pt.extract=@sift_extract;
pt.extractPositive=@sift_extractPositive;
pt.extractNegative=@sift_extractNegative;
pt.classifierPredict=@sift_classifierPredict;
pt.spatialPredict=@spatialPredict;
pt.normalisation=@sift_normalisation;
pt.initialisation=@sift_initialisation;
pt.train=@sift_linear_svm4;
%pt.train=@sift_linear_cluster_svm;
pt.spatialTrain=@train_spatial;
end

