FROM ruby:3.0.1

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm yarn default-libmysqlclient-dev cron

# Install nodejs and update npm
RUN npm install

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Copy the Gemfile and Gemfile.lock into the image.
COPY Gemfile* $APP_HOME/

# Run bundle install to install gems inside the Docker image.
RUN bundle install

# Copy the main application.
COPY . $APP_HOME

# Add a script to be executed every time the container starts.
COPY entry.sh /usr/bin/
RUN chmod +x /usr/bin/entry.sh
ENTRYPOINT ["entry.sh"]

# Expose the port the app runs on.
EXPOSE 3000

# Configure the main process to run when running the image.
CMD ["rails", "server", "-b", "0.0.0.0"]