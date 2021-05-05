function curva = makeCurve(logsout)
    global v

    curvature_log = logsout.getElement('curvature_log');
    curva = curvature_log.Values.Data;
    curva = reshape(curva,numel(curva),1);
    curva = [curva ; zeros(300,1)];
    
    max_acceleration_in_G = (max(abs(curva)))*v^2/9.81
    
end

