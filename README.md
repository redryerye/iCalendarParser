# iCalendarParser

<p>
    <a href="https://github.com/redryerye/iCalendarParser/actions">
      <img src="https://github.com/redryerye/iCalendarParser/workflows/ci/badge.svg?branch=main">
    </a>
    <img src="https://img.shields.io/badge/Swift-5.7-ff69b4.svg" />
    <img src="https://img.shields.io/badge/license-MIT-black.svg" />
</p>

A [RFC 5545](https://www.ietf.org/rfc/rfc5545.txt) compatible parser for iCalendar files in Swift.

## Installation

To use `iCalendarParser` just add it as Swift Package Manager dependency:

### via Xcode

Open your project, click on File → Add Packages, enter the repository URL (`https://github.com/redryerye/iCalendarParser.git`), and add the package product to your app target.

### via SPM Package.swift

```swift
dependencies: [
    .package(
      name: "iCalendarParser",
      url: "https://github.com/redryerye/iCalendarParser",
      from: "0.3.0"
    )
]
```

## Usage

To get started with iCalendarParser, all you have to do is to import it and use its `ICParser` type to convert any ICS file into iCalendar object:

```swift
import iCalendarParser

let rawICS: String = ...
let parser = ICParser()
let calendar: ICalendar? = parser.calendar(from: rawICS)
```

## Is it production ready?

iCalendarParser is currently not feature complete yet. While it requires an additional implementation to be fully compatible with RFC5545, we appreciate contributions from the community to help us improve the library. 

## TODO

- Parse To-Do, Journal, Free/Busy, and Alarm components
- Add additional properties in `ICEvent`

## Contributing

Contributions to iCalendarParser are welcomed and encouraged!

## License

iCalendarParser is available under the MIT license. See [LICENSE](LICENSE) for more information.

## Credits

- [chan614/iCalSwift](https://github.com/chan614/iCalSwift) (Inspired to create an initial implementation)
- [jswallez](https://github.com/jswallez) (Special thanks 💛)
