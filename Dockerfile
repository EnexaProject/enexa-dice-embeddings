FROM dice-embeddings
COPY --from=hub.cs.upb.de/enexa/images/enexa-utils:1 / /.
ADD ./module .
CMD ./module
