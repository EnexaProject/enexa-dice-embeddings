FROM python:3.10.14

RUN pip3 install dicee==0.1.3.2

COPY --from=hub.cs.upb.de/enexa/images/enexa-utils:1 / /.
ADD ./module .
CMD ./module
