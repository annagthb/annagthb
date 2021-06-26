function pt=plain_cluster_make(opts,patchSize)
pt.prep=@plain_prep;
pt.extract=@extractPatch;
pt.extractPositive=@extractPositive;
pt.extractNegative=@extractNegative;
%pt.train=@linear_svm;
pt.train=@linear_cluster_svm;
pt.classifierPredict=@classifierPredict;
pt.spatialPredict=@spatialPredict;
pt.normalisation=@normalisation;
pt.initialisation=@plain_initialisation;
pt.spatialTrain=@train_spatial;
end