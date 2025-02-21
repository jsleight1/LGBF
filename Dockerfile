ARG RVERSION=4.4.2
FROM rocker/r-ver:$RVERSION

# Install various libraries required for R packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    libz-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libfontconfig1-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libxml2-dev \
    libgit2-dev \
    git \
    texlive-latex-base \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-latex-extra

# Install brave-browser required for shinytest2
RUN curl -fsS https://dl.brave.com/install.sh | sh

# Run application as 'app' user.
RUN addgroup --system app && adduser --system --ingroup app app
RUN mkdir /home/app
RUN chown app:app /home/app
ENV HOME=/home/app
WORKDIR /home/app
USER app

# Install packages required for LGBF
COPY . .
RUN R -e "renv::restore()"

# Install packages required for development and testing
RUN R -e "install.packages(c('devtools', 'rcmdcheck', 'mockery', 'shinytest2', 'covr', 'xml2'))"

# Expose port and run shiny application
EXPOSE 9001
CMD ["R", "-e", "shiny::runApp()"]
