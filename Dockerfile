FROM python:3.7
ENV PYTHONIOENCODING utf-8

WORKDIR /home

RUN apt-get update && apt-get install -y --no-install-recommends \
        python-numpy \
        python-scipy \
        python-matplotlib \
        ipython \
        python-pandas \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/local/bin/python -m pip install --upgrade pip

# Install some commonly used packages and the Python application
RUN pip3 install --use-feature=2020-resolver --no-cache-dir --upgrade --force-reinstall \
        avro \
        fastavro \
        ipython \
        matplotlib \
        mlflow \
        numpy \
        pandas \
        scipy \
        scikit-learn \
    && pip3 install --no-cache-dir --upgrade --force-reinstall git+git://github.com/keboola/python-docker-application.git@2.1.1

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
