//
//  FileClient.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

/// File related handing in app
struct FileOperations {

	/// Document directory image folder where a;ll downloaded images are cached/saved
	static let ImageFolder = "images"

	/// Returns url of  local document directory of app
	static func documentDirectory() -> URL? {
		if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			return documentsPathURL
		} else {
			return nil
		}
	}

	/// Return url of local image directory (inside doc directory)
	static func imageFileDirectory() -> URL? {
		guard let docDirectory = documentDirectory() else { return nil }
		let localDirectory = docDirectory.appendingPathComponent(ImageFolder)
		checkDirectory(dirPath: localDirectory)

		return localDirectory
	}

	/// Checks specified directory is available, if not, it will create the directory
	/// - Parameter dirPath: specified directory path
	static func checkDirectory(dirPath: URL?) {
		guard let urlTemp = dirPath else { return }

		var dirExists = false
		let fileManager = FileManager.default
		var isDir : ObjCBool = false

		// check directory exists in local document directory
		if fileManager.fileExists(atPath: urlTemp.path, isDirectory:&isDir) {
			if isDir.boolValue {
				// file exists and is a directory
				dirExists = true
			}
		}

		// if directory do not exists, then add a new directoy
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

	/// Returns local image file url inside image directory of document directory
	/// - Parameter url: remote url
	static func localFileUrlFor(url: String?) -> URL? {
		// unwrap remote url
		guard let urlTemp = url else { return nil }

		// return file name from remote url
		guard let filename = URL.init(string: urlTemp)?.lastPathComponent else { return nil }

		// returns local image directory of app
		guard let localDirectory = imageFileDirectory() else { return nil }

		// returns file url inside local image directory
		return localDirectory.appendingPathComponent(filename)
	}

	/// Checks specified file url is available in local image directory
	/// - Parameter remoteUrl: remote url of file
	static func checkFileIsAvailable (remoteUrl: String?) -> Bool {
		var flag = false

		// unwrap remote url
		guard let urlTemp = remoteUrl else { return false }

		// retreive local file url
		guard let localUrl = localFileUrlFor(url: urlTemp) else { return false }

		// check if file exists in local image directory
		let fileManager = FileManager.default
		flag = fileManager.fileExists(atPath: localUrl.path)

		return flag
	}

	/// Saves remote image data into image directory
	/// - Parameters:
	///   - remoteUrl: remote url of file
	///   - fileData: image data downloaded from remote url
	static func saveFileForUrl(remoteUrl: String?, fileData: Data?) {
		// unwrap remote url
		guard let urlTemp = remoteUrl else { return }

		// unwrap file data
		guard let data = fileData else { return }

		// generate the local url of image file
		guard let localUrl = localFileUrlFor(url: urlTemp) else { return  }

		// save the image file in local directory path
		let fileManager = FileManager.default
		fileManager.createFile(atPath: localUrl.path, contents: data, attributes: nil)

	}

	/// Reteives file data stored in local directory
	/// - Parameter remoteUrl: remote url of image
	static func fileDataFor (remoteUrl: String?) -> Data? {
		// unwrap remote url
		guard let urlTemp = remoteUrl else { return nil }

		// get local image file path
		guard let localUrl = localFileUrlFor(url: urlTemp) else { return nil }

		// retrieve local image file data
		do {
			return try Data(contentsOf: localUrl, options: .mappedIfSafe)
		} catch  {
			return nil
		}
	}

	/// removes image directory along with its image file
	static func removeAllImageFile () {
		// get local image file path
		guard let localDirectory = imageFileDirectory() else { return }

		// remove image directory along with its files
		do {
			try FileManager.default.removeItem(at: localDirectory)
		} catch {
			print(error)
		}
	}
}
