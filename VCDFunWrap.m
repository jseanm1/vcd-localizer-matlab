%% Vector Chamfer Distance - Average
function [CD, J, R] = VCDFunWrap(X_h)

    global mapsize;

    if ~exist('X_h', 'var')|| length(X_h) <2
      CD=150;
      return;
    end

    if (X_h(1)<1) || (X_h(1)>mapsize(2)) ||  (X_h(2)<1) || (X_h(2)>mapsize(1))
        CD=150;
        J = 0;
        return;
    end

    CD = vectorCDWrap_M(X_h);
end