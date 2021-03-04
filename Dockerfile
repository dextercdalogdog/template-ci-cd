
FROM node:14

# Create app directory
WORKDIR /obs/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

# installing external bin apps
RUN  apt update && apt install ffmpeg -y

RUN npm run build

EXPOSE 3000
CMD [ "node", "dist/main" ]
