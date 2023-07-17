FROM dice-embeddings
COPY --from=enexa-utils:1 / /.
ADD ./module .
CMD ./module
