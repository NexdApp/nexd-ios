//
//  ViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit
import RxSwift

class ViewController<ViewModelType>: UIViewController {
    private var disposeBag: DisposeBag?

    public var viewModel: ViewModelType? {
        didSet {
            if disposeBag == nil {
                return
            }

            bind()
        }
    }

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unbind()
    }

    func bind(viewModel: ViewModelType, disposeBag: DisposeBag) {
        fatalError("bind not implemented!")
    }

    private func bind() {
        let disposeBag = DisposeBag()

        if let viewModel = viewModel {
            bind(viewModel: viewModel, disposeBag: disposeBag)
        }

        self.disposeBag = disposeBag
    }

    private func unbind() {
        self.disposeBag = nil
    }
}
