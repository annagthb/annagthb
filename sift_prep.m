function F = sift_prep(I,pt)
%mex mre_gaussorihistperpix.cxx
F=mre_gaussorihistperpix(I,pt.sift.bins,pt.sift.signed,pt.sift.lin,pt.sift.sigma);
