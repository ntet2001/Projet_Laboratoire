
FROM haskell:8.10.7

LABEL maintainer    = "Neudjieu Raoul"
LABEL creation_date = "August 15, 2024"

WORKDIR /opt/efa

RUN cabal update

#COPY ./EFA.cabal /opt/efa/EFA.cabal

# cette commande telecharge uniquement les depences du fichier .cabal
#RUN cabal build --only-dependencies -j4 

COPY . /opt/efa

RUN cabal install

EXPOSE 8081

CMD ["EFA-exe"]