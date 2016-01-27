# Physical Devices Dispatcher

Physical devices dispatcher. When a request is made from the cloud (through API) the [physical URL](http://dev.lelylan.com/developers#get-a-device) which is used to decouple the cloud from any physical device or protocol is called to communicate with the physical world. An example of physical URL is the one defined by the [MQTT node](https://github.com/lelylan/nodes).


## Requirements

Lelylan Nodes is tested against Node 0.8.8.


## Installation

    $ mongod
    $ git clone git@github.com:lelylan/physicals.git
    $ npm install && npm install -g foreman
    $ nf start


## Contributing

Fork the repo on github and send a pull requests with topic branches.
Do not forget to provide specs to your contribution.


### Running specs

* Fork and clone the repository
* Run `npm install`
* Run `npm test`


## Coding guidelines

Follow [Felix](http://nodeguide.com/style.html) guidelines.


## Feedback

Use the [issue tracker](http://github.com/lelylan/physicals/issues) for bugs or [stack overflow](http://stackoverflow.com/questions/tagged/lelylan) for questions.
[Mail](mailto:dev@lelylan.com) or [Tweet](http://twitter.com/lelylan) us for any idea that can improve the project.


## Links

* [GIT Repository](http://github.com/lelylan/physicals)
* [Lelylan Dev Center](http://dev.lelylan.com)
* [Lelylan Site](http://lelylan.com)


## Authors

[Andrea Reginato](https://www.linkedin.com/in/andreareginato)


## Contributors

Special thanks to all [contributors](https://github.com/lelylan/physicals/contributors)
for submitting patches.


## Changelog

See [CHANGELOG](https://github.com/lelylan/physicals/blob/master/CHANGELOG.md)


## License

Lelylan is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
