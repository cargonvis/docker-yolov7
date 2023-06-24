<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL-3.0 License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/cargonvis/docker-yolov7">
    <img src="project_images/face.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">DOCKER-YOLOV7</h3>

  <p align="center">
    Dockerized YOLOv7 and annotation toolkit for user-friendly training from scratch.
    <br />
    <a href="https://github.com/cargonvis/docker-yolov7"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/cargonvis/docker-yolov7">View Demo</a>
    ·
    <a href="https://github.com/cargonvis/docker-yolov7/issues">Report Bug</a>
    ·
    <a href="https://github.com/cargonvis/docker-yolov7/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <!-- <li><a href="#roadmap">Roadmap</a></li> -->
    <li><a href="#future-improvements">Future Improvements</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) --> 
![Product Name Screen Shot][product-screenshot] <!-- Image without link -->

The Automatized YOLOv7 project simplifies the process of training and deploying object detection models by providing a streamlined workflow, GPU support, and data augmentation techniques. It empowers users to achieve accurate and efficient object detection for various applications.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* [![Docker][Docker.org]][Docker-url]
* [![YOLO][YOLO.org]][YOLO-url]
* [![Python][Python.org]][Python-url]
* [![Pytorch][Pytorch.org]][Pytorch-url]
* [![OpenCV][OpenCV.org]][OpenCV-url]
* [![Bash][Bash.org]][Bash-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To get started with this project, make sure your device has a GPU. Follow the steps below:

### Prerequisites

If you don't have Docker installed, follow the instructions [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)

### Installation

1. Clone the repo:
   ```
   git clone https://github.com/cargonvis/docker-yolov7.git
   ```

2. Check if your computer has NVIDIA drivers installed by running the command nvidia-smi. If you see an output like the attached image, you already have the drivers. 
   
   ![Nvidia-smi](project_images/nvidia-smi.png)

   Otherwise, install the NVIDIA drivers using the following command:
   ```
   sudo apt install nvidia-driver-525 nvidia-dkms-525
   ```

3. Restart your device to apply the driver changes.

4. Install the NVIDIA Container Toolkit by running the following commands:
   ```
   sudo rm /etc/apt/sources.list.d/nvidia-container-toolkit.list
   wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
   sudo dpkg -i cuda-keyring_1.0-1_all.deb
   sudo apt-get update
   sudo apt-get -y install nvidia-container-toolkit
   systemctl restart docker
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

1. Access the project folder:
   ```
   cd docker-yolov7
   ```

2. Before building the Docker image, review the Dockerfile and uncomment the necessary options based on your use intentions (e.g., training with own images, downloading dataset).

3. Build the Docker image:
   ```
   docker build -t docker-yolov7_image .
   ```

4. Once the image is built, run the container with access to your GPU and USB0 (if you have a USB webcam):
   ```
   docker run --gpus all -e DISPLAY=$DISPLAY -it -p 8888:8888 --privileged -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /dev/bus/video0:/dev/bus/video0 --network="host" --ipc=host --name docker-yolov7_webcam_GPU docker-yolov7_image
   ```
   For future runs, start the container using the following command:
   ```
   docker start -ai docker-yolov7_webcam_GPU
   ```
   If any error when running or starting the container, run the following command and then try to run or start the container again:
   ```
   xhost + local:docker
   ```

5. If you need to apply data augmentation, run the following command inside the container:
   ```
   python3 data_augmentation.py
   ```
   By default, the script applies seven different data augmentation techniques. You can customize this by modifying the code and commenting out the techniques you don't want to apply.

6. Before annotating, create a "classes.txt" file in the image folder to list the classes to annotate. Ensure that the class names are in singular form, lowercase, and without any special characters or spaces. Each class should be on a separate line.

   ![Alt text](project_images/classes_txt.png)

7. To annotate your images, navigate to the YoloLabel_v1.2.1 folder and run the annotation tool:
   ```
   ./YoloLabel.sh
   ```
   ![Alt text](project_images/yololabel.png) ![Alt text](project_images/yololabel_cat.png)
   
   After annotating the images, you should have a folder with the annotated images, corresponding annotation files (txt files), and the classes.txt file.

8. Prepare the data for training, including splitting images and labels, downloading weights, creating custom YAML files, etc., by running the following command:
   ```
   ./preparation_for_training
   ```

9. Navigate to the yolov7 folder and train your model using the following command:
   ```
   python3 train.py --workers 1 --device 0 --batch-size 1 --epochs 100 --img 640 640 --hyp data/hyp.scratch.custom.yaml --data custom_data/nameofyourproject/custom.yaml --name yolov7-custom --weights yolov7_training.pt
   ```
   Replace nameofyourproject with the name you chose during the preparation step. Modify the number of epochs as needed.

10. After training, test your model with the following command:
    ```
    python3 test.py --weights /docker-yolov7/yolov7/runs/train/yolov7-custom/weights/best.pt \
     --task test \
     --data custom_data/nameofyourproject/custom.yaml
    ```
    Again, replace nameofyourproject with your chosen project name.

11. Check the evaluation metrics and other training aspects in the runs/train/yolov7-custom/ directory. Use image viewing tools like fim to visualize the metrics. Example: fim confusion_matrix.png.

12. Make predictions on test images by running the following command:
    ```
    python3 detect.py --weights /docker-yolov7/yolov7/runs/train/yolov7-custom/weights/best.pt \
     --conf 0.5 \
     --img-size 640 \
     --source custom_data/nameofyourproject/test/images/mytestimage.jpg
    ```
    Replace nameofyourproject with your project name, and modify the command to specify your test image and adjust the confidence threshold if needed.

13. To test predictions on a video, place the video file in the yolov7/ directory and run the following command:
    ```
    python3 detect.py --weights /docker-yolov7/yolov7/runs/train/yolov7-custom/weights/best.pt \
     --conf 0.5 \
     --img-size 640 \
     --source myvideoname.mp4 --no-trace
    ```
    Replace myvideoname.mp4 with your video file name, and adjust the confidence threshold if desired.
   
14. To view the video with the predictions, navigate to /runs/test/yolov7-custom/ and use a tool like mplayer. Example: mplayer myvideo.mp4.

_For more examples, please refer to the [YOLOv7 Documentation](https://github.com/WongKinYiu/yolov7)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
<!--## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature-->

See the [open issues](https://github.com/cargonvis/docker-yolov7/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- FUTURE IMPROVEMENTS -->
## Future Improvements

- Explore alternative image annotation tools to replace YoloLabel, aiming for improved efficiency, user-friendliness, and additional annotation features.
- Investigate and implement 3D annotations specifically for videos, enabling more advanced object analysis, tracking, and understanding in three-dimensional space.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the GNU General Public License v3.0. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

[![Email][Email-shield]][Email-url] [![LinkedIn][linkedin-shield]][linkedin-url] [![Discord][Discord-shield]][Discord-url]

Project Link: [https://github.com/cargonvis/docker-yolov7](https://github.com/cargonvis/docker-yolov7)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Some helpful websites

* [https://github.com/WongKinYiu/yolov7](https://github.com/WongKinYiu/yolov7)
* [https://github.com/developer0hye/Yolo_Label](https://github.com/developer0hye/Yolo_Label)
* [https://github.com/cvdfoundation/open-images-dataset](https://github.com/cvdfoundation/open-images-dataset)
* [https://mpolinowski.github.io/docs/IoT-and-Machine-Learning/ML/2023-01-10-yolov7_custom_data/2023-01-10/](https://mpolinowski.github.io/docs/IoT-and-Machine-Learning/ML/2023-01-10-yolov7_custom_data/2023-01-10/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/cargonvis/docker-yolov7.svg?style=for-the-badge
[contributors-url]: https://github.com/cargonvis/docker-yolov7/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/cargonvis/docker-yolov7.svg?style=for-the-badge
[forks-url]: https://github.com/cargonvis/docker-yolov7/network/members
[stars-shield]: https://img.shields.io/github/stars/cargonvis/docker-yolov7.svg?style=for-the-badge
[stars-url]: https://github.com/cargonvis/docker-yolov7/stargazers
[issues-shield]: https://img.shields.io/github/issues/cargonvis/docker-yolov7.svg?style=for-the-badge
[issues-url]: https://github.com/cargonvis/docker-yolov7/issues
[license-shield]: https://img.shields.io/github/license/cargonvis/docker-yolov7.svg?style=for-the-badge
[license-url]: https://github.com/cargonvis/docker-yolov7/blob/master/LICENSE
[product-screenshot]: project_images/project_image.png
[Docker.org]: https://img.shields.io/badge/Docker-blue.svg?logo=docker&style=for-the-badge&logoColor=white
[Docker-url]: https://www.docker.com/
[YOLO.org]: https://img.shields.io/badge/YOLO-black?logo=Yolo&style=for-the-badge&logoColor=lightblue
[YOLO-url]: https://pjreddie.com/darknet/yolo/
[Python.org]: https://img.shields.io/badge/Python-3776AB?logo=python&style=for-the-badge&logoColor=fff
[Python-url]: https://www.python.org/
[Pytorch.org]: https://img.shields.io/badge/Pytorch-red?logo=Pytorch&style=for-the-badge&logoColor=white
[Pytorch-url]: https://pytorch.org/
[OpenCV.org]: https://img.shields.io/badge/OpenCV-LIME?logo=Opencv&style=for-the-badge&logoColor=white%22
[OpenCV-url]: https://opencv.org/
[Bash.org]: https://img.shields.io/badge/GNU%20Bash-4EAA25?logo=gnubash&style=for-the-badge&logoColor=fff
[Bash-url]: https://www.gnu.org/software/bash/
[Email-shield]: https://img.shields.io/badge/gmail-red?style=for-the-badge&logo=gmail&logoColor=white
[Email-url]: mailto:cgonv1993@gmail.com
[linkedin-shield]: https://img.shields.io/badge/linkedin-blue?style=for-the-badge&logo=linkedin&logoColor=white
[linkedin-url]: https://linkedin.com/in/carlosgonzalezvisiedo
[Discord-shield]: https://img.shields.io/badge/discord-darkblue?style=for-the-badge&logo=discord&logoColor=white
[Discord-url]: https://discordapp.com/users/439897699299491850