# Application

# Robin hat was geändert

# Jona hat was geändert #schickenspicker
# Ann-Christin hat was geändert
# Jona und Adrian! hat was geändert #schickenspicker



## Intro

Es handelt sich um eine (ältere) "three-tier" Applikation mit frontend, api, database.
Für diesen Hackathon dient die Applikation nur als Mittel zum Zweck, und die Entwicklung an der Applikation steht hier **nicht** im Fokus. Aus DevOps Sicht ist es trotzdem relevant zu wissen, wie die Architektur der Applikation aussieht und welche Technologien eingesetzt werden, da ihr bei dem Deployment und den Operationstätigkeiten unterstützen sollt.

## Architektur und Verzeichnis Struktur

<img src="./application/docs/dobib.drawio.png">

Im `/application` Verzeichnis findet ihr drei Unterverzechnisse wieder.

- frontend - Das Web Frontend (Presentation Layer) in React geschrieben
- api - Die API (Logik Layer) in Node.js geschrieben
- db-seed - Eine Utility um die Datenbank zu befüllen

Die Datenbank selber ist wie ihr seht nicht als eigenes Verzechnis vorhanden, dass hat den Grund weil es aus Applikations Sicht egal ist wo die Datenbank ist. Gebräuchlich ist dass die Entwickler eine lokale Datenbank, in diesem Fall eine Mongo DB, hochfahren, als ein Container (wird in einer Challenge näher erläutert).

## Frontend

Die Applikation besteht im wesentlichen aus drei Seiten

- `/books` - Übersicht der Bücher und Verleihstatus
- `/books/:bookID` - Detail Seite eines Buches mit Button zum ausleihen und zurückgeben
- `/admin` - Admin Seite um Bücher zu verwalten

<img src="./application/docs/dobib.app.png">

# Documentation


```sh
docker compose build
docker tag application_api schinkenspickermanual.azurecr.io/application_api:latest
docker tag application_frontend schinkenspickermanual.azurecr.io/application_frontend:latest
docker tag application_mongo-seed schinkenspickermanual.azurecr.io/application_mongo-seed:latest
az acr login -n schinkenspickermanual
docker push schinkenspickermanual.azurecr.io/application_frontend:latest
docker push schinkenspickermanual.azurecr.io/application_mongo-seed:latest
docker push schinkenspickermanual.azurecr.io/application_api:latest
```

```sh
terraform init
terraform plan
terraform apply
```

# AppService erstellen
```sh
az appservice plan create --name spickerPlan --resource-group schinkenspicker --sku B2 --is-linux
```

## WebApp erstellen
```sh
az webapp create --resource-group schinkenspicker --plan spickerPlan --name spickerApp --multicontainer-config-type compose --multicontainer-config-file compose-wordpress.yml
```

- im Deployment Center (Azure) docker-compose.webapp.yml angepasst (kopiert aus Github)

## Seeding
From local machnine, get mongoDB URI from azure
```sh
docker pull schinkenspicker.azurecr.io/bib/db-seed:latest
read -s -p 'mongoDB URI: ' URI
docker run -e URI=$URI schinkenspicker.azurecr.io/bib/db-seed:latest
```

## Policy
- Create policy with parameter:
```ps
$policy = '{
    "if": {
        "allOf": [{
                "field": "type",
                "equals": "Microsoft.Storage/storageAccounts"
            },
            {
                "not": {
                    "field": "location",
                    "in": "[parameters(''allowedLocations'')]"
                }
            }
        ]
    },
    "then": {
        "effect": "Deny"
    }
}'

$parameters = '{
    "allowedLocations": {
        "type": "array",
        "metadata": {
            "description": "The list of locations that can be specified when deploying storage accounts.",
            "strongType": "location",
            "displayName": "Allowed locations"
        }
    }
}'

$definition = New-AzPolicyDefinition -Name 'storageLocations' -Description 'Policy to specify locations for storage accounts.' -Policy $policy -Parameter $parameters
```

- apply policy with parameter `locations = ['West Europe']`
- look at policy dashboard
	- 0% compliance
- change parameter to `locations = ['West Europe', 'North Europe']`