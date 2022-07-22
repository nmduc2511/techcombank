//
//  APIService.swift
//  Foody
//
//  Created by duc nguyen on 21/07/2022.
//

import RxSwift
import RxCocoa
import Foundation

class APIService {
    static let share = APIService()
    private let session = URLSession(configuration: .default)
    
    func get(urlString: String) -> Observable<(Error?, Data?)> {
        guard let url = URL(string: urlString) else {
            return Observable.create { observer in
                observer.onNext((RxCocoaURLError.unknown, nil))
                observer.on(.completed)
                return Disposables.create()
            }
        }
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: URLRequest(url: url)) { data, response, error in
                guard let response = response, let data = data else {
                    observer.onNext((error ?? RxCocoaURLError.unknown, nil))
                    observer.on(.completed)
                    return
                }

                guard let _ = response as? HTTPURLResponse else {
                    observer.onNext((RxCocoaURLError.nonHTTPResponse(response: response), nil))
                    observer.on(.completed)
                    return
                }
                observer.onNext((nil, data))
                observer.on(.completed)
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
