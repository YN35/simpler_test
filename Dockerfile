FROM nvidia/cuda:12.1.0-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive


# python (latest version)
RUN apt-get update
RUN apt-get install -y python3.10 python3-pip python3.10-dev
RUN ln -s /usr/bin/python3.10 /usr/bin/python

RUN apt-get update && apt-get install -y wget git
RUN apt-get update && apt-get install -y xvfb x11vnc icewm lsof net-tools screen libgl1-mesa-glx libosmesa6 libgl1-mesa-dev
RUN apt-get update && apt-get install -y xorg lxde-core tightvncserver
RUN apt-get install -yqq --no-install-recommends libvulkan-dev vulkan-tools
RUN apt-get install -y libvulkan1 mesa-vulkan-drivers
WORKDIR /home/root

RUN pip3 install pip==24.2 setuptools==75.2.0 wheel==0.44.0

RUN pip3 install torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cu121

RUN apt-get update
RUN apt-get install -yqq --no-install-recommends libvulkan-dev vulkan-tools

RUN git clone https://github.com/simpler-env/ManiSkill2_real2sim.git
RUN pip install -e ./ManiSkill2_real2sim
RUN git clone https://github.com/simpler-env/SimplerEnv.git
RUN pip install -e ./SimplerEnv



# COPY docker/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
# COPY docker/nvidia_icd.json /usr/share/vulkan/icd.d/nvidia_icd.json
# COPY docker/nvidia_layers.json /etc/vulkan/implicit_layer.d/nvidia_layers.json