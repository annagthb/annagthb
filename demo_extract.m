%demo extract
experiments;
ft=expr.ftest.i;
%for f=1:4
for f=ft:ft
    %initialisation
    feat(f).pars=expr.descriptor(opts,expr.feature(f).patchSize);
    feat(f).pars.patch=expr.feature(f);
    feat(f).data=feat(f).pars.initialisation(datasetOpts,feat(f));
    
    %extract
    for i=1:datasetOpts.nPosTrain
        %extract classifier's data
        img=feat(f).pars.prep(dataset.images(:,:,i),feat(f).pars);
        patch=feat(f).pars.extractPositive(img,feat(f).pars,dataset.imagePoints(:,:,i));
        feat(f).data.posExamples(i,:)=patch;
        k=(i-1)*datasetOpts.nNegPerImg;
        patches=feat(f).pars.extractNegative(img,feat(f).pars,dataset.imagePoints(:,:,i),datasetOpts.nNegPerImg,dataset.images(:,:,i));
        feat(f).data.negExamples(k+1:k+datasetOpts.nNegPerImg,:)=patches;
        
        %extract spatial data
        spatialxy(:,i)=findMeanOfPos(feat(f).pars.patch,dataset.imagePoints(:,:,i));
    end
    feat(f).data.posExamples=feat(f).pars.normalisation(feat(f).data.posExamples);
    feat(f).data.negExamples=feat(f).pars.normalisation(feat(f).data.negExamples);
    posExamples=feat(f).data.posExamples;
    negExamples=feat(f).data.negExamples;
end
% 
%     figure(200);
%     imagesc(blockofpics(posExamples',expr.feature(f).patchSize));
%     colormap gray;