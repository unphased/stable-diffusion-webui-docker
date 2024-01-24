FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git ffmpeg && apt-get clean

RUN --mount=type=cache,target=/root/.cache/pip  \
  --mount=type=bind,from=xformers,source=/wheel.whl,target=/xformers-0.0.21-cp310-cp310-linux_x86_64.whl \
  pip install /xformers-0.0.21-cp310-cp310-linux_x86_64.whl

ENV ROOT=/stable-diffusion
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} && \
  cd ${ROOT} && \
  git checkout master && \
  echo git hash: $(git rev-parse HEAD) && \
  # git reset --hard 3e0033e && \
  # upstream has... # git reset --hard d1f3637a5a944d0607b899babd8ff11d87100503 && \
  pip install -r requirements.txt

WORKDIR ${ROOT}

ADD https://github.com/madebyollin/taesd/raw/main/taesd_decoder.pth \
  ${ROOT}/models/vae_approx/taesd_decoder.pth
ADD https://github.com/madebyollin/taesd/raw/main/taesdxl_decoder.pth \
  ${ROOT}/models/vae_approx/taesdxl_decoder.pth

# might get clobbered by local file system, beware
# RUN cd custom_nodes && git clone https://github.com/ltdrdata/ComfyUI-Manager.git
# WORKDIR ${ROOT}

# add info
COPY . /docker/
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml ${ROOT}

ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}
