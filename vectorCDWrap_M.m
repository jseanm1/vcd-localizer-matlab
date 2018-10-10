%% Vector Chamfer Distance - As a vector
function [VCD] = vectorCDWrap_M(X_h)

    global DT;
    global DT1;
    global DT2;
    global X_ort;
    global mapsize;

    if ~exist('X_h', 'var')|| length(X_h) <3
      VCD=zeros(length(X_ort),1) + 150;
      return;
    end

    if (X_h(1)<1) || (X_h(1)>mapsize(2)) ||  (X_h(2)<1) || (X_h(2)>mapsize(1))

        VCD=zeros(length(X_ort),1) + 150;

        return;
    end

    VCD = vectorCD_M(DT, DT1, DT2 ,X_h,X_ort);

end

function [VCD] = vectorCD_M(DT, DT1, DT2 ,X_h,X_ort)
    X_oi = makeObs(X_h,X_ort);
    X_h;
    VCD = vectorCDSum_M(DT, DT1, DT2,X_oi);
%     VCD = vectorApproxSum(X_oi);

end
