ARG RVERSION=4.4.2
ARG TARGETPLATFORM
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
    gnupg \
    pandoc \
    sudo \
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

# Install packages required for LGBF
RUN git clone https://github.com/jsleight1/LGBF.git .
RUN rm -rf .Rprofile renv
RUN ls -lth
RUN Rscript -e "install.packages('renv')"
RUN R -e "renv::restore()"

# Expose port and run shiny application
USER app
EXPOSE 9001
CMD ["R", "-e", "shiny::runApp()"]
