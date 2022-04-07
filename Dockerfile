FROM openjdk:11

ARG VERSION=2.10.3

ENV ANDROID_HOME /android_sdk
ENV ANDROID_NDK_HOME ${ANDROID_HOME}/ndk
ENV ANDROID_CMDLINE_TOOLS_HOME ${ANDROID_HOME}/cmdline-tools

RUN apt-get update && \
    apt-get install -y git curl unzip lib32stdc++6 android-sdk xz-utils make && \
    apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install nodejs && \
    npm install -g appcenter-cli

RUN curl https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${VERSION}-stable.tar.xz --output /flutter.tar.xz && \
    tar xf flutter.tar.xz && \
    rm flutter.tar.xz

RUN mkdir -p $ANDROID_CMDLINE_TOOLS_HOME

RUN curl https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip --output android-sdk-tools.zip && \
    unzip -qq android-sdk-tools.zip -d $ANDROID_CMDLINE_TOOLS_HOME && \
    mv $ANDROID_CMDLINE_TOOLS_HOME/cmdline-tools $ANDROID_CMDLINE_TOOLS_HOME/tools && \
    rm android-sdk-tools.zip

RUN curl https://dl.google.com/android/repository/android-ndk-r21-darwin-x86_64.zip --output android-ndk.zip && \
    unzip -qq -o android-ndk.zip -d $ANDROID_NDK_HOME && \
    mv $ANDROID_NDK_HOME/android-ndk-r21/* $ANDROID_NDK_HOME && \
    rm android-ndk.zip

RUN git clone https://github.com/StackExchange/blackbox.git /blackbox

ENV PATH $PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/tools:/blackbox/bin

RUN yes | sdkmanager --licenses && \
    sdkmanager --update && \
    sdkmanager tools platform-tools emulator "build-tools;33.0.0-rc2" "platforms;android-31" > /dev/null

RUN flutter doctor
