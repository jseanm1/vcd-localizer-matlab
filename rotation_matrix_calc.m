y = 0.34;
p = 0.23;
y = 0.55;

matlabRotM = eul2rotm([y,p,r])

cy = cos(y);
cp = cos(p);
cr = cos(r);
sy = sin(y);
sp = sin(p);
sr = sin(r);

R = zeros(3,3);

R(1,1) = cp * cy;
R(1,2) = sr * sp * cy - cr * sy;
R(1,3) = cr * sp * cy + sr * sy;
R(2,1) = cp * sy;
R(2,2) = sr * sp * sy + cr * cy;
R(2,3) = cr * sp * sy - sr * cy;
R(3,1) = -sp;
R(3,2) = sr * cp;
R(3,3) = cr * cp;

R

