%% Draw laser
function draw_laser(X_h,laser_scan, conf, mcolor)

    global lasermap, global robothan, global laserhan, global draw_init;

     if nargin < 4
        mcolor =   [0 0 1];
     end

     if ~draw_init

       robothan = plot(lasermap,0,0,'g.') ;
       set(robothan , 'MarkerSize', 20);
       laserhan = plot(lasermap,0,0,'g.') ;
       set(laserhan , 'color', mcolor, 'MarkerSize', 3);
       draw_init = 1;

     end

%     laser_scan = laser_read(laser_scan, conf);  % really useful?

    laser_scan(1,:) = laser_scan(1,:) / conf.map_resolution;
    X_h(1) = X_h(1) / conf.map_resolution;
    X_h(2) = X_h(2) / conf.map_resolution;

    X_oi_bp=zeros(2,length(laser_scan));
    
    for i=1:length(laser_scan)
        if laser_scan(1,i) < conf.laser_reading_max / conf.map_resolution
            X_oi_bp(1,i)= X_h(1) +laser_scan(1,i).*sin(laser_scan(2,i) -  X_h(3) );
            X_oi_bp(2,i)= X_h(2) +laser_scan(1,i).*cos(laser_scan(2,i) -  X_h(3) );
        end
    end
    
    

    %Draw Robot
    %set(robothan,'Visible', 'off');
    %delete(robothan);
    %robothan = plot(lasermap,X_h(1),X_h(2),'r.') ; 
    set(robothan, 'XData', X_h(1), 'YData',X_h(2) );
    %set(robothan , 'MarkerSize', 20);


    %Draw path
    if conf.draw_path
      h= plot(lasermap,X_h(1),X_h(2),'.') ;
      set(h , 'color', [1 0 0], 'MarkerSize', 5);
    end

    if (isfield(conf, 'laser_hold') && conf.laser_hold==1 )
      %Draw Laser
      if ~conf.half_draw
        laserhan = plot(lasermap,X_oi_bp(1,:),X_oi_bp(2,:), '.' , 'color', mcolor, 'MarkerSize', .1);  
      end
    else
      if ~conf.half_draw
        set(laserhan, 'XData',X_oi_bp(1,:), 'YData', X_oi_bp(2,:));
      end
    end


    drawnow limitrate;

    if conf.rec_video
      lasermap_frame= getframe(lasermap);
      writeVideo(conf.aviobj, lasermap_frame);
    end

end