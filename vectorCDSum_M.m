function CD = vectorCDSum_M(DT, DT1, DT2, X_oi)

    global conf;
    global DTobj1;
    global DTobj2;

    sum_CD1 =zeros(1,length(X_oi));
    sum_CD2 = zeros(1,length(X_oi));
    
    if (length(X_oi)<1)
        error('features are out-of-bound');
    end

    sum_CD1 = (DTobj1(X_oi(2,:),X_oi(1,:)))';
    sum_CD1 = sum_CD1.^2;

    sum_CD2 = (DTobj2(X_oi(2,:),X_oi(1,:)))';
    sum_CD2 = sum_CD2.^2;

    for i=1:length(X_oi)    
        if ((X_oi(1,i))<1) || ((X_oi(1,i))>conf.map_size(2)) ||  ((X_oi(2,i))<1) || ((X_oi(2,i))>conf.map_size(1))
            sum_CD1(i) = 150;
            sum_CD2(i) = 150;
            continue;

        end

    end

    CD = sum_CD1 + sum_CD2;

end