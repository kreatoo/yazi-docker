FROM nixos/nix:2.31.2
RUN mkdir -p /opt /workspace /home/agent /cache /opt/yazi/python \
 && echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf \
 && nix-env -iA nixpkgs.python312 nixpkgs.bashInteractive nixpkgs.coreutils nixpkgs.gnutar nixpkgs.findutils nixpkgs.gnugrep nixpkgs.gnused nixpkgs.gitMinimal nixpkgs.cacert \
 && nix-store --gc \
 && cp -L /etc/passwd /tmp/passwd && cp -L /etc/group /tmp/group \
 && rm /etc/passwd /etc/group && mv /tmp/passwd /etc/passwd && mv /tmp/group /etc/group \
 && tar --exclude='./var/nix/gc-socket' -C /nix -cf /opt/yazi-nix-seed.tar . \
 && chmod 0777 /workspace /home/agent /cache
ENV HOME=/home/agent XDG_CACHE_HOME=/cache NIX_CONFIG="experimental-features = nix-command flakes"
WORKDIR /workspace
CMD ["/bin/sh","-lc","trap : TERM INT; while :; do sleep 3600; done"]
