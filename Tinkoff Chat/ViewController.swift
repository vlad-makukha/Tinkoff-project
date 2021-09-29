//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 21.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let logFor = Logger()

    // Срабатывает после загрузки View
    override func viewDidLoad() {
        super.viewDidLoad()
        logFor.log(message: "View moved from init to viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    // Срабатывает перед появлением View на экране
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        logFor.log(message: "View moved from viewDidLoad to viewWillAppear")
    }
    
    // Срабатывает перед тем, как размер View поменяется под размер экрана
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logFor.log(message: "View moved from viewWillAppear to viewWillLayoutSubviews")
    }
    
    // Тут срабатывает AutoLayout
    
    // Срабатывает после того, как размер View изменился под размер экрана
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logFor.log(message: "View moved from viewWillLayoutSubviews to viewDidLayoutSubviews")
    }
    
    // Срабатывает, когда View появляется на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        logFor.log(message: "View moved from viewDidLayoutSubviews to viewDidAppear")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        logFor.log(message: "View moved from viewDidAppear to viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        logFor.log(message: "View moved from viewWillAppear to deinit")

    }
    
}

