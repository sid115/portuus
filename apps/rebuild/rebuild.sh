USER="$(whoami)"
HOST="portuus"
DOMAIN="portuus.de"
PORT="2299"

NIX_SSHOPTS="-p $PORT" rebuild nixos -p . -H "$HOST" -B "$USER"@"$DOMAIN" -T "$USER"@"$DOMAIN"
