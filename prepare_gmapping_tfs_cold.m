% clear
% clc
% 
% rosinit
% 
% tftree = rostf;
% 
% tfs = {};
% 
% pause(1);
% 
% while true
%     tfs{end+1} = getTransform(tftree, 'map', 'baselink');
%     pause(0.1)
% end

l = length(tfs);

gmapping_pose = zeros(l, 3);

for i=1:l
    translation = tfs{i}.Transform.Translation;
    
    rotation = tfs{i}.Transform.Rotation;
    
    q = [rotation.W, rotation.X, rotation.Y, rotation.Z];
    eul = quat2eul(q);
    
    gmapping_pose(i,:) = [translation.X, translation.Y, eul(1)];
end
    