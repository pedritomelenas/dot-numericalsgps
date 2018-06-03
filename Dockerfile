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

RUN cd $HOME && bash scripts/prepare.sh && cd $GAPROOT/pkg && bash ../bin/BuildPackages.sh

RUN cd $GAPROOT/pkg/JupyterKernel && python setup.py install --user

ENV JUPYTER_GAP_EXECUTABLE $GAPROOT/bin/gap.sh
RUN ln -s $GAPROOT/pkg/JupyterKernel/bin/jupyter-kernel-gap /usr/local/bin/jupyter-kernel-gap

WORKDIR $HOME
