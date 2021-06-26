%demo_just_train
%use only after demo_extract
experiments;
ft=expr.ftest.i;
%for f=1:4
for f=ft:ft
    %train classifier   
    feat(f).clasModel=feat(f).pars.train(posExamples(1:datasetOpts.nPosTrain,:),negExamples(1:datasetOpts.nNegTrain,:),trainOpts,datasetOpts,feat(f).pars.patch,dataset,feat(f).pars);
    %train spatial
    feat(f).spatialModel=feat(f).pars.spatialTrain(spatialxy);
    
    %save models and clear variables
    clasModel=feat(f).clasModel;
    spatialModel=feat(f).spatialModel;
    savename=sprintf('feature%d',f);
    save(savename,'posExamples','negExamples','clasModel','spatialModel');
    clear
end