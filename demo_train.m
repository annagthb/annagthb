experiments;
ft=expr.ftest.i;
% ft=2;
for f=1:4
%for f=ft:ft
    %initialisation
     feat(f).pars=expr.descriptor(opts,expr.feature(f).patchSize);
    feat(f).pars.patch=expr.feature(f);
%     feat(f).data=feat(f).pars.initialisation(datasetOpts,feat(f));
    
    %extract
    for i=1:datasetOpts.nImages
%         %extract classifier's data
%         img=feat(f).pars.prep(dataset.images(:,:,i),feat(f).pars);
%         patch=feat(f).pars.extractPositive(img,feat(f).pars,dataset.imagePoints(:,:,i));
%         feat(f).data.posExamples(i,:)=patch;
%         k=(i-1)*datasetOpts.nNegPerImg;
%         patches=feat(f).pars.extractNegative(img,feat(f).pars,dataset.imagePoints(:,:,i),datasetOpts.nNegPerImg,dataset.images(:,:,i));
%         feat(f).data.negExamples(k+1:k+datasetOpts.nNegPerImg,:)=patches;
        
        %extract spatial data
        spatialxy(:,i)=findMeanOfPos(feat(f).pars.patch,dataset.imagePoints(:,:,i));
    end
%     feat(f).data.posExamples=feat(f).pars.normalisation(feat(f).data.posExamples);
%     feat(f).data.negExamples=feat(f).pars.normalisation(feat(f).data.negExamples);
%     posExamples=feat(f).data.posExamples;
%     negExamples=feat(f).data.negExamples;
    
 
%     %train classifier   
%     feat(f).clasModel=feat(f).pars.train(posExamples(1:datasetOpts.nPosTrain,:),negExamples(1:datasetOpts.nNegTrain,:),trainOpts,datasetOpts,feat(f).pars.patch,dataset,feat(f).pars);
    %train spatial
    feat(f).spatialModel=feat(f).pars.spatialTrain(spatialxy);
    
    %save models and clear variables
%     clasModel=feat(f).clasModel;
    spatialModel=feat(f).spatialModel;
    savename=sprintf('wf%d spatial',f);
    %save(savename,'posExamples','negExamples','clasModel','spatialModel');
    save(savename,'spatialModel');
    clear
    experiments
end