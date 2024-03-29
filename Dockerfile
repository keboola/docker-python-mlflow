FROM python:3.8
ENV PYTHONIOENCODING utf-8

WORKDIR /home

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        python-numpy \
        python-scipy \
        python-matplotlib \
        ipython \
        msodbcsql17 \
        mssql-tools \
        python-pandas \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:/opt/mssql-tools/bin

# From https://jdk.java.net/13/, stolen from https://github.com/docker-library/openjdk/blob/master/8/jdk/Dockerfile#L22
ENV JAVA_HOME /usr/local/openjdk
ENV PATH $JAVA_HOME/bin:$PATH
RUN wget https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz \
    && mkdir $JAVA_HOME \
    && tar xv --file openjdk-13*_bin.tar.gz --directory "$JAVA_HOME" --no-same-owner --strip-components 1 \
    && find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf \
    && ldconfig

RUN /usr/local/bin/python -m pip install --upgrade pip

# Install some commonly used packages and the Python application
RUN pip3 install --use-feature=2020-resolver --no-cache-dir --upgrade --force-reinstall \
        avro \
        azure-storage-blob==12.7.* \
        boto3 \
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
