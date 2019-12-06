FROM brainbeanapps/base-linux-build-environment:v3.0.0

LABEL maintainer="devops@brainbeanapps.com"

# Switch to root
USER root

# Set shell as non-interactive during build
# NOTE: This is discouraged in general, yet we're using it only during image build
ARG DEBIAN_FRONTEND=noninteractive

# Install required tools
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install OpenJDK
# Ref: https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update \
  && apt-get install -y --no-install-recommends openjdk-8-jdk \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/oracle-jdk8-installer;

# Setup JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Install Node.js & npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g npm@latest

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Ruby
RUN apt-get update \
  && apt-get install -y --no-install-recommends ruby \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Android SDK
# NOTE: ANDROID_SDK_HOME should not be set in order to use user home directory
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK="${ANDROID_HOME}"
ENV ANDROID_SDK_ROOT="${ANDROID_HOME}"
ENV ANDROID_NDK="${ANDROID_HOME}/ndk-bundle"
ENV ANDROID_NDK_ROOT="${ANDROID_NDK}"
ENV ANDROID_NDK_HOME="${ANDROID_NDK}"
ENV PATH="${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_NDK}:${PATH}"
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg \
  && wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk-tools.zip \
  && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
  && rm android-sdk-tools.zip \
  && (yes | sdkmanager --licenses) \
  && sdkmanager \
    "tools" \
    "platform-tools" \
    "patcher;v4" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;google;market_licensing" \
    "extras;google;market_apk_expansion" \
    "extras;google;instantapps" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta5" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta4" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta3" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta1" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-alpha8" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-alpha4" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.1" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta5" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta4" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta3" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta1" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-alpha8" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-alpha4"

# Switch to user
USER user
WORKDIR /home/user
