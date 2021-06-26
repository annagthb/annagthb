%test on pars
%ptsz row=7..20 col 13:25
rows=7:2:20;
cols=13:2:25;
ptsz=allcomb(rows,cols);
np=size(ptsz,1);
accur=zeros(np,2);
bestC=zeros(4,2);
experiments
for f=1:4
    for p=1:np
        feat(f).pars=expr.descriptor(opts,ptsz);
        feat(f).pars.patch=expr.feature(f);
        feat(f).pars.patch.patchSize=ptsz(p,:);
        feat(f).data=feat(f).pars.initialisation(datasetOpts,feat(f));
        
        for i=1:datasetOpts.nPosTrain
            fprintf('feature:%d patch:%d img:%d\n',f,p,i);
            %extract classifier's data
            img=feat(f).pars.prep(dataset.images(:,:,i),feat(f).pars);
            patch=feat(f).pars.extractPositive(img,feat(f).pars,dataset.imagePoints(:,:,i));
            feat(f).data.posExamples(i,:)=patch;
            k=(i-1)*datasetOpts.nNegPerImg;
            patches=feat(f).pars.extractNegative(img,feat(f).pars,dataset.imagePoints(:,:,i),datasetOpts.nNegPerImg,dataset.images(:,:,i));
            feat(f).data.negExamples(k+1:k+datasetOpts.nNegPerImg,:)=patches;
        end
        %train accur1=bestpar accur2=error
        [accur(p,1) accur(p,2)]=pars_cross_validation(3,feat(f).data.posExamples,feat(f).data.negExamples(1:3000,:));
    end    
    feat(f).data.posExamples=feat(f).pars.normalisation(feat(f).data.posExamples);
    feat(f).data.negExamples=feat(f).pars.normalisation(feat(f).data.negExamples);
    [bestC(f,2) ind]=min(accur(:,2));
    bestC(f,1)=accur(ind,1);

    
end   