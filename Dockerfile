FROM buildkite/puppeteer

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E88979FB9B30ACF2

RUN apt-get update \
     && apt-get install -y git apt-utils nodejs curl unzip

#RUN git config --global url."https://".insteadOf ssh://
#RUN npm view 'gildas-lormeau/SingleFile#master'
#RUN npm update --verbose -g
#RUN npm install npm@latest


#RUN npm install --verbose verbose 'gildas-lormeau/SingleFile#master'
RUN curl -fsSL https://deno.land/install.sh | sh
RUN ln -s /root/.deno/bin/deno /usr/local/bin
RUN npm install "single-file-cli"

WORKDIR /opt/app


RUN apt-get update && apt-get install --no-install-recommends -y \
      python3 python3-pip python3-setuptools

COPY requirements.txt .
COPY webserver.py .

RUN pip3 install \
    --no-cache-dir \
    --no-warn-script-location \
    --user \
    -r requirements.txt

ENV PATH "$PATH:/root/.dino/bin"

RUN pip3 install markupsafe==2.0.1

RUN rm requirements.txt

ENTRYPOINT ["/node_modules/single-file/cli/single-file", "--browser-executable-path=/opt/google/chrome/google-chrome", "--browser-args='[\"--no-sandbox\"]'", "--dump-content"]
