FROM ghcr.io/cirruslabs/flutter:stable

# Installer les dépendances nécessaires (JDK 17 pour stripe)
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    openjdk-17-jdk

# Configurer les variables d'environnement
ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/platform-tools

# Copier les fichiers du projet
WORKDIR /app
COPY . .

# Translation
RUN flutter pub get
RUN flutter gen-l10n

# Accepter les licences Android SDK
RUN yes | sdkmanager --licenses

# Construire l'APK
RUN flutter build apk --release

# Le fichier APK sera disponible dans /app/build/app/outputs/flutter-apk/app-release.apk