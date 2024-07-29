import Foundation

public enum OnLaunchError: LocalizedError {
    case invalidBaseURL(String)
    case appIdNotConfigured
    case failedToFetchMessages(response: HTTPURLResponse, data: String?)

    public var errorDescription: String? {
        switch self {
        case let .invalidBaseURL(url):
            return "The provided base URL '\(url)' is not valid"
        case .appIdNotConfigured:
            return "You must configure an app ID"
        case let .failedToFetchMessages(response: response, data: data):
            return "Failed to fetch messages, reason: \(response.statusCode) \(data ?? "")"
        }
    }
}
