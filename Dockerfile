FROM node:12

# Create app directory
WORKDIR /app
ADD . /app/

# global install & update
RUN npm install
RUN npm run build
RUN npm i -g eslint

ENV HOST 0.0.0.0
EXPOSE 3000

# start command
CMD [ "npm", "run", "start" ]