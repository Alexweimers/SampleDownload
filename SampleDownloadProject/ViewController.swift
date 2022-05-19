//
//  ViewController.swift
//  SampleDownloadProject
//
//

import UIKit
import OSLog

class ViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    
    private var urlSession: URLSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Default set to disabled until download is completed
        // Only here for the sake of UITest
        openButton.isEnabled = false
    }
    
    func getUserDirectoryPath() -> String? {
        if let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.path {
            return path + "/" + "TestDirectory"
        }
        return nil
    }

    @IBAction func downloadButtonTapped(_ sender: Any) {
        downloadButton.isEnabled = false
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.example.DownloadTaskExample.background")
        config.allowsConstrainedNetworkAccess = false
        config.allowsCellularAccess = false
        config.allowsExpensiveNetworkAccess = false
        config.isDiscretionary = false
        config.httpMaximumConnectionsPerHost = 10
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "https://example.com/example.pdf")!
        let task = session.downloadTask(with: url)
        task.resume()
        DownloadManager.shared.startDownload(url: url)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        os_log("Download finished: %@", type: .info, location.absoluteString)
        // The file at location is temporary and will be gone afterwards
        try? FileManager.default.removeItem(atPath: getUserDirectoryPath()!)
        do {
            try FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: getUserDirectoryPath()!))
            os_log("Download completed for tracking identifier to path \(self.getUserDirectoryPath()!)")
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = true
                self.openButton.isEnabled = true
            }
        } catch {
            os_log("Failed to relocate completed download file from \(location) to \(self.getUserDirectoryPath()!)")
            return
        }
    }
}


