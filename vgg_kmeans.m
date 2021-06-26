function [CX, sse] = vgg_kmeans(X, nclus, varargin)

% VGG_KMEANS    initialize K-means clustering
%               [CX, sse] = vgg_kmeans(X, nclus, optname, optval, ...)
%
%               - X: input points (one per column)
%               - nclus: number of clusters
%               - opts (defaults):
%                    maxiters (inf): maxmimum number of iterations
%                    mindelta (eps): minimum change in SSE per iteration
%                       verbose (1): 1=print progress
%
%               - CX: cluster centers
%               - sse: SSE (sum of squared error-used to compare different
%               runs of the k means algo) min this distance of each point
%               from its cluster centre
%               %%%- inter: distance between all the cluster centres. max this
%               %%%-min sse/inter

% Author: Mark Everingham <me@robots.ox.ac.uk>
% Date: 13 Jan 03

opts = struct('maxiters', inf, 'mindelta', eps, 'verbose', 0);
if nargin > 2
    %opts=vgg_argparse(opts,varargin);
    if (size(varargin)==3)
        opts.maxiters=varargin(1);
        opts.mindelta=varargin(2);
        opts.verbose=varargin(3);
    elseif (size(varargin)==2)
        opts.maxiters=varargin(1);
        opts.mindelta=varargin(2);
    elseif (size(varargin)==1)
        opts.maxiters=varargin(1);
    end
end

perm=randperm(size(X,2));
CX=X(:,perm(1:nclus));

sse0 = inf;
iter = 0;
while iter < opts.maxiters

    tic;    
    [CX, sse] = vgg_kmiter(X, CX);    
    t=toc;
    
    %%%%%%
%     nC=size(CX,2);
%     d=0;
%     po=0;
%     for i=1:nC-1
%         for j=i+1:nC
%             for k=1:size(CX,1)%dimension of the data
%                 po=po+(CX(k,i)-CX(k,j))^2;
%             end
%             d=d+sqrt(po);
%             po=0;
%         end
%     end
%     value=sse/d;
    %%%%%%%%%%
    
    if opts.verbose
        %fprintf('iter %d: sse = %g value = %g (%g secs)\n', iter, sse, value, t)
        fprintf('iter %d: sse = %g (%g secs)\n', iter, sse, t)
    end
    
    if sse0-sse < opts.mindelta
        break
    end

    sse0=sse;
    iter=iter+1;
        
end

