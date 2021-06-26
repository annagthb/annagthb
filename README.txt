Copyright C Anna Kountouri, Dr Mark Everingham.

*Facial Feature Localisation using Machine Learning Methods in Matlab.
*Firstly the positive and negative face patches are extracted from given image datasets
*Then different machine learning methods are used to represent the facial patches in Matlab like:
	-linear SVM
	-gray level pixel value descriptors
	-HOG descriptors
	-use of bootstrapping
*Then the system is being trained using the extracted patches
*The main frame work uses an Appearance term (probability of a part being present at a particular location of the image)
and a Prior term (Prior probability distribution over configuration) to model and predict the location of each facial feature
in an image.
*Different algorithms (machine learning methods) are used like:
	-mixture of classifiers prediction
	-spatial prediction using Gaussian distribution
	-k means clustering
  are used to determine facial features in a given image.

Source code:
*plain_make.m
*demo_extract.m
*demo_train.m
*demo_test.m
which call the different machine learning methods to train the model and localise the facial features in new images.
