FROM node:20.3.1
ENV HOME=/home/node
EXPOSE 4000
EXPOSE 4400
EXPOSE 5000
EXPOSE 5001
EXPOSE 8080
EXPOSE 8085
EXPOSE 9000
EXPOSE 9005
EXPOSE 9099
EXPOSE 9199
RUN npm install -g firebase-tools; apt-get install -y wget; apt-get install -y apt-transport-https; wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |  gpg --dearmor -o /usr/share/keyrings/dart.gpg; echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |  tee /etc/apt/sources.list.d/dart_stable.list
RUN apt-get update; apt-get install dart
ENV PATH="$PATH:/usr/lib/dart/bin"
RUN dart pub global activate flutterfire_cli
ENV PATH="$PATH":"$HOME/.pub-cache/bin"
RUN apt install -y default-jre
# RUN chown -R node:node $HOME
RUN mkdir -p $HOME/.cache/firebase/emulators && chown -R node:node $HOME
USER node
VOLUME $HOME/.cache
WORKDIR $HOME
CMD ["/bin/bash"]