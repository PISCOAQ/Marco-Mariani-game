FROM instrumentisto/flutter:3.38 AS build

WORKDIR /app

# Copy pubspec files and resolve dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Compile the Dart script to native executable
RUN flutter build web --release

# Use NGINX as web server, lightweigh runtime image
FROM nginx:stable-alpine3.23-slim AS runtime  

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy only the compiled binary from the build stage
COPY --from=build /app/build/web .

COPY ./assets assets