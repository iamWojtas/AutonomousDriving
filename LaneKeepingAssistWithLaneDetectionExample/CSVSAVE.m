cHeader = {'Speed' 'Theta 1' 'Theta 2' 'Theta 3' 'Theta 4'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
%write header to file
fid = fopen('Interpolation.csv','w'); 
fprintf(fid,'%s\n',textHeader)
fclose(fid)
%write data to end of file

dlmwrite('Interpolation.csv',[v asdf],'-append');