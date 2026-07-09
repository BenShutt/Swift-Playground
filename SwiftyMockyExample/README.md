# SwiftyMockyExample

Example of how to use [SwiftyMocky](https://github.com/MakeAWishFoundation/SwiftyMocky) for unit testing.

The `swiftymocky` CLI (a SwiftPM executable) is installed using [Mint](https://github.com/yonaskolb/Mint) as documented in the SwiftyMocky [README](https://github.com/MakeAWishFoundation/SwiftyMocky?tab=readme-ov-file#installation).

## Update mocks

```bash
./Scripts/mocks.sh
```

## Notes

### Mock.swifttemplate

[SwiftyMocky PR #363](https://github.com/MakeAWishFoundation/SwiftyMocky/pull/363) resolves a Swift characters error in the `Mock.swifttemplate` of SwiftyMocky.
This has been merged into `master` but not released at time of writing.
As a result, we download the `Mock.swifttemplate` file via a script when generating mocks.
This template is referenced from the `Mockfile`.

Despite referencing `master` of SwiftyMocky, I _think_ this is still an issue because the template in the CLI is out of date, Base64?

It doesn't seem like SwiftyMocky is actively maintained.

### Swift Testing

Since `MockyAssertion` of SwiftyMocky uses `XCTAssert`, this project adds the `SuiteTrait` `SwiftyMockySwiftTestingAssertion` so it works with Swift Testing.
