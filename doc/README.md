# Deploy

The deploy is quite the same, but be careful to check that the worker is up and running
with the command 'heroku ps' or by checking your dashboard.

```bash
git push heroku master
heroku ps:scale worker=1
```

# Organization

lib/logic.coffee This is the file where all the logic is grouped (together with
the models). In here we take off the subscriptions related to a resource and fire
the callback events.

# Foreman

As we deploy on heroku start getting used on make the app running with Foreman

# Testing

Actually, for some unknown reasons (probably nock) the test suite raises
an error if we try to run all specs together. For this reason we must run
just one spec per time. At the moment this is acceptable as we have few
tests, but when they grow we'll have to find a solution for this problem
and also have a working continuous testing system.

```bash
    $ gnode spec/app.spec.coffee
```

Which stays for

```bash
    $ foreman run -e .test.env node node_modules/jasmine-node/lib/jasmine-node/cli.js --autotest --coffee spec/app.spec.coffee
```

If the first time it does not work, just try once more and it should work out.

# Debug

If you want to get some useful messages on production just set the Debug env variable

```bash
    heroku config:set DEBUG=true
    heroku config:remove DEBUG
```

# Testing

## Get an access token

```
20495a1d2b1cb7f90d994acc9f90bfa8695a3d87ed7992fe9575cea962e3d7a2
```

## Crete a property

```bash
result http://localhost:3002/properties/50ae452dd033a97ecf000001
```

```bash
curl -X POST http://localhost:3002/properties.json \
      -H 'Authorization: Bearer 20495a1d2b1cb7f90d994acc9f90bfa8695a3d87ed7992fe9575cea962e3d7a2' \
      -H 'Content-Type: application/json' \
      -d '{
            "name": "status",
            "default": "off",
            "values": ["on","off"]
          }'
```

## Create a type
```bash
result http://localhost:3002/types/50ae45b3d033a94f6c000001
```
```bash
curl -X POST http://localhost:3002/types \
     -H 'Authorization: Bearer 20495a1d2b1cb7f90d994acc9f90bfa8695a3d87ed7992fe9575cea962e3d7a2' \
     -H 'Content-Type: application/json' \
     -d '{
           "name": "Light",
           "properties": [ "http://localhost:3002/properties/50ae452dd033a97ecf000001" ]
         }'
```

## Create a device
```bash
result http://localhost:3001/devices/50ae4647d033a97575000001
```
```bash
curl -X POST http://localhost:3001/devices \
    -H 'Authorization: Bearer 20495a1d2b1cb7f90d994acc9f90bfa8695a3d87ed7992fe9575cea962e3d7a2' \
    -H 'Content-Type: application/json' \
    -d '{
          "name": "Smart light",
          "type": "http://localhost:3002/types/50ae45b3d033a94f6c000001",
          "physical": "http://arduino.house.com/5042205c70eda61"
        }'
```

## Update properties and fire physical device update
```bash
curl -X PUT http://localhost:3001/devices/50ae4647d033a97575000001/properties \
    -H 'Authorization: Bearer 20495a1d2b1cb7f90d994acc9f90bfa8695a3d87ed7992fe9575cea962e3d7a2' \
    -H 'Content-Type: application/json' \
    -d '{
          "properties": [{
            "uri": "http://localhost:3002/properties/50ae452dd033a97ecf000001",
            "value": "on" }]
        }'
```bash
