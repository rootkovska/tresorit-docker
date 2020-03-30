FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    curl xxd

COPY check_signature.sh /home/tresorit/
RUN chmod +x /home/tresorit/check_signature.sh
RUN useradd --create-home --shell /bin/bash \
            --user-group --groups adm,sudo tresorit
WORKDIR /home/tresorit
RUN chown tresorit /home/tresorit

RUN cd /home/tresorit && \
    curl -LO https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run && \
    ls -al /home/tresorit/ && \ 
    /home/tresorit/check_signature.sh && \
    chmod +x ./tresorit_installer.run && \
    echo "Tresorit installer image downloaded & verified ok."

USER tresorit
    
# The --update-v2 <dir> sets the dest installation dir:
RUN  ./tresorit_installer.run --update-v2 . && \
     echo "Tresorit installed ok."

RUN mkdir -p /home/tresorit/Profiles \
             /home/tresorit/external

VOLUME /home/tresorit/Profiles /vols

USER root

COPY start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
CMD ["start"]
