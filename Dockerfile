FROM ubuntu:14.10
MAINTAINER Pawel Pikula <pawel.pikula@erlang-solutions.com>

ENV HOME /opt/mongooseim
ENV MONGOOSEIM_VERSION stable

# install required packages
RUN apt-get update && apt-get install -y   wget \
                                           git \
                                           make \
                                           gcc \
                                           libc6-dev \
                                           libncurses5-dev \
                                           libssl-dev \
                                           libexpat1-dev \
                                           libpam0g-dev

# add esl packages
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && wget http://packages.erlang-solutions.com/debian/erlang_solutions.asc\
    && apt-key add erlang_solutions.asc \
    && apt-get update \
    && apt-get install -y erlang-base \
                          erlang-dev \
                          erlang-nox \
                          erlang-dialyzer \
                          erlang-reltool

# install mim from source
RUN git clone https://github.com/esl/MongooseIM.git -b $MONGOOSEIM_VERSION /opt/mongooseim \
    && cd /opt/mongooseim \
    && make rel

EXPOSE 5222 5280 5269 4369


#CMD ["live"]
#ENTRYPOINT ["/opt/mongooseim/rel/mongooseim/bin/mongooseimctl"]

