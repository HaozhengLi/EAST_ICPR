# EAST_ICPR

### Introduction
This is a repository forked from [argman/EAST](https://github.com/argman/EAST) for the [ICPR MTWI 2018 CHALLENGE](https://tianchi.aliyun.com/competition/introduction.htm?spm=5176.100066.0.0.144ed780W1xl9s&raceId=231651).
<br>Origin Repository: [argman/EAST - A tensorflow implementation of EAST text detector](https://github.com/argman/EAST)
<br>Origin Author: [argman](https://github.com/argman)

Author: [Haozheng Li](https://github.com/HaozhengLi)
<br>Email: sai-2008@qq.com or akaHaozhengLi@gmail.com

### Contents
1. [Transform](#transform)
2. [Models](#models)
3. [Demo](#demo)
3. [Train](#train)
4. [Test](#test)
5. [Results](#results)

### Transform
Some data in the dataset is abnormal, just like [ICPR MTWI 2018](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651). Abnormal means that the ground true labels are anticlockwise, or the images are not in 3 channels. Then errors like ['poly in wrong direction'](https://github.com/argman/EAST/issues?utf8=%E2%9C%93&q=poly+in+wrong+direction) will occur while using [argman/EAST](https://github.com/argman/EAST).

So I wrote a matlab program to check and transform the dataset. The program named <[transform.m](https://github.com/HaozhengLi/EAST_ICPR/tree/master/data_transform/transform.m)> is in the folder 'data_transform/' and its parameters are descripted as blow:
```
icpr_img_folder = 'image_9000\';                   %origin images
icpr_txt_folder = 'txt_9000\';                     %origin ground true labels
icdar_img_folder = 'ICPR2018\';                    %transformed images
icdar_gt_folder = 'ICPR2018\';                     %transformed ground true labels
icdar_img_abnormal_folder = 'ICPR2018_abnormal\';  %images not in 3 channels, which give errors in argman/EAST
icdar_gt_abnormal_folder = 'ICPR2018_abnormal\';   %transformed ground true labels

%images and ground true labels files must be renamed as <img_1>, <img_2>, ..., <img_xxx> while using argman/EAST
first_index =  0;                                  %first index of the dataset
transform_list_name = 'transform_list.txt';        %file name of the rename list
```
***Note: For abnormal images not in 3 channels, please transform them to normal ones through other tools like [Format Factory](http://www.pcfreetime.com/). Then add the right data to the <icdar_img_folder> and <icdar_gt_folder>, so finally you get a whole normal dataset which has been checked and transformed.***

### Models
1. Resnet_V1_50 Models trained on [ICPR MTWI 2018 (train)](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651): [[100k steps]()] [[300k steps]()] [[500k steps]()] [[700k steps]()]
2. Resnet_V1_101 Models trained on [ICPR MTWI 2018 (train)](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651) + [ICDAR 2017 MLT (train + val)](http://rrc.cvc.uab.es/?ch=8&com=downloads) + [RCTW-17 (train)](http://www.icdar2017chinese.site:5080/dataset/): [[100k steps]()]
3. Resnet_V1_101 Models pre-trained on Models-2, then trained on just [ICPR MTWI 2018 (train)](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651): [[300k steps]()]
3. (In [argman/EAST](https://github.com/argman/EAST)) Resnet_V1_50 Models trained on ICDAR 2013 (train) + ICDAR 2015 (train): [[50k steps](https://pan.baidu.com/s/1ibyF0-fWE2AT3dEpwIltKw)]
4. (In [argman/EAST](https://github.com/argman/EAST)) Resnet_V1_50 Models provided by tensorflow slim: [[slim_resnet_v1_50](http://download.tensorflow.org/models/resnet_v1_50_2016_08_28.tar.gz)]

### Demo
Download the pre-trained models and run:
```
python run_demo_server.py --checkpoint-path models/east_icpr2018_resnet_v1_50_rbox_100k/
```
Then Open http://localhost:8769 for the web demo server, or get the results in 'static/results/'.
<br>***Note: See [argman/EAST#demo](https://github.com/argman/EAST#demo) for more details.***

### Train
Prepare the training set and run:
```
python multigpu_train.py --gpu_list=0 --input_size=512 --batch_size_per_gpu=8 \
--checkpoint_path=models/east_icpr2018_resnet_v1_50_rbox/ \
--text_scale=512 --training_data_path=data/ICPR2018/ --geometry=RBOX \
--learning_rate=0.0001 --num_readers=18 --max_steps=50000
```
***Note 1: Images and ground true labels files must be renamed as <img_1>, <img_2>, ..., <img_xxx> while using argman/EAST. Please see the examples in the folder 'training_samples/'.
<br>Note 2: If ```--restore=True```, training will restore from checkpoint and ignore the ```--pretrained_model_path```. If ```--restore=False```, training will delete checkpoint and initialize with the ```--pretrained_model_path``` (if exists).
<br>Note 3: See [argman/EAST#train](https://github.com/argman/EAST#train) for more details.***

### Test
Prepare the test set and run:
```
python eval.py --test_data_path=data/ICPR2018/ --gpu_list=0 \
--checkpoint_path=models/east_icpr2018_resnet_v1_50_rbox_100k/ --output_dir=results/100k/
```
Then get the results in 'results/'.

### Results
Here are some results on [ICPR MTWI 2018](https://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.4ec66a80qvIKLc&raceId=231651):
<br>![image](https://github.com/HaozhengLi/EAST_ICPR/blob/master/results/100k/img_1.jpg)
<br>![image](https://github.com/HaozhengLi/EAST_ICPR/blob/master/results/100k/img_2.jpg)
<br>![image](https://github.com/HaozhengLi/EAST_ICPR/blob/master/results/100k/img_3.jpg)
<br>![image](https://github.com/HaozhengLi/EAST_ICPR/blob/master/results/100k/img_4.jpg)
<br>![image](https://github.com/HaozhengLi/EAST_ICPR/blob/master/results/100k/img_5.jpg)

# Have fun!! :)



