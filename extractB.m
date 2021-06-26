%extractBootstrap
view=0;
%call the experiments
experiments;
%load the images,the locations of "x", and the labels for each "x"
load('anna_faces.mat','FIMGS','P','pnames');
%fimgs is a 3 dimensional array(cube) with 1609 arrays oof 80x80 elements
nImgs=size(FIMGS,3);
%pnamess are the labels for eyes nose etc and they are 19 (LN,BN,RN etc)
nNames=numel(pnames);
%declare how many positive and negative examples you will get from each img
nNegativesPerImg=3;
nExamplesPerImg=nNegativesPerImg+1;
nNegatives=nImgs*nNegativesPerImg;
%create 2 matrices 1 with positive examples and 1 with negatives
pt=plain_make([],[]);
for f=1:4
    feat(f).pars=plain_make(opts,expr.feature(f).patchSize);
    feat(f).pars.patch=expr.feature(f);
    
    %initialise your matrices
    feat(f).posLabels=ones(nImgs,1);
    feat(f).posExamples=zeros(nImgs,feat(f).pars.patch.patchSize(1)*feat(f).pars.patch.patchSize(2));
    feat(f).negLabels=-ones(nNegatives,1);
    feat(f).negExamples=zeros(nNegatives,feat(f).pars.patch.patchSize(1)*feat(f).pars.patch.patchSize(2));

end
for i=1:nImgs
    %extract positive patches
    img=pt.prep(FIMGS(:,:,i),pt);
    for f=1:4
        patch=pt.extractPositive(img,feat(f).pars,P(:,:,i));
        feat(f).posExamples(i,:)=patch;
        %posLabels(i)=1;

        %extract negative patches
        currentIndex=(i-1)*nNegativesPerImg;%find out where next neg should be stored
        patches=pt.extractNegative(img,feat(f).pars,P(:,:,i),nNegativesPerImg,FIMGS(:,:,i));
        feat(f).negExamples(currentIndex+1:currentIndex+nNegativesPerImg,:)=patches;
        %negLabels(currentIndex+1:currentIndex+nNegativesPerImg)=-1;
    end
end
for f=1:4
    feat(f).posExamples=normalisation(feat(f).posExamples);
    feat(f).negExamples=normalisation(feat(f).negExamples);
end

if view
    figure(1);
    imagesc(blockofpics(feat(1).posExamples',feat(1).pars.patch.patchSize));
    colormap gray;
    colorbar;
    figure(2)
    imagesc(blockofpics(feat(1).negExamples',feat(1).pars.patch.patchSize));
    colormap gray;
    colorbar;
end

