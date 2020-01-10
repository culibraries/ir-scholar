FROM ruby:2.5.1 as builder

# Necessary for bundler to properly install some gems
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# add nodejs and yarn dependencies for the frontend
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN gem install bundler

RUN apt-get update -qq && apt-get upgrade -y && \
  apt-get install -y build-essential libpq-dev mysql-client nodejs libreoffice imagemagick unzip ghostscript yarn vim

# install clamav for antivirus
# fetch clamav local database
RUN apt-get install -y clamav-freshclam clamav-daemon libclamav-dev
RUN mkdir -p /var/lib/clamav && \
  wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
  wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
  wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
  chown clamav:clamav /var/lib/clamav/*.cvd

RUN mkdir -p /opt/fits && \
  curl -fSL -o /opt/fits-1.0.5.zip http://projects.iq.harvard.edu/files/fits/files/fits-1.0.5.zip && \
  cd /opt && unzip fits-1.0.5.zip -d /opt/fits && rm fits-1.0.5.zip  && chmod +X /opt/fits/fits-1.0.5/fits.sh

ENV PATH="/opt/fits/fits-1.0.5:${PATH}"

# Install ffmpeg
RUN apt-get -y install ffmpeg

#COPY ./neverstop /neverstop
RUN mkdir /data
WORKDIR /data

COPY . /data/
#ADD Gemfile /data/Gemfile
#ADD Gemfile.lock /data/Gemfile.lock
#RUN mkdir /data/build
COPY build/image_magic/policy.xml /etc/ImageMagick-6/policy.xml
# Python2 setup
RUN apt install -y python-pip
RUN pip install --no-cache-dir -r requirements.txt


ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

#ADD . /data
#RUN git checkout metadata-wt
RUN gem update --system
RUN gem install bundler
RUN bundler install

#ADD ./build/install_gems.sh /data/build
RUN ./build/install_gems.sh


FROM builder

RUN if [ "${RAILS_ENV}" = "production" ]; then \
#  echo "Precompiling assets with $RAILS_ENV environment"; \
  RAILS_ENV=$RAILS_ENV SCHOLARS_SECRET_KEY_BASE=temporary bundle exec rails assets:precompile; \
  fi

RUN mv /data/public/assets/work-*.png /data/public/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png
RUN mv /data/public/assets/collection-*.png /data/public/assets/collection-a38b932554788aa578debf2319e8c4ba8a7db06b3ba57ecda1391a548a4b6e0a.png
# Setup Mountain Time on Container for time with logs
RUN cp /usr/share/zoneinfo/America/Denver /etc/localtime
EXPOSE 3000/tcp

#ENTRYPOINT ["rails"]

#bundle exec rails"]
#CMD ["bundle exec puma"]
CMD ["bundle exec puma -C config/puma/production.rb"]
#CMD ["/data/misc/neverstop"]
