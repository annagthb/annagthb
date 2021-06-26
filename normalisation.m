function new=normalisation(old)
%normalisation function old=6400x225
%input: a matrix m by n (m=number of examples, n=width*height of patch ie total elements of each patch)
%output: a matrix m by n normalised to [0..1]
%implements the formula newpatch=(oldpatch-min)/(max-min)

% %find min for each patch example
minimum=min(old,[],2);

%find max for each patch example and subtract min from it
r=max(old,[],2)-minimum;
%if r=0 make it equal to 1 (because we cant divide by 0)
r(r==0)=1;
%subtract from each pixel of each patch, its min and divide with its max-min
new=old-repmat(minimum,1,size(old,2));
new=new./repmat(r,1,size(old,2));

% % % %new=(old-mean)/std
% means=mean(old,2);
% stds=std(old,0,2);
% r=old-repmat(means,1,size(old,2));
% r(r==0)=1;
% new=r./repmat(stds,1,size(old,2));

end