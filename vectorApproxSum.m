function distances = vectorApproxSum(X_oi)
    global optCPX;
    global optCPY;
    global optKX;
    global optKY;
    global conf;
    global observations;

    xDistances =zeros(1,length(X_oi));
    yDistances = zeros(1,length(X_oi));
    
    if (length(X_oi)<1)
        error('features are out-of-bound');
    end
    
    xDistances = query2DCubicSpline(optCPX, optKX, X_oi(1:2,:)');
    yDistances = query2DCubicSpline(optCPY, optKY, X_oi(1:2,:)');
    
    for i=1:length(X_oi)
        if ((X_oi(1,i))<1) || ((X_oi(1,i))>conf.map_size(2)) ||  ((X_oi(2,i))<1) || ((X_oi(2,i))>conf.map_size(1))
            xDistances(i) = 150;
            yDistances(i) = 150;
            continue;

        end

    end

    distances = [xDistances; yDistances];
    sumsqr(distances)
    
    observations{end+1} = X_oi;
end
