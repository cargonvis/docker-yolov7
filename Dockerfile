# First, we will use the nvidia cuda image
FROM nvidia/cuda:10.2-base
CMD nvidia-smi

# On top of it we also use our ubuntu 22.04 image
FROM ubuntu:22.04

# Next, we will define the maintainer of our image and its email
LABEL maintainer="Carlos Gonzalez" email="cgonv1993@gmail.com"

# We make our image non-interactive
ENV DEBIAN_FRONTEND noninteractive

# We update the whole system
RUN apt-get -y update && apt-get -y upgrade

# Install basics
RUN apt install -y \
git \
nano \
wget \
curl \
zip \
fim \
mplayer \
python3-pip \
xfce4-terminal \
terminator \
libgl1-mesa-dev \
libxcb-* \
libxkb*

# Install jupyter
RUN python3 -m pip install jupyterlab

# Go to /myyolov7 folder
WORKDIR /docker-yolov7

# Download yolov7 repo from GitHub
RUN git clone https://github.com/WongKinYiu/yolov7.git

# Install requirements.txt file for yolov7
RUN pip install -r yolov7/requirements.txt

# Copy Python file for applying data augmentation to images
COPY data_augmentation.py data_augmentation.py

# Copy labelimg from directory to container
COPY YoloLabel_v1.2.1 YoloLabel_v1.2.1

# Copy executable bash script for split data, organize images and labels in subfolders and create training yaml files:
COPY preparation_for_training preparation_for_training

# OPTIONAL: Copy images folder (make sure you have your images that you will annotate on it) from directory to container
# COPY images images

# OPTIONAL: DOWNLOAD DATASET
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# RUN unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip && rm -rf aws/
# RUN aws s3 --no-sign-request cp s3://open-images-dataset/tar/challenge2018.tar.gz /docker-yolov7/challenge2018.tar.gz
# RUN tar -xf challenge2018.tar.gz && rm -rf challenge2018.tar.gz && mv challenge2018/ downloaded_dataset/ && touch downloaded_dataset/classes.txt

# Set the default command to start terminator
CMD ["terminator"]