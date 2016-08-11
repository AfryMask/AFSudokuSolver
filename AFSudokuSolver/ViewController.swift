//
//  ViewController.swift
//  AFSudokuSolver
//
//  Created by Afry on 16/1/30.
//  Copyright © 2016年 AfryMask. All rights reserved.
//


import UIKit
let ScreenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(CGRectMake(0, 20, ScreenWidth, ScreenWidth))
    }
    
    
    
    
    func setupUI(frame:CGRect){
        // 背景
        let backView = UIView(frame: frame)
        backView.backgroundColor = UIColor.blueColor()
        view.addSubview(backView)
        
        // 设置box
        let itemSpace:CGFloat = 3.0
        let boxSpace:CGFloat = 6.0
        let itemWidth = (ScreenWidth-itemSpace*10.0-boxSpace*2)/9.0
        for i in 11..<100 {
            if i%10 == 0 {continue}
            
            let col = CGFloat(i%10)
            let row = CGFloat(i/10)
            
            var boxX = itemSpace*col+itemWidth*(col-1)
            var boxY = itemSpace*row+itemWidth*(row-1)
            
            if col>3 {boxX += boxSpace}
            if col>6 {boxX += boxSpace}
            if row>3 {boxY += boxSpace}
            if row>6 {boxY += boxSpace}
            
            let boxView = UIButton(frame: CGRectMake(boxX, boxY, itemWidth, itemWidth))
            
            boxView.backgroundColor = UIColor.redColor()
            backView.addSubview(boxView)
            boxView.tag = i
            boxView.addTarget(self, action: "boxClick:", forControlEvents: .TouchUpInside)
            
            items.append(boxView)
            
        }
        
        // 设置bar
        let barSpace:CGFloat = 3.0
        let barWidth = (ScreenWidth-11*barSpace)/10
        
        for i in 0..<10 {
            
            let bar = UIButton(frame: CGRectMake(barSpace*CGFloat((i+1))+barWidth*CGFloat(i), CGRectGetMaxY(backView.frame)+barSpace, barWidth, barWidth))
            bar.setTitle("\(i)", forState: .Normal)
            bar.backgroundColor = UIColor.cyanColor()
            bar.addTarget(self, action: "barClick:", forControlEvents: .TouchUpInside)
            view.addSubview(bar)
        
        }
        
        // 开始按钮
        runBtn = UIButton(frame: CGRectMake(0, CGRectGetMaxY(backView.frame)+40, ScreenWidth, 30))
        runBtn!.setTitle("RUN", forState: .Normal)
        runBtn!.backgroundColor = UIColor.redColor()
        runBtn!.addTarget(self, action: "runClick:", forControlEvents: .TouchUpInside)
        view.addSubview(runBtn!)
        
        tool.result = { (tempArr) -> () in
            var k = 0
            for i in 0...8 {
                for j in 0...8 {
                    
                    self.items[k].setTitle("\(tempArr[i][j])", forState: .Normal)
                    
                    
                    k++
                    
                }
                
            }
            self.view.setNeedsDisplay()

            
        }
        
    }
    func runClick(sender:UIButton){
        
        runBtn?.backgroundColor = UIColor.blackColor()
        runBtn?.enabled = false
        

            var k = 0
            for _ in 1...81 {

                    
                if self.items[k].titleLabel!.text != nil {
                    
                    self.items[k].backgroundColor = UIColor.blackColor()
                }
                
                k++
                
            }
        view.setNeedsDisplay()
        
        tool.solve()
    }
    
    func barClick(sender:UIButton){
        
        guard let _ = selectedButton else{
            return
        }
        

        var str:NSString = sender.titleLabel!.text!
        
        // 如果可以设置值
        if tool.testValue(self.tool.arr, value:Int(str.intValue), row: selectedButton!.tag/10-1, col: selectedButton!.tag%10-1) {
            
            self.tool.arr[selectedButton!.tag/10-1][selectedButton!.tag%10-1] = Int(str.intValue)
            
            
            
            str = str == "0" ? "" : str
            selectedButton!.setTitle(str as String, forState: .Normal)
            
            selectedButton!.backgroundColor = UIColor.redColor()
            selectedButton = nil
        }
    }
    
    func boxClick(sender:UIButton){

        
        selectedButton?.backgroundColor = UIColor.redColor()
        
        
        sender.backgroundColor = UIColor.yellowColor()
        selectedButton = sender

        
    }
    
    
    var items:[UIButton] = [UIButton]()
    var selectedButton:UIButton?
    let tool = AFSudokuTool()
    
    var runBtn:UIButton?

}

