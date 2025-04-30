FROM flutter:stable

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build apk

# Para web:
# RUN flutter build web