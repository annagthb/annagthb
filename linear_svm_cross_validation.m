function [pars,results]=linear_svm_cross_validation(posData,negData)
    data=cat(1,posData,negData);
    posLab=ones(size(posData,1),1);
    negLab=-ones(size(negData,1),1);
    labels=cat(1,posLab,negLab);
    clear posLab negLab posData negData
    
%      pars=sprintf('-t 0 -c %d -v 5',ex);
%      ac=svmtrain(labels,data,pars);
%     
    %exc=[1e-5 1e-4 1e-3 1e-2 1e-1 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 7 8];
    %exc=[1e-3 1e-2 1e-1 1e0 1e1];
    exc=[1e-3 1e-2 1e-1 1e0 1.5 2 3 4 5 7 9 10 13 15];
    % finerC=[chosenC-2*0.25 chosenC-0.25 chosenC chosenC+0.25 chosenC+2*0.25];
    % finerG=[chosenG-2*0.25 chosenG-0.25 chosenG chosenG+0.25 chosenG+2*0.25];
   results=zeros(size(exc,2),2);
   results(:,1)=exc;
    accuracy=0;
    for i=1:numel(exc)
%       for j=1:numel(exg)
       pars=sprintf('-t 0 -c %d -v 5',exc(i));
       ac=svmtrain(labels,data,pars);
       results(i,2)=ac;
       fprintf('c:%d ac:%f\n',exc(i),ac);
       if (ac>accuracy)
           accuracy=ac;
           c=exc(i);
%              g=exg(j);
       end
    end
   
    pars=sprintf('-t 0 -c %d',c);
    plot(results(:,1),results(:,2),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
    axis([0 6 60 100]);
    grid;
%     set(gca,'XTick',1e-3:1e1:1e1);
%     set(gca,'XTickLabel',{'-1e-3','1e-2','1e-1','1e0','1e1'})   
   xlabel('parameter C');
   ylabel('accuracy %');
            
end