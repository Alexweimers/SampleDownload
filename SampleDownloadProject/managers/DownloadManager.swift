//
//  DownloadManager.swift
//  SampleDownloadProject
//

import Foundation
import OSLog

class DownloadManager: NSObject, ObservableObject {
    static var shared = DownloadManager()

    private var urlSession: URLSession!
    @Published var tasks: [URLSessionTask] = []
    
    override private init() {
        super.init()

        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())

        updateTasks()
    }

    func startDownload(url: URL) {
        let task = urlSession.downloadTask(with: url)
        task.resume()
        tasks.append(task)
    }

    private func updateTasks() {
        urlSession.getAllTasks { tasks in
            DispatchQueue.main.async {
                self.tasks = tasks
            }
        }
    }
}

extension DownloadManager: URLSessionDelegate {
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten _: Int64, totalBytesExpectedToWrite _: Int64) {
        os_log("Progress %f for %@", type: .debug, downloadTask.progress.fractionCompleted, downloadTask)
    }

    func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            os_log("Download error: %@", type: .error, String(describing: error))
        } else {
            os_log("Task finished: %@", type: .info, task)
        }
    }
}
