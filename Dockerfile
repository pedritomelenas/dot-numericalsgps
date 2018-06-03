FROM jupyter/scipy-notebook:2bfbb7d17524

MAINTAINER Manuel Martins <manuelmachadomartins@gmail.com>

USER root

ENV GAPROOT $HOME/inst
    
COPY --chown=1000:100 . $HOME

# update dependencies
RUN apt-get update && apt-get install -yq curl && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -yq nodejs libtool pkg-config build-essential autoconf automake uuid-dev libzmq3-dev && npm install -g npm \
  && chown -R 1000:100 $HOME

USER $NB_UID


WORKDIR $HOME
