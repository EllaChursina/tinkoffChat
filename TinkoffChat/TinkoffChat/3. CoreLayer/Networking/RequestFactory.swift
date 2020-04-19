//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 17.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct PixabayRequests {
        private static let apiKey = "8971707-84f2b9a4a6386756a09b58d17"
        
        static func searchImages() -> RequestConfig<SearchImagesParser> {
            let request = SearchImagesRequest(key: apiKey)
            let parser = SearchImagesParser()
            return RequestConfig<SearchImagesParser>(request: request, parser: parser)
        }
        
        static func downloadImage(urlString: String) -> RequestConfig<DownloadImageParser> {
            let request = DownloadImageRequest(urlString: urlString)
            let parser = DownloadImageParser()
            return RequestConfig<DownloadImageParser>(request: request, parser: parser)
        }
    }
}
