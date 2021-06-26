function [prediction conf]=classifierPredict(cluster,img,pt)
    %input=takes as input a trained model and an image and the feature
    %details
    %output=the pixels that have been classified as positive(prediction) and
    %the confidence for each pixel(conf)
    I=padarray(img,(pt.patch.patchSize-1)/2,'replicate','both');%create extra pixels at the boundary, to be able to calclate prob at the boundary pixels
    xyCoords=allcomb((pt.patch.patchSize(2)-1)/2+1:size(img,2)+(pt.patch.patchSize(2)-1)/2,(pt.patch.patchSize(1)-1)/2+1:size(img,1)+(pt.patch.patchSize(1)-1)/2);
    X=extractPatch(I,pt.patch.patchSize,xyCoords(:,1),xyCoords(:,2));
    % X=im2col(I,f.patchSize,'sliding');%extract the patch for each pixel as a column and store it in X
    X=normalisation(X');%normalise all the patches
    
    nClusters=size(cluster,2);
    for c=1:nClusters
        classifier(c).w=cluster(c).model.SVs'*cluster(c).model.sv_coef;%weights of the classifier for each pixel patch (wx+b)
        classifier(c).b=cluster(c).model.rho;%bias of the classifier
        p=classifier(c).w'*X-classifier(c).b;%apply class to each patch(1 for each pixel)
      
        n=(p-min(p))/(max(p)-min(p));%normalise between 0 and 1
        
       classifier(c).prob=reshape(n,size(img));
    end
    
    
    %take max prob of all classifiers
    if (nClusters~=1)
        for i=1:6400
            for c=1:nClusters
                values(c)=classifier(c).prob(i);
            end
            conf(i)=max(values);
        end
        conf=reshape(conf,size(img));
    else
        conf=classifier(1).prob;
    end
    %above some threshold it will be classified as positive
    %n=reshape(R,1,[]);%reshape it as a vector
    %normalise probabilities to lie between 0 and 1
    
    threshold=0.9;
    prediction=conf>threshold;%a 80x80 matrix with values=1 if pixel classified as pos or value=0 if pixel classified negative
    ok=classifier;
end