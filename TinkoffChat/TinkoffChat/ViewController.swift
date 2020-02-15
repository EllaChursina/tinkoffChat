//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 13.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController is loaded into memoty: " + #function)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController's view is about to be added to a view hierarchy: " + #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ViewController's view was added to a view hierarchy: " + #function)
    }
    
    override func viewWillLayoutSubviews() {
        print("ViewController's view is about to layout its subviews: " + #function)
    }
    
    override func viewDidLayoutSubviews() {
        print("ViewController's view has just laid out its subviews: " + #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController's view is about to be removed from a view: " + #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ViewController's view was removed from a view hierechy: " + #function)
    }


}

