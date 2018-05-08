# EAST-haozheng

### Introduction
This is a repository forked from [argman/EAST](https://github.com/argman/EAST) for the [ICPR MTWI 2018 CHALLENGE](https://tianchi.aliyun.com/competition/introduction.htm?spm=5176.100066.0.0.144ed780W1xl9s&raceId=231651).
<br>Origin Repository: [argman/EAST - A tensorflow implementation of EAST text detector](https://github.com/argman/EAST)
<br>Origin Author: [argman](https://github.com/argman)
<br>Me: [Haozheng Li](https://github.com/HaozhengLi)
<br>Email: sai-2008@qq.com or akaHaozhengLi@gmail.com

### Contents
1. [About abnormal poly and images](#about)
2. [Download](#download)

### About abnormal poly and images
Some data in [ICPR MTWI 2018](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651) is abnormal, which means the ground true labels are anticlockwise, or the images are not in 3 channels. Then errors like ['poly in wrong direction'](https://github.com/argman/EAST/issues?utf8=%E2%9C%93&q=poly+in+wrong+direction) will occur while using [argman/EAST](https://github.com/argman/EAST).

So I wrote a matlab program to check and transform the dataset. The program named <transform.m> is in the folder 'data_transform/' and its parameters are summarized blow:
```
icpr_img_folder = 'image_9000\';                   %origin images
icpr_txt_folder = 'txt_9000\';                     %origin ground true labels
icdar_img_folder = 'ICPR2018\';                    %transformed images
icdar_gt_folder = 'ICPR2018\';                     %transformed ground true labels
icdar_img_abnormal_folder = 'ICPR2018_abnormal\';  %images not in 3 channels, which give errors in argman/EAST
icdar_gt_abnormal_folder = 'ICPR2018_abnormal\';   %transformed ground true labels

%images must be renamed as <img_1>, <img_2>, ..., <img_xxx> while using argman/EAST
first_index =  0;                                  %first index of the dataset
transform_list_name = 'transform_list.txt';        %file name of the rename list
```
For abnormal images not in 3 channels, please transform them to normal ones through other tools like [Format Factory](http://www.pcfreetime.com/). Then add the right data to the <icdar_img_folder> and <icdar_gt_folder>, so finally you get a whole normal dataset which has been checked and transformed.

### Download
1. Models trained on [ICPR MTWI 2018 (train)](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651): [BaiduYun link]()
2. Models trained on [ICPR MTWI 2018 (train)](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651) + [ICDAR 2017 MLT (train + val)](http://rrc.cvc.uab.es/?ch=8&com=downloads) + [RCTW-17 (train)](http://www.icdar2017chinese.site:5080/dataset/): [BaiduYun link]()


