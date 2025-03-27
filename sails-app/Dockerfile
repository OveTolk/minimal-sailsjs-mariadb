FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Install sails and pm2 globally
RUN npm install -g sails pm2
RUN npm install sails-mysql --save

# Copy package files and install dependencies
COPY sails-app/package*.json ./
RUN npm install

# Copy the rest of your app (assuming all code is in ./sails-app)
COPY sails-app/ .

# Expose Sails default port
EXPOSE 1337

# Start the app via PM2
CMD ["pm2-runtime", "start", "app.js"]
