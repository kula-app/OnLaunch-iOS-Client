struct ApiMessageDto: Decodable {
    let id: Int
    let blocking: Bool
    let title: String
    let body: String
    let actions: [ApiActionDto]
}
