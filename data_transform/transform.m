%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: transform.m
%  Description:
%    Transform the format of ground true txt files from ICPR2018 to
%  ICDAR2015.
%    A rename list will be generated.
%    Normal and abnormal img will be put into different folders. While
%  abnormal means the number of img channel is not equal to 3.
%    For abnormal img, please transform them to normal ones through other
%  tools like Format Factory.
%
%    ICPR2018 format: start from bottom left, anticlockwise.
%    <T1._WBXtXdXXXXXXXX_!!0-item_pic.jpg.txt>:
%  48.45,231.83,17.87,178.79,179.84,11.1,228.79,47.95,Ê±ÉÐ´ü´ü
%  ...
%  207.31,354.76,202.31,400.44,172.19,400.44,169.19,351.76,###
%  ...
%
%    ICDAR2015 format: start from top left, clockwise.
%    <gt_img_1.txt> in standard ICDAR but <img_1.txt> in this program:
%  1011,249,1062,255,1062,276,1001,270,###
%  980,37,1041,27,1042,53,981,63,South
%  ..
%
%  Author: Haozheng Li
%  EMail: 466739850@qq.com
%  Created Time: 2018.4.23
%  Last Revised: 2018.5.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

clc;
clear;
close all;
fclose('all');

%Parameter
icpr_img_folder = 'image_9000\';
icpr_txt_folder = 'txt_9000\';
icdar_img_folder = 'ICPR2018\';
icdar_gt_folder = 'ICPR2018\';
icdar_img_abnormal_folder = 'ICPR2018_abnormal\';
icdar_gt_abnormal_folder = 'ICPR2018_abnormal\';

first_index =  0;
transform_list_name = 'transform_list.txt';

%%

%Clean
fprintf('cleaning img folder...\n');
img_dir = dir(icdar_img_folder);
for i = 3 : size(img_dir, 1)
    delete(strcat(icdar_img_folder, '*.*'));
end

img_dir = dir(icdar_img_abnormal_folder);
for i = 3 : size(img_dir, 1)
    delete(strcat(icdar_img_abnormal_folder, '*.*'));
end

fprintf('cleaning gt folder...\n');
gt_dir = dir(icdar_gt_folder);
for i = 3 : size(gt_dir, 1)
    delete(strcat(icdar_gt_folder, '*.*'));
end

gt_dir = dir(icdar_gt_abnormal_folder);
for i = 3 : size(gt_dir, 1)
    delete(strcat(icdar_gt_abnormal_folder, '*.*'));
end

delete(transform_list_name);
transform_list = fopen(transform_list_name, 'w');

icpr_img_dir = dir(icpr_img_folder);
icpr_count =  first_index;
for i = 3 : size(icpr_img_dir, 1)
    %transform img
    icpr_count = icpr_count + 1;
    icpr_img_name = icpr_img_dir(i).name;
    icpr_img_path = strcat(icpr_img_folder, icpr_img_name);
    icdar_img_name = strcat('img_', num2str(icpr_count), '.jpg');
    
    img = imread(icpr_img_path);
    if size(size(img), 2) ~= 3
        copyfile(icpr_img_path, icdar_img_abnormal_folder);
        oldname = strcat(icdar_img_abnormal_folder, icpr_img_name);
        newname = icdar_img_name;
        dos(['rename' 32 oldname 32 newname]);
        icdar_img_path = strcat(icdar_img_abnormal_folder, newname);
    else
        copyfile(icpr_img_path, icdar_img_folder);
        oldname = strcat(icdar_img_folder, icpr_img_name);
        newname = icdar_img_name;
        dos(['rename' 32 oldname 32 newname]);
        icdar_img_path = strcat(icdar_img_folder, newname);
    end
    temp_img = imread(icdar_img_path);
    if size(size(temp_img), 2) > 3
        temp_img = temp_img(:, :, 1);
    end
    imshow(temp_img);
    
    %transform gt
    icpr_txt_name = strcat(icpr_img_name(1 : end - 4), '.txt');
    icpr_txt_path = strcat(icpr_txt_folder, icpr_txt_name);
    txt = fopen(icpr_txt_path, 'r', 'n', 'UTF-8');
    
    icdar_gt_name = strcat('img_', num2str(icpr_count), '.txt');
    if size(size(img), 2) ~= 3
        icdar_gt_path = strcat(icdar_gt_abnormal_folder, icdar_gt_name);
    else
        icdar_gt_path = strcat(icdar_gt_folder, icdar_gt_name);
    end
    gt = fopen(icdar_gt_path, 'w', 'n', 'UTF-8');
    while ~feof(txt)
        %read ICPR2018
        tline = fgetl(txt);
        str = regexp(tline, ',', 'split');
        x1 = str2double(str{1});
        y1 = str2double(str{2});
        x2 = str2double(str{3});
        y2 = str2double(str{4});
        x3 = str2double(str{5});
        y3 = str2double(str{6});
        x4 = str2double(str{7});
        y4 = str2double(str{8});
        cha = str{9};
        
        %write ICDAR2015      
        clockwise = (x2 - x1) * (y3 - y2) - (y2 - y1) * (x3 - x2);
        if clockwise < 0
            temp_x2 = x2;
            temp_y2 = y2;
            x2 = x4;
            y2 = y4;
            x4 = temp_x2;
            y4 = temp_y2;
        end
        if clockwise == 0 
            if (x1 < x2) && (y4 < y1)
                temp_x2 = x2;
                temp_y2 = y2;
                x2 = x4;
                y2 = y4;
                x4 = temp_x2;
                y4 = temp_y2;
            end
            if (x1 > x2) && (y4 > y1)
                temp_x2 = x2;
                temp_y2 = y2;
                x2 = x4;
                y2 = y4;
                x4 = temp_x2;
                y4 = temp_y2;
            end
        end
        line([x1, x2, x3, x4], [y1, y2, y3, y4], 'Color', 'g');
        fprintf(gt, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%s\n', x1, y1, x2, y2, x3, y3, x4, y4, cha);
    end
    fclose(txt);
    fclose(gt);
    
    fprintf(transform_list, '%s %s\n', icdar_gt_name(1 : end - 4), icpr_txt_name(1 : end - 4));
    if rem(icpr_count, 100) == 0
        fprintf('transform %d...\n', icpr_count);
    end
    pause(0.01);
end
fclose(transform_list);

fprintf('%d files have transformed.\n', icpr_count);

