//
//  MenuViewController.swift
//  Foody
//
//  Created by duc nguyen on 21/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    
    private var viewModel: MenuViewModel!
    private let load = PublishSubject<Void>()
    
    private var session = URLSession(configuration: .default)
    
    init(viewModel: MenuViewModel) {
        super.init(nibName: "MenuViewController", bundle: Bundle.main)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load.on(.next(()))
    }
    
    private func setupView() {
        tableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
    }
    
    private func bindViewModel() {
        let input = MenuViewModel.Input(load: load.asDriver(onErrorJustReturn: ()),
                                        reload: Driver.just(()),
                                        selectProduct: tableView.rx.itemSelected.asDriver())
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        output?
            .productSubject
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "MenuItemCell")) { (_, model, cell: MenuItemCell) in
                cell.bindingData(model)
            }
            .disposed(by: disposeBag)
        
        output?
            .isShowLoading
            .asObservable()
            .map { !$0 }
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output?
            .error
            .asObserver()
            .do { error in
                self.showAlert(message: error?.localizedDescription ?? "", actions: ["Thử lại", "Hủy bỏ"]) { idx in
                    if idx == 0 {
                        self.load.onNext(())
                    }
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
