FROM python:3.10.14

RUN pip3 install dicee==0.1.3.2

#FROM hub.cs.upb.de/dice-research/images/dice-embeddings:1.06

COPY --from=hub.cs.upb.de/enexa/images/enexa-utils:1 / /.
ADD ./module .
CMD ./module
LABEL org.opencontainers.image.source=https://github.com/enexaproject/enexa-dice-embeddings
