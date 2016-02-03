# Physical Proxy

Forward API requests to the physical world. 

When a request is made from the cloud (through API) the [physical URL](http://dev.lelylan.com/api#get-a-device) (used to decouple the cloud from any physical device or protocol) is called by the physical proxy to forward the request to the physical world. An example of physical URL is the [MQTT node](https://github.com/lelylan/nodes).


## Requirements

Lelylan Nodes is tested against Node 0.8.8.


## Installation

    $ git clone git@github.com:lelylan/physicals.git && cd physicals
    $ npm install && npm install -g foreman coffee-script
    $ nf start


## Resources

* [Lelylan Physical API](http://dev.lelylan.com/api#api-physical)
 

## Contributing

Fork the repo on github and send a pull requests with topic branches.
Do not forget to provide specs to your contribution.


### Running specs

    $ npm install
    $ npm test


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
