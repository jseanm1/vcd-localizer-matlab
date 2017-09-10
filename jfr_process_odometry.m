[r, c] = size(odomMsgs);
odomX = zeros(r,c+1);
odomY = zeros(r,c+1);
odomZ = zeros(r,c+1);

start = odomMsgs{1}.Header.Stamp.Sec*1000000000 + odomMsgs{1}.Header.Stamp.Nsec;

for i=1:r
    temp = odomMsgs{i}.Header.Stamp.Sec*1000000000 + odomMsgs{i}.Header.Stamp.Nsec;
    if (temp < start)
        temp = start;
    end
end



for i=1:r
    t = ((odomMsgs{i}.Header.Stamp.Sec*1000000000 + odomMsgs{i}.Header.Stamp.Nsec) - start)/1000000000;
    odomX(i,1) = odomMsgs{i}.Pose.Pose.Position.X;
    odomX(i,2) = t;
    odomY(i,1) = odomMsgs{i}.Pose.Pose.Position.Y;
    odomY(i,2) = t;
    odomZ(i,1) = odomMsgs{i}.Pose.Pose.Position.Z;
    odomZ(i,2) = t;
end

[r, c] = size(clog1Msgs);
clog1X = [];
clog1Y = [];
clog1Z = [];

for i=1:r
    t = ((clog1Msgs{i}.Header.Stamp.Sec*1000000000 + clog1Msgs{i}.Header.Stamp.Nsec) - start)/1000000000;
    if t <= 70
        clog1X(end+1,:) = [clog1Msgs{i}.Pose.Pose.Position.Y, t];
        clog1Y(end+1,:) = [-clog1Msgs{i}.Pose.Pose.Position.X, t];
        clog1Z(end+1,:) = [clog1Msgs{i}.Pose.Pose.Position.Z, t];
    end
end

[r, c] = size(clog2Msgs);
clog2X = [];
clog2Y = [];
clog2Z = [];

for i=1:r
    t = ((clog2Msgs{i}.Header.Stamp.Sec*1000000000 + clog2Msgs{i}.Header.Stamp.Nsec) - start)/1000000000;
    if t >= 40
        clog2X(end+1,:) = [clog2Msgs{i}.Pose.Pose.Position.Y - 15, t];
        clog2Y(end+1,:) = [-clog2Msgs{i}.Pose.Pose.Position.X - 30, t];
        clog2Z(end+1,:) = [clog2Msgs{i}.Pose.Pose.Position.Z, t];
    end
end

figure
title('X')
hold on
plot(odomX(:,2), odomX(:,1),'b');
plot(clog1X(:,2),clog1X(:,1),'r');
plot(clog2X(:,2),clog2X(:,1),'g');
title('X')
xlabel('t')
ylabel('X')
legend('Ground Truth', 'Localizer1', 'Localizer2')

figure
hold on
plot(odomY(:,2), odomY(:,1),'b');
plot(clog1Y(:,2),clog1Y(:,1),'r');
plot(clog2Y(:,2),clog2Y(:,1),'g');
title('Y')
xlabel('t')
ylabel('Y')
legend('Ground Truth', 'Localizer1', 'Localizer2')

hold off

figure
hold on
plot(odomZ(:,2), odomZ(:,1),'b');
plot(clog1Z(:,2),clog1Z(:,1),'r');
plot(clog2Z(:,2),clog2Z(:,1),'g');
title('Z')
xlabel('t')
ylabel('Z')
legend('Ground Truth', 'Localizer1', 'Localizer2')
