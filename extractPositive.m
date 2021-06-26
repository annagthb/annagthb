function out=extractPositive(img,pars,points)
%input1=the details of the feature(structure type) you want to extract
%input2=the points coordinates for the given img
%input3=img you want to extract the pos patch from
%out=the positive patch psizeByPsize of the given feature in the given image
    [meanColRow]=findMeanOfPos(pars.patch,points);
    %extract the patch at the calculated means
    out=extractPatch(img,pars.patch.patchSize,meanColRow(:,1),meanColRow(:,2));
end