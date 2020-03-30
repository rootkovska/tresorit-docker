# Tresor in a docker

A Tresorit client in a docker. Useful for persons having multiple Tresorit accounts (e.g.: one personal and another from work), as the Tresorit default client allows syncing/managing only one account per one desktop session. Also useful for scripts running on servers and other headless devices.

## Build and deploy

```
docker-compose build
docker-compose up -d
```

## Configure each service

```
docker-compose exec tresorit-personal bash
./tresorit-cli status
./tresorit-cli login --email <email> --password <pass>
./tresorit-cli tresors
./tresorit-cli sync --start <tresor_name> --path /vol/<name>
```

## Manual docker run & sync:

docker run -it \
  -v ~/myprofiles/tresorit:/home/tresorit/Profiles/ \
  -v ~/vols/tresorit/:/vols \
  tresorit
