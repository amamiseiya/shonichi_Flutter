//
//  NewDashboardView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2021/1/15.
//  Copyright © 2021 seiya studio. All rights reserved.
//

import SwiftUI
import UIKit
import Flutter

struct NewDashboardView: View {
    var body: some View {
        MyViewController()
        MyUIView()
    }
}

struct MyViewController: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
            let myViewController = FlutterUIViewController()

            return myViewController
        }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
}

struct MyUIView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context){
    }
    
}

class FlutterUIViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Make a button to call the showFlutter function when pressed.
    let button = UIButton(type:UIButton.ButtonType.custom)
    button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
    button.setTitle("Show Flutter!", for: UIControl.State.normal)
    button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
    button.backgroundColor = UIColor.blue
    self.view.addSubview(button)
  }

  @objc func showFlutter() {
    let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
    let flutterViewController =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    present(flutterViewController, animated: true, completion: nil)
  }
}
