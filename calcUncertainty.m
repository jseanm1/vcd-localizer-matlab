function [cov_Xr] = calcUncertainty(X_ort, X_opt)
    global DTobj1;
    global DTobj2;
    global DT1_dxobj;
    global DT1_dyobj;
    global DT2_dxobj;
    global DT2_dyobj;
    global DT1_dx2obj;
    global DT1_dy2obj;
    global DT2_dx2obj;
    global DT2_dy2obj;
    
    [m,n] = size(X_ort);
    X_o = tfX_ort(X_ort, X_opt, n);
    cov_Srt = eye(n);
    H = zeros(3,3);
    A = zeros(3,n);

    % Set H
    H(1,1) = getd2vcd_dxr2(DTobj1, DTobj2, DT1_dxobj, DT2_dxobj, DT1_dx2obj, DT2_dx2obj, X_o, n);
    H(1,2) = getd2vcd_dxrdyr(DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, X_o, n);
    H(1,3) = getd2vcd_dxrdphir(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT2_dx2obj, X_ort, X_opt, X_o, n);
    H(2,2) = getd2vcd_dyr2(DTobj1, DTobj2, DT1_dyobj, DT2_dyobj, DT1_dy2obj, DT2_dy2obj, X_o, n);
    H(2,3) = getd2vcd_dyrdphir(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dy2obj, DT2_dy2obj, X_ort, X_opt, X_o, n);
    H(3,3) = getd2vcd_dphir2(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT1_dy2obj, DT2_dx2obj, DT2_dy2obj, X_ort, X_opt, X_o, n);

    H(2,1) = H(1,2);
    H(3,1) = H(1,3);
    H(3,2) = H(3,3);

    % Set A
    A(1,:) = getd2vcd_dxrdr(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT2_dx2obj, X_ort, X_opt, X_o, n);
    A(2,:) = getd2vcd_dyrdr(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dy2obj, DT2_dy2obj, X_ort, X_opt, X_o, n);
    A(3,:) = getd2vcd_dphirdr(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT1_dy2obj, DT2_dx2obj, DT2_dy2obj, X_ort, X_opt, X_o, n);        

    % Set J = H-1 * A
    J = -inv(H) * A;

    % Set sensor cov
    cov_Srt = 0.0004 * cov_Srt;
    
    % Set cov_Xr
    cov_Xr = J * cov_Srt * J';
    
end

function [X_o] = tfX_ort(X_ort, X_opt, n)
    X_o = zeros(2,n);
    X_o(1,:)= X_opt(1) + X_ort(1,:) .* sin(X_ort(2,:)-X_opt(3));
    X_o(2,:)= X_opt(2) + X_ort(1,:) .* cos(X_ort(2,:)-X_opt(3));
end


function [d2vcd_dxr2] = getd2vcd_dxr2(DTobj1, DTobj2, DT1_dxobj, DT2_dxobj, DT1_dx2obj, DT2_dx2obj, X_o, n)
    d2vcd_dxr2 = 0;
    
    for i=1:n
        x = X_o(1,i);
        y = X_o(2,i);
        d2vcd_dxr2 = d2vcd_dxr2 + (DT1_dxobj(y,x)^2 + (DTobj1(y,x)*DT1_dx2obj(y,x)) + DT2_dxobj(y,x)^2 + (DTobj2(y,x)*DT2_dx2obj(y,x)));
    end
    
    d2vcd_dxr2 = (2/n) * d2vcd_dxr2;
end

function [d2vcd_dxrdyr] = getd2vcd_dxrdyr(DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, X_o, n)
    d2vcd_dxrdyr = 0;
    
    for i=1:n
        x = X_o(1,i);
        y = X_o(2,i);
        d2vcd_dxrdyr = d2vcd_dxrdyr + ((DT1_dxobj(y,x)*DT1_dyobj(y,x)) + (DT2_dxobj(y,x)*DT2_dyobj(y,x)));
    end
    
    d2vcd_dxrdyr = (2/n) * d2vcd_dxrdyr;
end

function [d2vcd_dxrdphir] = getd2vcd_dxrdphir(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT2_dx2obj, X_ort, X_opt, X_o, n)
    d2vcd_dxrdphir = 0;
    
    for i=1:n
        s = sin(X_ort(2,i)-X_opt(3));
        c = cos(X_ort(2,i)-X_opt(3));
        r = X_ort(1,i);
        x = X_o(1,i);
        y = X_o(2,i);
        
        comp1 = DT1_dxobj(y,x) * (DT1_dxobj(y,x)*c - DT1_dyobj(y,x)*s);
        comp2 = DTobj1(y,x) * DT1_dx2obj(y,x) * c;
        comp3 = DT2_dxobj(y,x) * (DT2_dxobj(y,x)*c - DT2_dyobj(y,x)*s);
        comp4 = DTobj2(y,x) * DT2_dx2obj(y,x) * c;
        
        d2vcd_dxrdphir = d2vcd_dxrdphir  + (r * (comp1+comp2+comp3+comp4));
    end
    
    d2vcd_dxrdphir = (-2/n) * d2vcd_dxrdphir;
end

function [d2vcd_dyr2] = getd2vcd_dyr2(DTobj1, DTobj2, DT1_dyobj, DT2_dyobj, DT1_dy2obj, DT2_dy2obj, X_o, n)
    d2vcd_dyr2 = 0;
    
    for i=1:n
        x = X_o(1,i);
        y = X_o(2,i);
        d2vcd_dyr2 = d2vcd_dyr2 + (DT1_dyobj(y,x)^2 + (DTobj1(y,x)*DT1_dy2obj(y,x)) + DT2_dyobj(y,x)^2 + (DTobj2(y,x)*DT2_dy2obj(y,x)));
    end
    
    d2vcd_dyr2 = (2/n) * d2vcd_dyr2;
end

function [d2vcd_dyrdphir] = getd2vcd_dyrdphir(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dy2obj, DT2_dy2obj, X_ort, X_opt, X_o, n)
    d2vcd_dyrdphir = 0;
    
    for i=1:n
        s = sin(X_ort(2,i)-X_opt(3));
        c = cos(X_ort(2,i)-X_opt(3));
        r = X_ort(1,i);
        x = X_o(1,i);
        y = X_o(2,i);
        
        comp1 = DT1_dyobj(y,x) * (DT1_dxobj(y,x)*c - DT1_dyobj(y,x)*s);
        comp2 = DTobj1(y,x) * DT1_dy2obj(y,x) * s;
        comp3 = DT2_dyobj(y,x) * (DT2_dxobj(y,x)*c - DT2_dyobj(y,x)*s);
        comp4 = DTobj2(y,x) * DT2_dy2obj(y,x) * s;
        
        d2vcd_dyrdphir = d2vcd_dyrdphir + (r * (comp1-comp2+comp3-comp4));
    end
    
    d2vcd_dyrdphir = (-2/n) * d2vcd_dyrdphir;
end

function [d2vcd_dphir2] = getd2vcd_dphir2(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT1_dy2obj, DT2_dx2obj, DT2_dy2obj, X_ort, X_opt, X_o, n)
    d2vcd_dphir2 = 0;
    
    for i=1:n
        s = sin(X_ort(2,i)-X_opt(3));
        c = cos(X_ort(2,i)-X_opt(3));
        r = X_ort(1,i);
        x = X_o(1,i);
        y = X_o(2,i);

        comp1 = r * (DT1_dxobj(y,x)*c - DT1_dyobj(y,x)*s)^2;
        comp2 = DTobj1(y,x) * ((DT1_dx2obj(y,x)*r*(c)^2 - DT1_dxobj(y,x)*s) + (DT1_dy2obj(y,x)*r*(s)^2 - DT1_dxobj(y,x)*c));
        comp3 = r * (DT2_dxobj(y,x)*c - DT2_dyobj(y,x)*s)^2;
        comp4 = DTobj2(y,x) * ((DT2_dx2obj(y,x)*r*(c)^2 - DT2_dxobj(y,x)*s) + (DT2_dy2obj(y,x)*r*(s)^2 - DT2_dyobj(y,x)*c));
        
        d2vcd_dphir2 = d2vcd_dphir2 + (r * (comp1+comp2+comp3+comp4));
    end
    
    d2vcd_dphir2 = (2/n) * d2vcd_dphir2;
end

function [d2vcd_dxrdr] = getd2vcd_dxrdr(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT2_dx2obj, X_ort, X_opt, X_o, n)
    d2vcd_dxrdr = zeros(1,n);
    
    for i=1:n
        s = sin(X_ort(2,i)-X_opt(3));
        c = cos(X_ort(2,i)-X_opt(3));
        x = X_o(1,i);
        y = X_o(2,i);
        
        comp1 = DT1_dxobj(y,x) * (DT1_dxobj(y,x)*s + DT1_dyobj(y,x)*c);
        comp2 = DTobj1(y,x) * DT1_dx2obj(y,x) * s;
        comp3 = DT2_dxobj(y,x) * (DT2_dxobj(y,x)*s + DT2_dyobj(y,x)*c);
        comp4 = DTobj2(y,x) * DT2_dx2obj(y,x) * s;
        
        d2vcd_dxrdr(1,i) = (2/n) * (comp1+comp2+comp3+comp4);        
    end
end

function [d2vcd_dyrdr] = getd2vcd_dyrdr(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dy2obj, DT2_dy2obj, X_ort, X_opt, X_o, n)
    d2vcd_dyrdr = zeros(1,n);
    
    for i=1:n
        s = sin(X_ort(2,i)-X_opt(3));
        c = cos(X_ort(2,i)-X_opt(3));
        x = X_o(1,i);
        y = X_o(2,i);
        
        comp1 = DT1_dyobj(y,x) * (DT1_dxobj(y,x)*s + DT1_dyobj(y,x)*c);
        comp2 = DTobj1(y,x) * DT1_dy2obj(y,x) * c;
        comp3 = DT2_dyobj(y,x) * (DT2_dxobj(y,x)*s + DT2_dyobj(y,x)*c);
        comp4 = DTobj2(y,x) * DT2_dy2obj(y,x) * c;
        
        d2vcd_dyrdr(1,i) = (2/n) * (comp1+comp2+comp3+comp4);
    end
end

function [d2vcd_dphirdr] = getd2vcd_dphirdr(DTobj1, DTobj2, DT1_dxobj, DT1_dyobj, DT2_dxobj, DT2_dyobj, DT1_dx2obj, DT1_dy2obj, DT2_dx2obj, DT2_dy2obj, X_ort, X_opt, X_o, n)
    d2vcd_dphirdr = zeros(1,n);
    
    for i=1:n
        s = sin(X_ort(2,i)-X_opt(3));
        c = cos(X_ort(2,i)-X_opt(3));
        r = X_ort(1,i);
        x = X_o(1,i);
        y = X_o(2,i);
        
        comp1 = DTobj1(y,x) * (DT1_dxobj(y,x)*c - DT1_dyobj(y,x)*s);
        comp2 = DTobj2(y,x) * (DT2_dxobj(y,x)*c - DT2_dyobj(y,x)*s);
        comp3 = (DT1_dxobj(y,x)*s + DT1_dyobj(y,x)*c) * (DT1_dxobj(y,x)*c - DT1_dyobj(y,x)*s);
        comp4 = DTobj1(y,x) * (DT1_dx2obj(y,x)*s*c - DT1_dy2obj(y,x)*c*s);
        comp5 = (DT2_dxobj(y,x)*s + DT2_dyobj(y,x)*c) * (DT2_dxobj(y,x)*c - DT2_dyobj(y,x)*s);
        comp6 = DTobj2(y,x) * (DT2_dx2obj(y,x)*s*c - DT2_dy2obj(y,x)*c*s);
        
        d2vcd_dphirdr(1,i) = (-2/n) * (comp1 + comp2 + r*(comp3 + comp4 + comp5 + comp6));        
    end
end