# Use the official Node.js image as the base image
FROM node:14-alpine as builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . .

# Build the Angular app for production
RUN npm build

# Use a smaller image for the runtime environment
FROM nginx:alpine

# Copy the built Angular app from the builder stage to the nginx public directory
COPY --from=builder /usr/src/app/dist/vibe-drive-client /usr/share/nginx/html

# Expose the port that the app will run on
EXPOSE 85

# The default command to start the NGINX server
CMD ["nginx", "-g", "daemon off;"]
