FROM ruby:3.4.10-trixie

ARG UID=1000
ARG GID=1000

WORKDIR /site

# Create a non-root user that can match the host user.
RUN groupadd --gid "${GID}" jekyll \
    && useradd \
      --uid "${UID}" \
      --gid "${GID}" \
      --create-home \
      --shell /bin/bash \
      jekyll

# Gemfile.lock may not exist during the initial project setup.
COPY Gemfile* ./

RUN bundle install \
    && chown -R jekyll:jekyll /site /usr/local/bundle

USER jekyll

EXPOSE 4000
EXPOSE 35729

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload", "--force_polling"]

