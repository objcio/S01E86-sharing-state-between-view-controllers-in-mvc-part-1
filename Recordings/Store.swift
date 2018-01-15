import Foundation

final class Store {
	static let ChangedNotification = Notification.Name("StoreChanged")
	static private let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
	static let shared = Store(url: documentDirectory)
	
	let baseURL: URL
	private(set) var rootFolder: Folder
	
	init(url: URL) {
		self.baseURL = url
		
		if let data = try? Data(contentsOf: url.appendingPathComponent(.storeLocation)),
		let json = try? JSONSerialization.jsonObject(with: data, options: []),
		let folder = Item.load(json: json) as? Folder {
			self.rootFolder = folder
		} else {
			self.rootFolder = Folder(name: "", uuid: UUID())
		}
		
		self.rootFolder.store = self
	}
	
	func fileURL(for recording: Recording) -> URL {
		return baseURL.appendingPathComponent(recording.uuid.uuidString + ".m4a")
	}
	
	func save(_ notifying: Item, userInfo: [AnyHashable: Any]) {
		let json = rootFolder.json
		let data = try! JSONSerialization.data(withJSONObject: json, options: [])
		try! data.write(to: baseURL.appendingPathComponent(.storeLocation))
		NotificationCenter.default.post(name: Store.ChangedNotification, object: notifying, userInfo: userInfo)
	}
	
	func item(atUuidPath path: [UUID]) -> Item? {
		guard let first = path.first, first == rootFolder.uuid else { return nil }
		return rootFolder.item(atUuidPath: path, startingAtIndex: 1)
	}
}

fileprivate extension String {
	static let storeLocation = "store.json"
}
