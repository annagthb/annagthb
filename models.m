sift_extract_initial;
expr.ftest=expr.feature(1);
sift_train
save('n1_siftmodel.mat', 'model');
clear

sift_extract_initial;
expr.ftest=expr.feature(2);
sift_train
save('m2_siftmodel.mat', 'model');
clear

sift_extract_initial
expr.ftest=expr.feature(3);
sift_train
save('re3_siftmodel.mat', 'model');
clear

sift_extract_initial;
expr.ftest=expr.feature(4);
sift_train
save('le4_siftmodel.mat', 'model');
clear

sift_extract_initial;
expr.ftest=expr.feature(5);
sift_train
save('reb5_siftmodel.mat', 'model');
clear

sift_extract_initial;
expr.ftest=expr.feature(6);
sift_train
save('leb6_siftmodel.mat', 'model');
clear



sift_extract_initial;
sift_train
save('m2_siftmodel.mat', 'model');
clear


xVar=feat(2).xyVar(1)
xMean=feat(2).xyMean(1)
x=1:80;
probX=(1/sqrt(2*pi*xVar))*exp(-(x-xMean).^2/2*xVar);
plot(probX)
ylabel('probability')
xlabel('x values')



