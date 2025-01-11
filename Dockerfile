# FROM nvidia/cuda:12.1.0-devel-ubuntu22.04
FROM nvidia/cuda:12.1.0-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive



RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget vim bzip2 git build-essential
RUN apt-get update && apt-get install -y libvulkan1
RUN apt-get update && apt-get install -y vulkan-utils
RUN apt-get update && apt-get install -y xvfb x11vnc icewm lsof net-tools screen libgl1-mesa-glx libosmesa6 libgl1-mesa-dev
RUN apt-get update && apt-get install -y bash-completion ca-certificates libegl1 libxext6 libjpeg-dev libpng-dev cmake curl htop
# RUN apt-get update && apt-get install -y xorg lxde-core tightvncserver
# RUN apt-get install -yqq --no-install-recommends libvulkan-dev vulkan-tools
# RUN apt-get install -y libvulkan1 mesa-vulkan-drivers

# python (latest version)
WORKDIR /
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

WORKDIR /root

RUN pip install pip==24.2 setuptools==75.2.0 wheel==0.44.0

RUN pip install torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cu121


RUN git clone https://github.com/simpler-env/ManiSkill2_real2sim.git
RUN pip install -e ./ManiSkill2_real2sim
RUN git clone https://github.com/simpler-env/SimplerEnv.git
RUN pip install -e ./SimplerEnv


COPY docker/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
COPY docker/nvidia_icd.json /usr/share/vulkan/icd.d/nvidia_icd.json
COPY docker/nvidia_layers.json /etc/vulkan/implicit_layer.d/nvidia_layers.json