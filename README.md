# iCalendarParser

<p>
    <a href="https://github.com/redryerye/iCalendarParser/actions">
      <img src="https://github.com/redryerye/iCalendarParser/actions/workflows/ci.yml/badge.svg?branch=main">
    </a>
    <img src="https://img.shields.io/badge/Swift-5.7-ff69b4.svg" />
    <img src="https://img.shields.io/badge/license-MIT-black.svg" />
</p>

A [RFC 5545](https://www.ietf.org/rfc/rfc5545.txt) compatible parser for iCalendar files in Swift.

> [!NOTE]
> This repository has moved to [redryerye/iCalendarParser](https://github.com/redryerye/iCalendarParser).
> Existing references to the old repository URL should continue to work through GitHub redirects,
> but new package installations and contributions should use the new URL.

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
      from: "0.4.0"
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

- [ ] Components
  - [x] Parse `VEVENT`
  - [x] Parse `VTIMEZONE`
  - [x] Parse `VTODO`
  - [ ] Parse `VJOURNAL`
  - [ ] Parse `VFREEBUSY`
  - [ ] Parse `VALARM`
- [ ] `VEVENT` properties
  - [x] Add `COMMENT`, `CONTACT`, and `RESOURCES`
  - [x] Add `EXDATE` and `RDATE`
  - [x] Add `DURATION`
  - [x] Add `ATTACH`
  - [x] Add `GEO`
  - [x] Add `RELATED-TO`
  - [x] Add `REQUEST-STATUS`
- [ ] Recurrence
  - [x] Parse basic `RRULE`
  - [ ] Expand recurring events into instances
  - [ ] Apply `EXDATE`
  - [ ] Apply `RDATE`
  - [ ] Handle `RECURRENCE-ID` overrides
- [ ] Property parameters
  - [x] Preserve common parameters on parsed properties
  - [x] Support quoted parameter values
  - [x] Support multi-value parameters
  - [x] Support `ALTREP`, `LANGUAGE`, `CN`, `ROLE`, `PARTSTAT`, `RSVP`, `TZID`, and `VALUE`
- [ ] Value types
  - [x] Parse `DATE`
  - [x] Parse `DATE-TIME`
  - [x] Parse `DURATION`
  - [x] Parse `PERIOD`
  - [x] Parse `URI`
  - [x] Parse `UTC-OFFSET`
- [ ] Serialization
  - [ ] Format calendars back to valid `.ics`
  - [x] Fold long lines correctly
  - [x] Escape text values correctly
- [ ] Validation
  - [x] Validate required properties per component
  - [x] Validate mutually exclusive properties, such as `DTEND` and `DURATION`
  - [ ] Validate property cardinality rules
- [ ] Compatibility
  - [ ] Preserve unknown standard properties
  - [x] Preserve `X-` properties and parameters
  - [ ] Add fixture coverage from real-world calendars

## Contributing

Contributions to iCalendarParser are welcomed and encouraged!

## License

iCalendarParser is available under the MIT license. See [LICENSE](LICENSE) for more information.

## Credits

- [chan614/iCalSwift](https://github.com/chan614/iCalSwift) (Inspired to create an initial implementation)
- [jswallez](https://github.com/jswallez) (Special thanks 💛)
