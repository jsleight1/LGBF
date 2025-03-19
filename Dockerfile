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

# Install chrome on amd64 architectures. This is not possible for arm64.
RUN if [ "$TARGETPLATFORM" = "amd64" ]; then apt update && apt install -y google-chrome-stable; fi;

# Run application as 'app' user.
# RUN addgroup --system app && adduser --system --ingroup app app
# RUN mkdir /home/app
# RUN chown app:app /home/app
# ENV HOME=/home/app
# WORKDIR /home/app

# Install packages required for LGBF
RUN git clone https://github.com/jsleight1/LGBF.git \
    && cd LGBF \
    && git checkout -b '6-build-docker-image-using-ci' 'origin/6-build-docker-image-using-ci' \
    && rm -rf .Rprofile renv \
    && Rscript -e "install.packages('renv')" \
    && R -e "renv::restore()"

# RUN rm -rf .Rprofile renv
# RUN ls -lth
# RUN Rscript -e "install.packages('renv')"
# RUN R -e "renv::restore()"

# Install packages required for development and testing
RUN Rscript -e "install.packages(c('devtools', 'rcmdcheck', 'mockery', 'shinytest2', 'covr', 'xml2'))"

# Expose port and run shiny application
USER app
EXPOSE 9001
CMD ["R", "-e", "shiny::runApp()"]
