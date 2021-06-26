function pt=plain_initialisation(datasetOpts,f)
    pt.posLabels=ones(datasetOpts.nImages,1);
    pt.posExamples=zeros(datasetOpts.nPosTrain,f.pars.patch.patchSize(1)*f.pars.patch.patchSize(2));
    pt.negLabels=-ones(datasetOpts.nNegTrain,1);
    pt.negExamples=zeros(datasetOpts.nNegTrain,f.pars.patch.patchSize(1)*f.pars.patch.patchSize(2));
end