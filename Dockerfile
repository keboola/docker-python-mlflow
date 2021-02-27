FROM python:3.7
ENV PYTHONIOENCODING utf-8

WORKDIR /home

RUN apt-get update && apt-get install -y --no-install-recommends \
        python-numpy \
        python-scipy \
        python-matplotlib \
        ipython \
        python-pandas \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/local/bin/python -m pip install --upgrade pip

# Install some commonly used packages and the Python application
RUN pip3 install --use-feature=2020-resolver --no-cache-dir --upgrade --force-reinstall \
        avro \
        azure \
        azure-storage-blob \
        fastavro \
        ipython \
        matplotlib \
        mlflow \
        numpy \
        pandas \
        pyodbc \
        scipy \
        scikit-learn \
        SQLAlchemy \
        git+git://github.com/keboola/sapi-python-client.git@0.1.3 \
    && pip3 install --no-cache-dir --upgrade --force-reinstall git+git://github.com/keboola/python-docker-application.git@2.1.1

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
ENV MPLCONFIGDIR /home/$NB_USER/.cache/matplotlib
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
