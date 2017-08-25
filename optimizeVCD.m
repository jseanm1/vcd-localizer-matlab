function [X_opt, cov_Xr] = optimizeVCD(init_pt, Scan_k, ang, conf)

    global X_ort;

    X_ort = laser_read([Scan_k; ang], conf);  % really useful?
    X_ort = gate_laser(init_pt,X_ort);

    [X_opt,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(@VCDFunWrap, init_pt);
    cov_Xr = calcUncertainty(X_ort, X_opt);
end

%% Gate to get rid of outliers
function X_ort = gate_laser(X_h, X_ort)

  VCD = vectorCDWrap_M(X_h);

  cdi = (VCD' < (0.05*X_ort(1,:) + 1));
  X_ort = X_ort(:,cdi);

end
