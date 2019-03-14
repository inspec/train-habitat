# Train-Habitat

Train Plugin for connecting to Habitat installations

## To Install this as a User

You will need InSpec v2.3 or later.

Simply run:

$ inspec plugin install train-habitat

## Using the plugin as a Train Transport

### Dual-mode transport

Because habitat exposes some facts by its HTTP Gateway API, and some facts by its CLI tool `hab`, this Train Transport has three modes of operation:

 * Using only the HTTP API (no ability to query packages, but rich ability to query rings)
 * Using only the `hab` CLI command (limitations TBD)
 * Using both (full capabilities)

When creating a train-habitat Connection, there are thus two sets of options, prefixed with `api_` and `cli_` respectively. You must provide at least one set.

### API-Mode options

#### api_url

* TODO - fill in on modernization PR

### CLI Mode options

CLI options are moore varied, and are entirely dependent on the underlying transport chosen to reach the CLI. For example, if there were a supported transport named 'radio' which took options 'channel' and 'band', specify them to train-habitat like this:

```ruby
Train.create(:habitat, {cli_radio_band: 'VHF', cli_radio_channel: 23})
```

train-habitat will use the prefixes to identify the underlying transport and use it to connect to a location that can provide access to the `hab` CLI tool.

It is an error to specify more than one CLI sub-transport.

Currently supported CLI transports include:
* TODO - fill in SSH options on SSH PR

## Development

### Testing
```
# Install development tools
$ gem install bundler
$ bundle install

# Running style checker
bundle exec rake lint

# Running unit tests
bundle exec rake test:unit

# Running integration tests (requires Vagrant and VirtualBox)
bundle exec rake test:integration
```

## Contributing

1. Fork it
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -sam 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create new Pull Request

## License

| **Author:**          | Paul Welch

| **Author:**          | David McCown

| **Author:**          | Clinton Wolfe

| **Copyright:**       | Copyright (c) 2018-2019 Chef Software Inc.

| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
