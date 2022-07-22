//
//  ViewModel.swift
//  Foody
//
//  Created by duc nguyen on 22/07/2022.
//

import RxSwift

public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}
