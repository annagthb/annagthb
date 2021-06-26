%test

experiments;
ft=expr.ftest.i;
ac=zeros(1,36);
for f=ft:ft
    for b=1:30
        %initialisation
        opts.sift.sigma=b;
        feat(f).pars=expr.descriptor(opts,expr.feature(f).patchSize);
        feat(f).pars.sift.sigma=b;
        feat(f).pars.patch=expr.feature(f);
        feat(f).data=feat(f).pars.initialisation(datasetOpts,feat(f));
 
        
        %extract
        for i=1:datasetOpts.nImages
            %extract classifier's data
            img=feat(f).pars.prep(dataset.images(:,:,i),feat(f).pars);
            patch=feat(f).pars.extractPositive(img,feat(f).pars,dataset.imagePoints(:,:,i));
            feat(f).data.posExamples(i,:)=patch;
            k=(i-1)*datasetOpts.nNegPerImg;
            patches=feat(f).pars.extractNegative(img,feat(f).pars,dataset.imagePoints(:,:,i),datasetOpts.nNegPerImg,dataset.images(:,:,i));
            feat(f).data.negExamples(k+1:k+datasetOpts.nNegPerImg,:)=patches;

            %extract spatial data
            spatialxy(:,i)=findMeanOfPos(feat(f).pars.patch,dataset.imagePoints(:,:,i));
        end
        feat(f).data.posExamples=feat(f).pars.normalisation(feat(f).data.posExamples);
        feat(f).data.negExamples=feat(f).pars.normalisation(feat(f).data.negExamples);
        posExamples=feat(f).data.posExamples;
        negExamples=feat(f).data.negExamples;

        if ((expr.ftest.i==3) | (expr.ftest.i==4))
            ex=3;
        elseif (expr.ftest.i==1)
            ex=15;
        else
            ex=1.5;
        end

        pars=sprintf('-t 0 -c %d',ex);
        ac(b)=cross_validation(feat(f).data.posExamples(1:datasetOpts.nPosTrain,:),feat(f).data.negExamples(1:datasetOpts.nPosTrain+700,:),ex);
    end
end