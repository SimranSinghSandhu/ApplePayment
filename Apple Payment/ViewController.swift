//
//  ViewController.swift
//  Apple Payment
//
//  Created by Simran Singh Sandhu on 26/08/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController {

    var currencyCode: String?
    var contryCode: String?
    
    lazy var paymentBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 10
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitle("Apple Payment", for: .normal)
        btn.addTarget(self, action: #selector(handleApplePayments), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.simran.applePayment"
        request.countryCode = contryCode ?? "IN"
        request.currencyCode = currencyCode ?? "INR"
        request.merchantCapabilities = .capability3DS
        request.supportedNetworks = [.masterCard, .visa, .quicPay]
        request.paymentSummaryItems = [.init(label: "iMac Pro 16'inch Screen", amount: 210000)]
        return request
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(paymentBtn)
        
        let local = Locale.current
        
        currencyCode = local.currencyCode
        contryCode = local.regionCode
        
        paymentBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        paymentBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        paymentBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        paymentBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func handleApplePayments() {
        print("Payment Started")
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if let paymentController = controller {
            paymentController.delegate = self
            present(paymentController, animated: true, completion: nil)
        }
    }
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
}

