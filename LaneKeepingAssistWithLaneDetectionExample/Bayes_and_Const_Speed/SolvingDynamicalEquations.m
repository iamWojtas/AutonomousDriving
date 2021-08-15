clc

dp = [10*ones(1,10)]';
dm = [0:9]';
d = [5*ones(1,10)]';

P(d,dp,dm)

function out = P(d,dp,dm)

    o1 =  min(d,dp)
    out = max(o1,dm)
    
end
