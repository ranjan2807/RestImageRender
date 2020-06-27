//
//  FileClient.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

struct FileOperations {

	static let ImageFolder = "images"

	static func documentDirectory() -> URL? {
		if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			return documentsPathURL
		} else {
			return nil
		}
	}

	static func imageFileDirectory() -> URL? {
		guard let docDirectory = documentDirectory() else { return nil }
		let localDirectory = docDirectory.appendingPathComponent(ImageFolder)
		checkDirectory(dirPath: localDirectory)

		return localDirectory
	}

	static func localFileUrlFor(url: String?) -> URL? {
		guard let urlTemp = url else { return nil }

		guard let filename = URL.init(string: urlTemp)?.lastPathComponent else { return nil }

		guard let localDirectory = imageFileDirectory() else { return nil }

		return localDirectory.appendingPathComponent(filename)
	}

	static func checkDirectory(dirPath: URL?) {
		guard let urlTemp = dirPath else { return }

		var dirExists = false
		let fileManager = FileManager.default
		var isDir : ObjCBool = false
		if fileManager.fileExists(atPath: urlTemp.path, isDirectory:&isDir) {
			if isDir.boolValue {
				// file exists and is a directory
				dirExists = true
			}
		}

		if !dirExists {
			do {
				try fileManager.createDirectory(at: urlTemp,
												withIntermediateDirectories: true,
												attributes: nil)
			} catch {
				print(error)
			}
		}
	}

	static func checkFileIsAvailable (remoteUrl: String?) -> Bool {
		var flag = false

		guard let urlTemp = remoteUrl else { return false }

		guard let localUrl = localFileUrlFor(url: urlTemp) else { return false }

		let fileManager = FileManager.default
		flag = fileManager.fileExists(atPath: localUrl.path)

		return flag
	}

	static func saveFileForUrl(remoteUrl: String?, fileData: Data?) {
		guard let urlTemp = remoteUrl else { return }

		guard let data = fileData else { return }

		guard let localUrl = localFileUrlFor(url: urlTemp) else { return  }

		let fileManager = FileManager.default

		fileManager.createFile(atPath: localUrl.path, contents: data, attributes: nil)

	}

	static func fileDataFor (remoteUrl: String?) -> Data? {
		guard let urlTemp = remoteUrl else { return nil }

		guard let localUrl = localFileUrlFor(url: urlTemp) else { return nil }

		do {
			return try Data(contentsOf: localUrl, options: .mappedIfSafe)
		} catch  {
			return nil
		}
	}

	
	static func removeALlImageFile () {
		guard let localDirectory = imageFileDirectory() else { return }

		do {
			try FileManager.default.removeItem(at: localDirectory)
		} catch {
			print(error)
		}
	}
}
