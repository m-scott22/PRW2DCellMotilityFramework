clear all
close all

load('CTRL25_table.mat');
ctrl=2503;

DT=0.05; %3 mins
NPeriods=960; %48 hours

cells=CTRL25.TRACK_ID;
IDs=unique(cells);
Ncells=size(IDs,1);
time=CTRL25.POSITION_T;
T=linspace(0,NPeriods-1,NPeriods)*DT;

track_data=NaN(Ncells,NPeriods,4);

%Split tracks and give them x and y positions. Put tracks into the array
for i=1:Ncells
    %find where track starts and ends
    first=min(find(cells==IDs(i)));
    last=max(find(cells==IDs(i)));
    x_pos=CTRL25.POSITION_X(first:last);
    x_pos_track=x_pos./1000; %Convert to micrometers
    y_pos=CTRL25.POSITION_Y(first:last);
    y_pos_track=y_pos./1000;
    track_data(i,1:size(x_pos_track,1),3)=x_pos_track';
    track_data(i,1:size(x_pos_track,1),4)=y_pos_track';
end 

tracking_data=NaN(Ncells,NPeriods,4);
%Subtract initial positions
for i=1:Ncells
    for j=1:NPeriods
    tracking_data(i,j,3)=track_data(i,j,3);
    %-track_data(i,1,3);
    tracking_data(i,j,4)=track_data(i,j,4);
    %-track_data(i,1,4);
    end
end


%Calculate velocities
for i=1:Ncells
    for j=1:NPeriods-1
    tracking_data(i,j,1)=(track_data(i,j+1,3)-track_data(i,j,3))/DT;
    tracking_data(i,j,2)=(track_data(i,j+1,4)-track_data(i,1,4))/DT;
    end
end


%Save the data
save(['Alltrajdata2D',num2str(ctrl)])
%%
% Plot trajectories for each cell
figure

for i=1:Ncells
    Xpos=tracking_data(i,:,3);
    Ypos=tracking_data(i,:,4);

plot(Xpos,Ypos)
%pause(0.1)
hold on
end

%axis square
axis([0 max(CTRL25.POSITION_X) 0 max(CTRL25.POSITION_Y)])
xlabel('x position')
ylabel('y position')
