import Foundation

struct WifiNetwork {
    let ssid: String
    let password: String
    let security: String?
    let hidden: String?
}

protocol ErrorMonitoring {
    func monitor(_ error: Error)
}

public struct WifiParser {
    enum Error: Swift.Error {
        case noMatch
    }

    private let monitoring: ErrorMonitoring

    init(monitoring: ErrorMonitoring) {
        self.monitoring = monitoring
    }

    func parse(wifi: String) throws -> WifiNetwork {
        let regex = /WIFI:S:(?<ssid>[^;]+);(?:T:(?<security>[^;]*);)?P:(?<password>[^;]+);(?:H:(?<hidden>[^;]*);)?;/

        guard let result = try? regex.wholeMatch(in: wifi) else {
            let error = Error.noMatch
            monitoring.monitor(error)
            throw error
        }

        return .init(
            ssid: String(result.ssid),
            password: String(result.password),
            security: result.security.map(String.init),
            hidden: result.hidden.map(String.init)
        )
    }
}
