//
//  MenuViewModel.swift
//  Foody
//
//  Created by duc nguyen on 21/07/2022.
//

import Foundation
import RxCocoa
import RxSwift

struct MenuViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
        let reload: Driver<Void>
        let selectProduct: Driver<IndexPath>
    }

    struct Output {
        let productSubject = PublishSubject<[DrinkModel]>()
        let isShowLoading = PublishSubject<Bool>()
        let error = PublishSubject<Error?>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let api = input.load
            .asObservable()
            .flatMapLatest { _ -> Observable<(Error?, Data?)> in
                output.isShowLoading.onNext(true)
                return APIService.share
                    .get(urlString: Constants.URL.drinkURL)
            }
        
        let dataFromServer = api.filter { $0.1 != nil }
            .map { $0.1! }
            .do(onNext: { data in
                UserDefaults.standard.set(data, forKey: "drink_key")
            })
            .map { data -> [DrinkModel] in
                return DrinkContainer.decode(data)
            }
            
        
        let failed = api.filter { $0.0 != nil }
            .map { _ -> [DrinkModel] in
                guard let data = UserDefaults.standard.data(forKey: "drink_key") else { return [] }
                return DrinkContainer.decode(data)
            }
            
        let showAlert = failed.filter { $0.isEmpty }
            .withLatestFrom(api)
            .map { $0.0 }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { error in
                output.isShowLoading.onNext(false)
                output.error.onNext(error)
            }, onCompleted: nil, onDisposed: nil)
        showAlert.disposed(by: disposeBag)
        
        let dataFromDatabase = failed.filter { !$0.isEmpty }
        
        let drinks = Observable.merge(dataFromServer, dataFromDatabase.asObservable())
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { drinks in
                output.isShowLoading.onNext(false)
                output.productSubject.onNext(drinks)
            },onCompleted: nil, onDisposed: nil)
        drinks.disposed(by: disposeBag)
        
        return output
    }
}
