FROM debian:9.13 as environment 

RUN apt-get update && apt-get install git clang cmake make gcc g++ libmariadbclient-dev libssl1.0-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mariadb-server p7zip  -y
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100

FROM environment as buildStep

COPY . /src
WORKDIR /src/build

RUN cmake /src -DSCRIPTS="dynamic" -DCMAKE_INSTALL_PREFIX=/app -DCONF_DIR=/app/etc
RUN make -j$(nproc) && make install

FROM environment as mapextractor

COPY --from=buildStep /app/lib /app/lib
COPY --from=buildStep /app/bin/mapextractor /app/
COPY ./scripts/mapextractor.sh /app/

RUN chmod +x /app/mapextractor.sh

ENV WOW_DIR /wow
ENV OUTPUT_DIR /output

VOLUME /wow
WORKDIR /wow

ENTRYPOINT ["/app/mapextractor.sh"]

FROM environment as vmap4extractor

COPY --from=buildStep /app/lib /app/lib
COPY --from=buildStep /app/bin/vmap4extractor /app/
COPY --from=buildStep /app/bin/vmap4assembler /app/
COPY ./scripts/vmap4extractor.sh /app/

RUN chmod +x /app/vmap4extractor.sh

WORKDIR /wow

ENV WOW_DIR /wow
ENV OUTPUT_DIR /output

VOLUME /wow
WORKDIR /wow

ENTRYPOINT ["/app/vmap4extractor.sh"]

FROM environment as mmaps_generator

COPY --from=buildStep /app/lib /app/lib
COPY --from=buildStep /app/bin/mmaps_generator /app/
COPY ./scripts/mmaps_generator.sh /app/

RUN chmod +x /app/mmaps_generator.sh

WORKDIR /wow

ENV WOW_DIR /wow
ENV OUTPUT_DIR /output

VOLUME /wow
WORKDIR /wow

ENTRYPOINT ["/app/mmaps_generator.sh"]

FROM environment as worldserver

COPY --from=buildStep /app/lib /app/lib
COPY --from=buildStep /app/worldserver /app/

VOLUME /app/etc
VOLUME /app/data

EXPOSE 8085/tcp
EXPOSE 8086/tcp
EXPOSE 1119/tcp
EXPOSE 8081/tcp
EXPOSE 3443/tcp

WORKDIR /app

ENTRYPOINT ["/app/worldserver"]

FROM environment as bnetserver

COPY --from=buildStep /app/lib /app/lib
COPY --from=buildStep /app/bnetserver /app/

VOLUME /app/etc

EXPOSE 3724/tcp

ENTRYPOINT ["/app/bnetserver"]
