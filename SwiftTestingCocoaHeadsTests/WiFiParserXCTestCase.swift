import XCTest

class SpyErrorMonitoring: ErrorMonitoring {
    private(set) var monitoredErrors: [Error] = []

    func monitor(_ error: Error) {
        monitoredErrors.append(error)
    }
}

final class WiFiParserXCTestCase: XCTestCase {
    var sut: WifiParser!
    var errorMonitoring: SpyErrorMonitoring!

    override func setUp() {
        errorMonitoring = SpyErrorMonitoring()
        sut = WifiParser(monitoring: errorMonitoring)
    }

    // MARK: - ParseIsCalledWithAllFieldsThenNetworkIsInitialisedCorrectly
    func testWhenParseIsCalledWithAllFieldsThenNetworkIsInitialisedCorrectly() throws {
        let wifi = "WIFI:S:superwificonnection;T:WPA;P:strongpassword;H:YES;;"

        let network = try sut.parse(wifi: wifi)
        XCTAssertEqual(network.security, "WPA")
        XCTAssertEqual(network.hidden, "YES")
        XCTAssertEqual(network.ssid, "superwificonnection")
        XCTAssertEqual(network.password, "strongpassword")
    }

    // MARK: - ParseIsCalledWithEmptyStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent
    func testWhenParseIsCalledWithEmptyStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent() {
        XCTAssertThrowsError(try sut.parse(wifi: "")) { error in
            XCTAssertEqual(error as? WifiParser.Error, .noMatch)
        }

        XCTAssertEqual(errorMonitoring.monitoredErrors.compactMap { $0 as? WifiParser.Error }, [.noMatch])
    }

    // MARK: - ParseIsCalledWithPasswordAndNoNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent
    func testWhenParseIsCalledWithPasswordAndNoNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent() {
        XCTAssertThrowsError(try sut.parse(wifi: "WIFI:T:WPA;P:strongpassword;H:YES;;")) { error in
            XCTAssertEqual(error as? WifiParser.Error, .noMatch)
        }

        XCTAssertEqual(errorMonitoring.monitoredErrors.compactMap { $0 as? WifiParser.Error }, [.noMatch])
    }

    // MARK: - ParseIsCalledWithNoPasswordOrNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent
    func testWhenParseIsCalledWithNoPasswordOrNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent() {
        XCTAssertThrowsError(try sut.parse(wifi: "WIFI:T:WPA;H:YES;;")) { error in
            XCTAssertEqual(error as? WifiParser.Error, .noMatch)
        }

        XCTAssertEqual(errorMonitoring.monitoredErrors.compactMap { $0 as? WifiParser.Error }, [.noMatch])
    }

    // MARK: - ParseIsCalledWithStringContainingOnlyRequiredFieldsThenCorrectValuesAreReturned
    func testwhenParseIsCalledWithStringContainingOnlyRequiredFieldsThenCorrectValuesAreReturned() throws {
        let wifi = "WIFI:S:superwificonnection;P:strongpassword;;"

        let network = try sut.parse(wifi: wifi)

        XCTAssertNil(network.hidden)
        XCTAssertNil(network.security)
        XCTAssertEqual(network.ssid, "superwificonnection")
        XCTAssertEqual(network.password, "strongpassword")
    }

    // MARK: - Strings Are Squal
    func test_firstStringWithOtherStringNotEqual() {
      let a: String = "WIFI:S:superwificonnection;P:strongpassword;;"
      let b: String = "Other String"

      XCTAssertNotEqual(a, b)
    }

    // MARK: - Strings Are Squal 2
    func test_secondtStringWithOtherStringNotEqual() {
      let a: String = "WIFI:S:superwificonnection;P:strongpassword;;"
      let b: String = "Other String"

      XCTAssertNotEqual(a, b)
    }

    // MARK: - Strings Are Squal 2
    func test_thirdStringWithOtherStringNotEqual() {
      let a: String = "WIFI:S:superwificonnection;P:strongpassword;;"
      let b: String = "Other String"

      XCTAssertNotEqual(a, b)
    }
}
