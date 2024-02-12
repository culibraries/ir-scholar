FROM ruby:2.5-alpine as builder

# Necessary for bundler to properly install some gems
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

#ARG RUBYGEMS_VERSION=2.7.11
ARG RUBYGEMS_VERSION=3.2.34
ARG PACKAGES="nodejs mariadb-dev libreoffice imagemagick ghostscript vim unzip ffmpeg freshclam clamav-daemon clamav-dev tzdata curl-dev curl"

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache \
    build-base curl-dev git unzip curl \
    yaml-dev zlib-dev nodejs yarn mariadb-dev sqlite-dev $PACKAGES \
    && mkdir /data

#RUN mkdir /data
WORKDIR /data
COPY . /data/

#######COPY build/image_magic/policy.xml /etc/ImageMagick-6/policy.xml


ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

#ADD . /data
#RUN git checkout metadata-wt
# Update RubyGems system.  RubyGems v3 installs bundler
RUN gem update --system $RUBYGEMS_VERSION \ 
    && bundle install --jobs "$(nproc)" \
    && rm -rf /data/tmp \
    && mkdir /data/tmp

RUN if [ "${RAILS_ENV}" = "production" ]; then \
#  echo "Precompiling assets with $RAILS_ENV environment"; \
  RAILS_ENV=$RAILS_ENV SCHOLARS_SECRET_KEY_BASE=temporary bundle exec rails assets:precompile; \
  fi 

RUN cp /data/public/assets/work-*.png /data/public/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png
RUN cp /data/public/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png /data/public/assets/work-a6ad224077dcf8d7342d3f671bab54554d5e2e1b9b1506a25411a840b1c85202.png
RUN cp /data/public/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png /data/public/assets/work-e8271462ebe82228c43c3ebe6851235c8919bef84a6360d412615e8e48e38f89.png

#RUN mv /data/public/assets/collection-*.png /data/public/assets/collection-a38b932554788aa578debf2319e8c4ba8a7db06b3ba57ecda1391a548a4b6e0a.png
# RUN mv /data/public/assets/collection-*.png /data/public/assets/collection-a6484a88df6bbe80f76f1cdb06c23eadf0abe29dd7ce444ce4dc97b90fd1a6c2.png

# Python and pip installs
RUN apk add --update --no-cache python3 && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip wheel && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Clamv and Fits Installs and all the requirements
RUN chmod -R 777 /var/lib/clamav \
    && chown -R clamav:clamav /var/lib/clamav/ \
    && freshclam \
    && chmod -R 775 /var/lib/clamav \
    && mkdir -p /opt/fits && \
    curl -fSL -o /opt/fits-1.0.5.zip http://projects.iq.harvard.edu/files/fits/files/fits-1.0.5.zip && \
    cd /opt && unzip fits-1.0.5.zip -d /opt/fits && rm fits-1.0.5.zip  && chmod +X /opt/fits/fits-1.0.5/fits.sh \
    && pip install --no-cache-dir -r /data/requirements.txt \
    && cp /usr/share/zoneinfo/America/Denver /etc/localtime \
    && mv /data/app/assets/stylesheets/cu_boulder_font.css /data/public/assets/cu_boulder_font.css \
    && mv /data/app/assets/stylesheets/cu_boulder_branding.css /data/public/assets/cu_boulder_branding.css

ENV PATH="/opt/fits/fits-1.0.5:${PATH}"


# COPY --from=builder $RAILS_ROOT $RAILS_ROOT
# COPY --from=builder /usr/local/bundle /usr/local/bundle

#RUN pip install --no-cache-dir -r requirements.txt
#ENV GEM_HOME=/data/vendor/bundle
# Setup Mountain Time on Container for time with logs
#RUN mkdir /data/tmp/pids \
#    && cp /usr/share/zoneinfo/America/Denver /etc/localtime



#Clean and reduce risk
RUN apk del sqlite-dev build-base py-pip git unzip yarn \
    && rm -f /sbin/apk \
    && rm -rf /etc/apk \
    && rm -rf /lib/apk \
    && rm -rf /usr/share/apk \
    && rm -rf /var/lib/apk \
    && rm -rf /usr/mysql-test \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete \
    && rm -rf /data/tmp/cache \
    && rm -rf /data/app/assets \
    && rm -rf /data/spec \
    && rm -rf /data/solr \
    && rm -rf /data/misc \
    && rm -rf /data/db \
    && rm -rf /data/test

EXPOSE 3000/tcp
CMD ["bundle exec puma -C config/puma/production.rb"]
