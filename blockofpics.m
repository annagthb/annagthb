function [out, layout] = blockofpics(v, imagesize, ncolumns, bg)

if nargin<4
    bg=0;
end

if nargin<3
    ncolumns=ceil(sqrt(size(v,2)));
end

% AWF_BLOCKOFPICS Convert images in columns to a ncolumns-wide block
%               out = awf_blockofpics(v, [H W], ncolumns)

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 14 Nov 01

npels = prod(size(v));
nimages = npels / prod(imagesize);
if nimages ~= floor(nimages)
  error(sprintf('blockofpics: sizes are wrong -- I got %g images\n', ...
      nimages));
end

H = imagesize(1);
W = imagesize(2);

vv = reshape(v, H, W * nimages);

nrows = floor((nimages + ncolumns-1) / ncolumns);
% fprintf('blockofpics: %d x %d images, each %d x %d\n', nrows, ncolumns, H, W);

total = nrows * ncolumns;

% Extend V
if total > nimages
%   vv(H, W * total) = 0;
  vv(:, (nimages*W+1):W * total) = bg;
end

vv = reshape(vv', ncolumns * W, nrows * H)';

I = 1:H*nrows;
I = reshape(I, nrows, H);
I = I';
I = I(:);

out = vv(I,:);

if nargout > 1
  layout = [nrows ncolumns];
end
