function [model]=train_spatial(xy)
    gauMean=[mean(xy(1,:));mean(xy(2,:))];
    gauVar=[var(xy(1,:));var(xy(2,:))];
    model=[gauMean gauVar]; %xmean  xvar
                            %ymean  yvar
end