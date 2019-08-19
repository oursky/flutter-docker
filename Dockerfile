FROM openjdk:8

ENV ANDROID_HOME /android_sdk

RUN apt-get update && \
	apt-get install -y git curl unzip lib32stdc++6 android-sdk xz-utils make && \
	apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	apt-get install nodejs && \
	npm install -g appcenter-cli

RUN curl https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.7.8+hotfix.4-stable.tar.xz --output /flutter.tar.xz && \
	tar xf flutter.tar.xz && \
	rm flutter.tar.xz

RUN curl https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip --output android-sdk-tools.zip && \
	unzip android-sdk-tools.zip -d $ANDROID_HOME && \
	rm android-sdk-tools.zip

RUN git clone https://github.com/StackExchange/blackbox.git /blackbox

ENV PATH $PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/tools:/blackbox/bin

RUN yes | sdkmanager --licenses && \
	sdkmanager --update && \
	sdkmanager tools && \
	sdkmanager platform-tools &&\
	sdkmanager emulator && \
	sdkmanager "build-tools;29.0.2" && \
	sdkmanager "platforms;android-29"

RUN flutter doctor
