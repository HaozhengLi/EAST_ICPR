%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: rename.m
%  Description:
%    Rename ICPR018 dataset image name.
%    A rename list will be generated.
%    Normal and abnormal img will be put into different folders. While
%  abnormal means the number of img channel is not equal to 3.
%    For abnormal img, please transform them to normal ones through other
%  tools like Format Factory.
%
%    Origin img name: <T1._WBXtXdXXXXXXXX_!!0-item_pic.jpg.jpg>
%    New img name: <img_1.jpg>
%
%  Author: Haozheng Li
%  EMail: 466739850@qq.com
%  Created Time: 2018.5.15
%  Last Revised: 2018.5.15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

clc;
clear;
close all;
fclose('all');

%Parameter
icpr_img_folder = 'image_10000\';
icdar_img_folder = 'ICPR2018_test\';
icdar_img_abnormal_folder = 'ICPR2018_test_abnormal\';

icpr_count =  10000;
rename_list_name = 'rename_list.txt';

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

delete(rename_list_name);
transform_list = fopen(rename_list_name, 'w');

icpr_img_dir = dir(icpr_img_folder);
% icpr_count =  0;
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
%     temp_img = imread(icdar_img_path);
%     if size(size(temp_img), 2) > 3
%         temp_img = temp_img(:, :, 1);
%     end
%     imshow(temp_img);
    
    fprintf(transform_list, '%s %s\n', icdar_img_name(1 : end - 4), icpr_img_name(1 : end - 4));
    if rem(icpr_count, 100) == 0
        fprintf('transform %d...\n', icpr_count);
    end
%     pause(0.01);
end
fclose(transform_list);

fprintf('%d files have transformed.\n', icpr_count);

