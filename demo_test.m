%initialise vars
view=1;
k=1;
experiments;
feature=struct('clasModel',{},'spatialMean',{},'spatialVar',{});
res=struct('prob',{[],[],[]},'title',{'appearance model','spatial model','appearance and spatial model'});
finfo=struct('pars',{});
step=opts.sift.sigma;%in case we use sift descriptor

%initialise descriptor parameters
for f=1:4
    
    finfo(f).pars=expr.descriptor(opts,expr.feature(f).patchSize);
    finfo(f).pars.patch=expr.feature(f);
end

ft=expr.ftest.i;
ft=2;
 for i=datasetOpts.nPosTrain:datasetOpts.nPosTrain+datasetOpts.nTest
%for i=800:900
%for i=1:10
    fprintf('image: %d\n',i);
    %for f=1:4
     for f=ft:ft   
        %load model
         %name=sprintf('feature%d plain single',f);
        %name=sprintf('feature%d plain mixture',f);
        %name=sprintf('feature%d sift single',f);
        %name=sprintf('feature%d sift mixture',f);
        name=sprintf('mfeature%d sift 2clusters new ptsz',f);
         load(name,'clasModel','spatialModel');
        feature(f).clasModel=clasModel;
        feature(f).spatMean=spatialModel(:,1);
        feature(f).spatVar=spatialModel(:,2);
       
        
        
        %probabilities
        [q res(1).prob]=finfo(f).pars.classifierPredict(feature(f).clasModel,double(dataset.images(:,:,i)),finfo(f).pars);
        feature(f).res(1).prob=res(1).prob;
        %         figure(45)
%         imagesc(ok1)
%         figure(46)
%         imagesc(ok2)
%         feature(f).res(1).prob=res(1).prob;
        [q res(2).prob]=finfo(f).pars.spatialPredict(dataset.images(:,:,i),feature(f).spatMean,feature(f).spatVar);
        feature(f).res(2).prob=res(2).prob;
        res(3).prob=3*res(1).prob+res(2).prob;
        feature(f).res(3).prob=res(3).prob;
        
        %true point
        [trueXY]=findMeanOfPos(finfo(f).pars.patch,dataset.imagePoints(:,:,i));
        feature(f).trueX=round(trueXY(1));feature(f).trueY=round(trueXY(2));
        
        %euclidean distance
        
      
        for m=1:3%1=clas 2=spat 3=comb
            [res(m).maxProb index]=max(res(m).prob(:));%find max pixel prob and index
            [feature(f).yMax(m) feature(f).xMax(m)]=ind2sub(size(res(m).prob),index);%convert linear ind to 2d
          
            feature(f).res(m).eucl(k)=sqrt((feature(f).trueX-feature(f).xMax(m))^2+(feature(f).trueY-feature(f).yMax(m))^2);
           
        end
       
        
    end
    k=k+1;
    
    if view
        for m=1:3%g 1=clas 2=spat 3=comb
            figure(1)
            subplot(1,3,m);
%             imagesc(repmat(dataset.images(:,:,i),[1 1 3]));
            imagesc(dataset.images(:,:,i));
            colormap gray;
            title(res(m).title);
            hold on;
            for f=ft:ft %plot ta true kai predicted points g to 1=clas 2=spat 3=comb
                plot(feature(f).trueX,feature(f).trueY,'gx','linewidth',3,'markersize',10);
                plot(feature(f).xMax(m),feature(f).yMax(m),'rx','linewidth',3,'markersize',10);  
%                     ptsz=expr.feature(f).patchSize-4;
%                     xcol=ceil(feature(f).trueX-ptsz(2)/2);
%                     yrow=round(feature(f).trueY-ptsz(1)/2);
%                     %plot(feature(f).trueX,feature(f).trueY,'gx','linewidth',2','markersize',10);
%                     rectangle('Position',[xcol yrow ptsz(2)
%                     ptsz(1)],'EdgeColor','g','LineWidth',2)%x y width height
                axis image;
                drawnow;
            end
        end
%         %plot probabilities for a particular feature into another figure 
        figure(2)
        subplot(1,4,1);
         %%   imagesc(repmat(dataset.images(:,:,i),[1 1 3]));%creates 3 copies of the img
        imagesc(dataset.images(:,:,i));
        colormap gray;
        freezeColors;
        axis image;

        hold on;
            %%dialexe 1 feature
        plot(feature(ft).xMax(3),feature(ft).yMax(3),'rx','linewidth',4,'markersize',10);
        hold off;
        for r=1:3
            subplot(1,4,r+1);
            imagesc(feature(ft).res(r).prob);
            title(res(r).title);
            axis image;
            colormap jet;
            freezeColors;
        end
        axis image;
%     %         for r=1:3
    %             figure(10+r);
    %             imagesc(feature(ft).res(r).prob);
    %             title(res(r).title);
    %             colormap jet;
    %             colorbar;
    %         end
        pause;
        clf;
    end
end

%plot euclidean distance of feature 2
colour=['r','g','b'];
figure(45);
for m=1:3
    [s,sIndex]=sort(feature(f).res(m).eucl);
    x=s;
    y=(1:numel(s))/numel(s);
    indices=find(diff(x)==0);
    x(indices)=[];
    y(indices)=[];
    plot(x,y,colour(m),'markersize',10,'linewidth',2);
    grid;
    xlabel('Euclidean distance (in pixels)');
    ylabel('proportion of images within distance');
    axis([0 10 0 1]);
    hold on;
end
legend('classifier','spatial model','classifier and spatial model');
name=sprintf('mmresults%d sift 2clusters new ptsz',ft);
save(name,'feature');
%save('feature3 most recent euclidean','feature')
