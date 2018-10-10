function [X_opt, cov_Xr, residual] = optimizeVCD(init_pt, Scan_k, ang, conf)

    global X_ort;
    global t_optimizer;
    global t_cov;
    
    X_ort = laser_read([Scan_k; ang], conf);  % really useful?
    %X_ort = gate_laser(init_pt,X_ort);
    try 
        tic
        [X_opt,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(@VCDFunWrap, init_pt);
        t_optimizer(end+1) = toc;
        
        if nargout > 1
            tic
            cov_Xr = calcUncertainty(X_ort, X_opt);
            t_cov(end+1) = toc;
        end
    catch e
        X_opt = init_pt
        
        if nargout > 1
            cov_Xr = 10000*eye(3);
        end
    end
end

%% Gate to get rid of outliers
function X_ort = gate_laser(X_h, X_ort)

  VCD = vectorCDWrap_M(X_h);

  cdi = (VCD' < (0.05*X_ort(1,:) + 1));
  X_ort = X_ort(:,cdi);

end
