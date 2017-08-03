%% Generate Observation Model from sensor input and estimated Robot Position
function X_oi_bp = makeObs(X_h,X_ort)

no_features = length(X_ort);

X_oi_bp=zeros(2,no_features);

X_oi_bp(1,:)= X_h(1) +X_ort(1,:).*sin(X_ort(2,:) -  X_h(3) );   % has to be x-y because of the image cordinate
X_oi_bp(2,:)= X_h(2) +X_ort(1,:).*cos(X_ort(2,:) -  X_h(3) );

X_oi_bp = [X_oi_bp; X_ort];
% keyboard

end
