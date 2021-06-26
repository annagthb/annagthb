function [bestPar min_error]=kmeans_par_cross(kfold,posdata,negdata)%3 5 10
    npos=size(posdata,1);
    nneg=size(negdata,1);
    data=zeros(size(posdata,2),npos+nneg);
    data(:,1:npos)=posdata';
    data(:,npos+1:npos+nneg)=negdata';
    
    ndata=size(data,2);
    labels=zeros(ndata,1);
    labels(1:npos)=1;
    labels(npos+1:ndata)=-1;
    jumble=randperm(ndata);
    data=data(:,jumble);
    labels=labels(jumble);%anakatose ta data
    
    foldSize=floor(ndata/kfold);%vres pou tha moirazete to kathe fold
    lastFoldSize=foldSize+mod(ndata,foldSize);
    
    par=[1e-3 1e-2 1e-1 1e0 1.5 2 3 4 5 6 8 10];
  
    errors=zeros(1,numel(par));
    folds_errors=zeros(1,kfold);
    clear posdata negdata
    for i=1:numel(par)%1..6
        name=sprintf('-t 0 -c %d\n',par(i));
     
        for j=1:kfold%1..5
            if j~=kfold
                fsize=foldSize;
            else
                fsize=lastFoldSize;
            end    
            start=(j-1)*foldSize;%calculate start of test fold
            test=data(:,start+1:start+fsize);
            testLabels=labels(start+1:start+fsize);
            temp=data;
            temp(:,start+1:start+fsize)=[];
            train=temp;
            templabels=labels;
            templabels(start+1:start+fsize)=[];
            trainLabels=templabels;
            
            %train with the train data
            model=svmtrain(trainLabels,train',name);
            w=model.SVs'*model.sv_coef;
            b=model.rho;
            %test the accuracy on the test data
            for k=1:size(test,2)
                fprintf('par:%d fold:%d testPatch:%d\n',i,j,k);
                p=w'*test(:,k)-b;
                if ((p>=0 && testLabels(k)==-1) || (p<0 && testLabels(k)==1))
                    folds_errors(j)=folds_errors(j)+1;
                end
            end
        end
        errors(i)=mean(folds_errors);
        folds_errors(:)=0;
   end
   [min_error, ind]=min(errors);
   bestPar=par(ind);
end