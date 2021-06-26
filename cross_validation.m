function ac=cross_validation(posData,negData,ex)
    data=cat(1,posData,negData);
    posLab=ones(size(posData,1),1);
    negLab=-ones(size(negData,1),1);
    labels=cat(1,posLab,negLab);
    clear posLab negLab posData negData
    
     pars=sprintf('-t 0 -c %d -v 5',ex);
     ac=svmtrain(labels,data,pars);
end