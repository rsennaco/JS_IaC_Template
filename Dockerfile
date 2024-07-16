# Official Node.js image
FROM node:14

# Creating and changing into application dir
WORKDIR /usr/src/app

# Copying package.json and package-lock.json
COPY app/package*.json ./

# Installing dependencies
RUN npm install

# Copying the rest of the application code
COPY app/ .

# Exposing port for application
EXPOSE 3000

# Starting application
CMD ["npm", "start"]