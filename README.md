# Boxo Sample App

This project demonstrates the integration of Boxo SDK into an iOS application.

## Project Setup

### Getting Client ID

1. Register on the [Boxo](https://boxo.io) platform
2. Create a new host app in the dashboard
3. Copy your Client ID from the host app settings

### Setting Client ID

In the `AppDelegate.swift` file, replace the `CLIENT_ID`:

```swift
let config = Config(clientId: "CLIENT_ID")
```

## License

This project is licensed under the MIT License.
