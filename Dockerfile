ARG NODE_VERSION=12.18.3
FROM node:${NODE_VERSION}-alpine
RUN apk add --no-cache make pkgconfig gcc g++ python libx11-dev libxkbfile-dev curl
WORKDIR /tmp
RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github&version=v6" | tar -zx
RUN mv cf /usr/local/bin
ARG version=latest
WORKDIR /theia
ADD package.json ./package.json
ARG GITHUB_TOKEN
RUN yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean && \
    addgroup user && \
    adduser -G user -s /bin/sh -D user 
COPY startide /theia
USER user
COPY --chown=user:user user /home/user
WORKDIR /home/user
RUN npm i -g yo @sap/generator-fiori-elements generator-sap-a-team-mta generator-easy-ui5 @sap/generator-fiori generator-sap-ui5-app \
    @sap/generator-fiori-freestyle @sap/generator-cds generator-app-fiori @sap/generator-cap-project @sap/generator-base-mta-module generator-ui5-boilerplate \
    @sap/generator-add-hdb-module generator-easy-ovp-ui5 

FROM node:${NODE_VERSION}-alpine
# See : https://github.com/theia-ide/theia-apps/issues/34
RUN apk add --no-cache git openssh bash fish curl && \
    addgroup user && \
    adduser -G user -s /usr/bin/fish -D user && \
    chmod g+rw /home && \
    mkdir -p /home/user/project && \
    mkdir /theia && \
    chown -R user:user /theia && \
    chown -R user:user /home/user;
WORKDIR /theia
COPY --from=0 /usr/local/bin/cf /usr/local/bin/cf
COPY --from=0 --chown=user:user /theia /theia
COPY --from=0 --chown=user:user /home/user /home/user
EXPOSE 3000
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=/theia/plugins
ENV USE_LOCAL_GIT true
USER user
ENTRYPOINT [ "/theia/startide" ]