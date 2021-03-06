//
//  MyPointsViewController.swift
//  Night Life
//
//  Created by admin on 02.03.16.
//  Copyright © 2016 com.NightLife. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SWRevealViewController
import QuartzCore

class MyPointsViewController: UIViewController, UITextFieldDelegate {
    
  private let kScrollUP:Int = 170
    
  @IBOutlet weak var scrollView: UIScrollView!
    
  @IBOutlet weak var pointsTopLbl: UILabel!
  @IBOutlet weak var pointsBottomLbl: UILabel!
  
  @IBOutlet weak var pointsMinusBtn: UIButton!
  @IBOutlet weak var pointsPlusBtn: UIButton!
  @IBOutlet weak var submitBtn: UIButton!
    
  @IBAction func minusBtnClick(sender: AnyObject) {
        
      self.viewModel.decreaseAmountOfPointsToSubstract()
  }
    
  @IBAction func plusBtnClick(sender: AnyObject) {
        
      self.viewModel.increaseAmountOfPointsToSubstract()
  }
  @IBAction func submitBtnClick(sender: AnyObject) {
  
    self.viewModel.removePoints()
  }
  

  private let viewModel = MyPointsViewModel()
  
  private let bag = DisposeBag()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.showInfoMessage(withTitle: "alert", "PLEASE REDEEM THE POINTS AT A PARTNER VENUE") {
        
        
    }
    
    viewModel.amountOfPointsToSubstract.asObservable()
        .map{ "\($0)" }
        .bindTo(pointsBottomLbl.rx_text)
        .addDisposableTo(bag)
    
    viewModel.enableMinusButtonObservable
        .bindTo(pointsMinusBtn.rx_enabled)
        .addDisposableTo(bag)
    
    viewModel.enableSubmitButtonObservable
        .bindTo(submitBtn.rx_enabled)
        .addDisposableTo(bag)
    
    viewModel.generalAmountOfPoints.asObservable()
      .filter{ $0 != nil }
      .map{"\($0!.points)"}
      .bindTo(pointsTopLbl.rx_text)
      .addDisposableTo(bag)
    
    ///error presenting
    viewModel.errorMessage.asDriver()
        .filter { $0 != nil }.map { $0! }
        .driveNext { [unowned self] message in
            self.showInfoMessage(withTitle: "Error", message)
        }
        .addDisposableTo(bag)
  }
}
