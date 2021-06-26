function FD = sift_extract(Hist,pars,x,y)

csz=cumprod(size(Hist));%sizeHist=8 1 80 80 csz=8 8 640 51200%gt p kathe pixel xekina 1 cell. k to histograma t exi 8 bins ara 8*6400=51200
%ara ta cells pianoumen ta g ola ta pixels san sliding window
foff=(pars.z-1)*csz(1)+pars.y*csz(2)+pars.x*csz(3);%calculates linear index for each cell of the patch
foff=reshape(ones(csz(1),1)*foff'+(0:csz(1)-1)'*ones(1,numel(foff)),[],1);%7*7*8bins=392. 49 cells in the 144 pixels patch. index for each pixel

IND=foff*ones(1,numel(x))+ones(numel(foff),1)*((y-1)*csz(2)+(x-1)*csz(3)+1);

FD=Hist(IND);
if pars.norml2>=0%fd size=392 bcs 7*7=49 (49 cell points in the 144 patch pixels) 49*8bins=392            
    nrm=sqrt(sum(FD.*FD,1))+pars.norml2;
    FD=FD./(ones(size(FD,1),1)*nrm);
    FD(end+1,:)=1;
end
