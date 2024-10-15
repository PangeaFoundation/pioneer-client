# Pioneer Client

A Swift Package to connect to Pangea data sources and consume token and pricing data.  This library defines endpoints and data types, and exposes functions to retrieve and decode data.  It also contains test data to assist in verification and quick UI prototyping.

This is used by the [Pioneer app](https://github.com/PangeaFoundation/pioneer).

## Prerequisites

This library uses Swift 6.  You will need the most recent version of XCode or the [`swift` command line](https://www.swift.org/install/macos/) to build it.

You will also need credentials to access Pangea data.  You can request those here:
<https://docs.pangea.foundation/#client-access>

## Setup

First, clone this repo:

```
git clone git@github.com:PangeaFoundation/pioneer-client.git
```

You can build from the command line:

```
swift build
```

You can also run tests from the command line:

```
swift test
```

To add this to your Swift PM-based project, update your `Package.swift` file and add this to the `dependencies` section:

```
      dependencies: [
            .package(url: "https://github.com/PangeaFoundation/pioneer-client", .branc("master")),
        ],
```

Then add the dependency to your target:
```
    .target(
        name: "MyApp",
        dependencies: ["PangeaAggregator"]),
```

Adding this as a dependency to an XCode-based project is more complicated. The process is described here:  

<https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app>

You should use this package URL:

`git@github.com:PangeaFoundation/pioneer-client.git`

## Usage

The main object in this package is the `PangeaAggregatorClient`.  Here is the initializer:

```
    public init(apiHost: String,
                authToken: String,
                tokenAddressWhitelist: [String]?)
```

- `apiHost` is the hostname, e.g. `app.pangea.foundation`
- `authToken` is the authorization token for your credentials
- `tokenAddressWhitelist` is the list of addresses for the tokens you are interested in.  If this is `nil`, requesting the list of tokens will return all of them.

For more information on how to use this, consult the [Pioneer app](https://github.com/PangeaFoundation/pioneer).
