FROM chenaoki/nb_basic:latest

MAINTAINER chenaoki <chenaoki@gmail.com>

##########################

RUN apt-get install -y \
    libeigen3-dev \
    libgmp-dev \
    libgmpxx4ldbl \
    libmpfr-dev \
    libboost-dev \
    libboost-thread-dev \
    libtbb-dev \
    python3-dev 

##########################
WORKDIR /temp
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.tar.gz
RUN tar xvf cmake-3.16.0-Linux-x86_64.tar.gz 
WORKDIR /temp/cmake-3.16.0-Linux-x86_64/
ENV PATH /temp/cmake-3.16.0-Linux-x86_64/bin:$PATH
RUN cmake --version
RUN echo $PATH

##########################
WORKDIR /temp
RUN git clone https://github.com/PyMesh/PyMesh.git

ENV PYMESH_PATH /temp/PyMesh
WORKDIR $PYMESH_PATH
RUN git submodule update --init
RUN pip install -r $PYMESH_PATH/python/requirements.txt
RUN python3 setup.py build
RUN python3 setup.py install
RUN python3 -c "import pymesh; pymesh.test()"

##########################

RUN pip install open3d-python

##########################

CMD ["sh", "-c", "jupyter lab --allow-root > $NOTEBOOK_HOME/log.txt 2>&1"]
