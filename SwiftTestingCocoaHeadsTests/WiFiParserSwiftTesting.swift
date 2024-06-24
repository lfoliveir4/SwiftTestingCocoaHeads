import Testing
@testable import SwiftTestingCocoaHeads

extension Tag {
    @Tag static let allFields: Self
    @Tag static let noMatches: Self
}

@Suite("WiFi Parser Tests")
struct WiFiParserSwiftTesting {
    @Suite(
        "All Field Tests",
        .tags(.allFields)
    )
    struct ParseAllFieldsIsCalled {
        let sut: WifiParser
        let errorMonitoring: SpyErrorMonitoring

        init() {
            errorMonitoring = SpyErrorMonitoring()
            sut = WifiParser(monitoring: errorMonitoring)
        }

        @Test("testWhenParseIsCalledWithAllFieldsThenNetworkIsInitialisedCorrectly")
        func nametestWhenParseIsCalledWithAllFieldsThenNetworkIsInitialisedCorrectly() throws {
            let wifi = "WIFI:S:superwificonnection;T:WPA;P:strongpassword;H:YES;;"

            let network = try sut.parse(wifi: wifi)

            #expect(network.security == "WPA")
            #expect(network.hidden == "YES")
            #expect(network.ssid == "superwificonnection")
            #expect(network.password == "strongpassword")
        }
    }

    @Suite(
        "No Matches Tests",
        .tags(.noMatches)
    )
    struct NoMatchTests {
        let sut: WifiParser
        let errorMonitoring: SpyErrorMonitoring

        init() {
            errorMonitoring = SpyErrorMonitoring()
            sut = WifiParser(monitoring: errorMonitoring)
        }

        @Test("testWhenParseIsCalledWithEmptyStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent")
        func testWhenParseIsCalledWithEmptyStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent() {
            #expect { try sut.parse(wifi: "") } throws: { error in
                #expect(error as? WifiParser.Error == .noMatch)
                return true
            }

            #expect(errorMonitoring.monitoredErrors.compactMap { $0 as? WifiParser.Error } == [.noMatch])
        }

        @Test("testWhenParseIsCalledWithPasswordAndNoNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent")
        func testWhenParseIsCalledWithPasswordAndNoNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent() {
            #expect { try sut.parse(wifi: "WIFI:T:WPA;P:strongpassword;H:YES;;") } throws: { error in
                #expect(error as? WifiParser.Error == .noMatch)
                return true
            }

            #expect(errorMonitoring.monitoredErrors.compactMap { $0 as? WifiParser.Error } == [.noMatch])
        }

        @Test("testWhenParseIsCalledWithNoPasswordOrNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent")
        func testWhenParseIsCalledWithNoPasswordOrNameFieldsStringThenNoMatchesErrorIsThrownAndMonitoringEventIsSent() {
            #expect { try sut.parse(wifi: "WIFI:T:WPA;H:YES;;") } throws: { error in
                #expect(error as? WifiParser.Error == .noMatch)
                return true
            }

            #expect(errorMonitoring.monitoredErrors.compactMap { $0 as? WifiParser.Error } == [.noMatch])
        }
    }

    @Suite("Parse String with One Value")
    struct ParseStringwithOneValue {
        let sut: WifiParser
        let errorMonitoring: SpyErrorMonitoring

        init() {
            errorMonitoring = SpyErrorMonitoring()
            sut = WifiParser(monitoring: errorMonitoring)
        }


        @Test("testwhenParseIsCalledWithStringContainingOnlyRequiredFieldsThenCorrectValuesAreReturned")
        func testwhenParseIsCalledWithStringContainingOnlyRequiredFieldsThenCorrectValuesAreReturned() throws {
            let wifi = "WIFI:S:superwificonnection;P:strongpassword;;"

            let network = try sut.parse(wifi: wifi)
            #expect(network.hidden == nil)
            #expect(network.security == nil)
            #expect(network.ssid == "superwificonnection")
            #expect(network.password == "strongpassword")
        }
    }

    @Suite("Strings Are Equal")
    struct StringsAreEqual {
        @Test(
            "Validate Strings Are Equal",
              arguments: [
                "WIFI:S:superwificonnection;P:strongpassword;;"
              ]
        )
        func StringAreEqual(stringToTest: String) async throws {
            #expect(stringToTest != "Other String")
        }
    }
}
