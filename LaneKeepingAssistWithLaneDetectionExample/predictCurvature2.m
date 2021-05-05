function rho = predictCurvature2(Curvature0,dCurvature,Vx, Ts, PredictionHorizon)
% Curvature0 = initial curvature per unit length                  [1/m]
% dCurvature = (constant) derivative of curvature per unit length [1/m^2]
% CurvatureLength = length for which the clothoid model is valid [m]
% Vx = speed of vehicle

% We want to export a set of curvatures at a uniform sample time ahead.
% t is this vector which goes up to 1 second in the future or having
% enough time to reach the known length in curvature (whichever is smaller)

% To enable truncation by curvelength, mark output "rho" as varsize
%t = 0:Ts:min(1,CurvatureLength/Vx);

t = zeros(PredictionHorizon+1,1);
for i=1:numel(t)
    t(i) = (i-1).*Ts
end

% We compute the curvature vector rho(t) using the specified clothoid model
rho = Curvature0 + dCurvature*Vx*t;





