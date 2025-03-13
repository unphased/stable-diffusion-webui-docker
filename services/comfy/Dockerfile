FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git ffmpeg gcc && apt-get clean

ARG CACHEBUST=3
ENV ROOT=/stable-diffusion
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} && \
  cd ${ROOT} && \
  git checkout master && \
  echo "cachebuster value: ${CACHEBUST}" && \
  echo "git hash: $(git rev-parse HEAD)" && \
  pip install -r requirements.txt && \
  # sageattention needed for comfy launched with it as flag \
  pip install sageattention \
  omegaconf opencv-python-headless matplotlib gguf accelerate deepdiff cupy-cuda12x piexif scikit-image

# ... contemplating adding a list of python deps needed by various nodes i use. tired of manually reinstalling custom nodes just to
# cause the pip lib installation side effects to happen.

WORKDIR ${ROOT}

# ADD https://github.com/madebyollin/taesd/raw/main/taesd_decoder.pth \
#   ${ROOT}/models/vae_approx/taesd_decoder.pth
# ADD https://github.com/madebyollin/taesd/raw/main/taesdxl_decoder.pth \
#   ${ROOT}/models/vae_approx/taesdxl_decoder.pth

# might get clobbered by local file system, beware
# RUN cd custom_nodes && git clone https://github.com/ltdrdata/ComfyUI-Manager.git
# WORKDIR ${ROOT}

# add info
COPY . /docker/
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml ${ROOT}

# fix dumb stuff done by ... not sure what. but it affects VHS video export node.
# RUN rm /opt/conda/bin/ffmpeg && ln -s /bin/ffmpeg /opt/conda/bin/ffmpeg

ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS="" CUDA_HOME=/usr/lib/x86_64-linux-gnu/
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}
