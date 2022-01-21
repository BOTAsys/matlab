%% Clear all variables

close all;
clear all;
clc

runConfig=false;
runPlot=true;

%% Set up the serial port object
SerialPort='/dev/ttyUSB0'; %serial port
BaudRate=460800; %460800;
runtime=20.0; % [s]
timeout=10;

s = serialport(SerialPort,BaudRate,"Timeout",timeout);

%% Config serial port

if (runConfig)
    disp(['Configure sensor on port ',SerialPort,'. This may take a while (~35s).'])
    offset=zeros(6,1);
    configSerial(s,512,offset);
    clear s
    pause(35)
    disp('Sensor is configured');
    s = serialport(SerialPort,BaudRate,"Timeout",timeout);
end

%% Read sensor and plot data

% Set up the figure
nSamples=300;
time=now*ones(nSamples,1);
Fx=zeros(nSamples,1);
Fy=zeros(nSamples,1);
Fz=zeros(nSamples,1);
Mx=zeros(nSamples,1);
My=zeros(nSamples,1);
Mz=zeros(nSamples,1);

if runPlot
    figureHandle = figure('NumberTitle','off',...
        'Name','Real Time Data',...
        'Color',[0 0 0],'Visible','on');

    % Set axes
    ax1 = subplot(2,1,1);
    set(ax1,'Parent',figureHandle,'YGrid','on','YColor',[0.9725 0.9725 0.9725],'XGrid','on','XColor',[0.9725 0.9725 0.9725],'Color',[0 0 0])
    hold on;

    plotHandleFx = plot(ax1,time,Fx,'Marker','.','LineStyle','none','Color',[1 0 0]);
    plotHandleFy = plot(ax1,time,Fy,'Marker','.','LineStyle','none','Color',[0 1 0]);
    plotHandleFz = plot(ax1,time,Fz,'Marker','.','LineStyle','none','Color',[0 0 1]);

    % Create xlabel
    xlabel('Time','FontWeight','bold','FontSize',14,'Color',[1 1 0]);

    % Create ylabel
    ylabel('Force [N]','FontWeight','bold','FontSize',14,'Color',[1 1 0]);

    % Create title

    ax2 = subplot(2,1,2);
    set(ax2,'Parent',figureHandle,'YGrid','on','YColor',[0.9725 0.9725 0.9725],'XGrid','on','XColor',[0.9725 0.9725 0.9725],'Color',[0 0 0])
    hold on;

    plotHandleMx = plot(ax2,time,Mx,'Marker','.','LineStyle','none','Color',[1 0 0]);
    plotHandleMy = plot(ax2,time,My,'Marker','.','LineStyle','none','Color',[0 1 0]);
    plotHandleMz = plot(ax2,time,Mz,'Marker','.','LineStyle','none','Color',[0 0 1]);

    % Create xlabel
    xlabel('Time','FontWeight','bold','FontSize',14,'Color',[1 1 0]);

    % Create ylabel
    ylabel('Torques [N]','FontWeight','bold','FontSize',14,'Color',[1 1 0]);
end

% Run the sensor in a loop
tStart=now;
tNow=now;
count=0;
flush(s)
while tNow<tStart+runtime*1e-5
%     disp(s.NumBytesAvailable)
    [Status, Wrench, Timestamp, Temperature] = readSerialFrame(s);
    
    if (Status>=0)
        tNow=now;
        
        if runPlot
            if (count==1)
                time=double(Timestamp)*1e-6*ones(nSamples,1);
                Fx=Wrench(1)*ones(nSamples,1);
                Fy=Wrench(2)*ones(nSamples,1);
                Fz=Wrench(3)*ones(nSamples,1);
                Mx=Wrench(4)*ones(nSamples,1);
                My=Wrench(5)*ones(nSamples,1);
                Mz=Wrench(6)*ones(nSamples,1);
            end

            Fx(mod(count,nSamples)+1)=Wrench(1);
            Fy(mod(count,nSamples)+1)=Wrench(2);
            Fz(mod(count,nSamples)+1)=Wrench(3);
            Mx(mod(count,nSamples)+1)=Wrench(4);
            My(mod(count,nSamples)+1)=Wrench(5);
            Mz(mod(count,nSamples)+1)=Wrench(6);
            time(mod(count,nSamples)+1)=double(Timestamp)*1e-6;
            
            if mod(count,10)==0
                set(plotHandleFx,'YData',Fx,'XData',time);
                set(plotHandleFy,'YData',Fy,'XData',time);
                set(plotHandleFz,'YData',Fz,'XData',time);
                set(plotHandleMx,'YData',Mx,'XData',time);
                set(plotHandleMy,'YData',My,'XData',time);
                set(plotHandleMz,'YData',Mz,'XData',time);
                set(figureHandle,'Visible','on');
            end

            pause(0.0001);
        end
        count = count +1;
    end
end
disp(['Samples received: ',num2str(count)])
flush(s)
%% Clean up the serial port
clear s;
