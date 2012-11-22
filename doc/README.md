##Deploy

The deploy is quite the same, but be careful to check that the worker is up and running
with the command 'heroku ps' or by checking your dashboard.

git push heroku master
heroku ps:scale worker=1

##Organization

lib/logic.coffee This is the file where all the logic is grouped (together with
the models). In here we take off the subscriptions related to a resource and fire
the callback events.

##Foreman

As we deploy on heroku start getting used on make the app running with Foreman

##Testing

Actually, for some unknown reasons (probably nock) the test suite raises
an error if we try to run all specs together. For this reason we must run
just one spec per time. At the moment this is acceptable as we have few
tests, but when they grow we'll have to find a solution for this problem
and also have a working continuous testing system.

    $ gnode spec/app.spec.coffee

Which stays for

    $ foreman run -e .test.env node node_modules/jasmine-node/lib/jasmine-node/cli.js --autotest --coffee spec/app.spec.coffee

If the first time it does not work, just try once more and it should work out.

##Debug

If you want to get some useful messages on production just set the Debug env variable

    heroku config:set DEBUG=true
    heroku config:remove DEBUG
