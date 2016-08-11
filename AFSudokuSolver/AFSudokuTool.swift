//
//  AFSudokuTool.swift
//  AFSudokuSolver
//
//  Created by Afry on 16/1/31.
//  Copyright © 2016年 AfryMask. All rights reserved.
//

import UIKit


struct ItemInfo {
    //原始值
    var baseValue:Int = 0
    
    
    //可用值
    var allowValues:[Int] = [0]
    
    //当前选中值的index
    var currentIndex = 0
    
    //位置
    var row:Int = 0
    var col:Int = 0
    
}


class AFSudokuTool: NSObject {
    
    var arr:[[Int]] = {
        let ar1:[Int] = [0,0,0,0,0,0,0,0,0]
        var ar2:[[Int]] = []
        for i in 1...9{
            ar2.append(ar1)
        }
        
        return ar2
    }()
    lazy var infoArr = [ItemInfo]()
    

    
    var result:((tempArr:[[Int]]) -> ())?
    
    
    
    var resultCount:Int = 0

    
    var colArr:[[Int]] = [[Int]]()
    
    func testValue(tempArr:[[Int]], value:Int, row:Int, col:Int) -> Bool{
        
        if value == 0 {return true}
        
        //1.
        if tempArr[row].contains(value) {return false}
        //2.
        for i in 0...8 {
            if (tempArr[i][col] == value) {return false}
        }
        //3.
        let boxRow = row/3
        let boxCol = col/3
        for i in 0...2 {
            for j in 0...2 {
                if (tempArr[boxRow*3+i][boxCol*3+j] == value) {return false}
            }
        }
        return true
        
    }
    
    
    func solve() {
        
//        self.arr = [
//            [8,0,0,0,0,0,0,0,0],
//            [0,0,3,6,0,0,0,0,0],
//            [0,7,0,0,9,0,2,0,0],
//            [0,5,0,0,0,7,0,0,0],
//            [0,0,0,0,4,5,7,0,0],
//            [0,0,0,1,0,0,0,3,0],
//            [0,0,1,0,0,0,0,6,8],
//            [0,0,8,5,0,0,0,1,0],
//            [0,9,0,0,0,0,4,0,0]
//        
//        ]

//        self.arr = [
//            [9,8,0,7,0,0,6,0,0],
//            [5,0,0,0,9,0,0,7,0],
//            [0,0,7,0,0,4,0,0,0],
//            [3,0,0,0,0,6,0,0,0],
//            [0,0,8,5,0,0,0,6,0],
//            [0,0,0,0,0,0,3,0,2],
//            [0,1,0,0,0,0,0,0,0],
//            [0,0,5,4,0,0,0,8,0],
//            [0,0,0,0,2,1,9,0,0]
//            
//        ]

//        self.arr = [
//            [0,0,0,0,0,0,0,3,9],
//            [0,0,0,0,0,1,0,0,5],
//            [0,0,3,0,5,0,8,0,0],
//            [0,0,8,0,9,0,0,0,6],
//            [0,7,0,0,0,2,0,0,0],
//            [1,0,0,4,0,0,0,0,0],
//            [0,0,9,0,8,0,0,5,0],
//            [0,2,0,0,0,0,6,0,0],
//            [4,0,0,7,0,0,0,0,0]
//            
//        ]

        self.arr = [
            [1,2,0,4,0,0,3,0,0],
            [3,0,0,0,1,0,0,5,0],
            [0,0,6,0,0,0,1,0,0],
            [7,0,0,0,9,0,0,0,0],
            [0,4,0,6,0,3,0,0,0],
            [0,0,3,0,0,2,0,0,0],
            [5,0,0,0,8,0,7,0,0],
            [0,0,7,0,0,0,0,0,5],
            [0,0,0,0,0,0,0,9,8],
            
        ]
        
        
        
        self.infoArr = [ItemInfo]()
        for i in 0...8 {
            for j in 0...8 {
                var infoTemp = ItemInfo()
                infoTemp.baseValue = self.arr[i][j]
                if self.arr[i][j] == 0 {
                    for k in 1...9 {
                        if self.testValue(self.arr, value:k, row: i, col: j) {
                            infoTemp.allowValues.append(k)
                        }
                    }
                }
                
                infoTemp.row = i
                infoTemp.col = j
                
                self.infoArr.append(infoTemp)
                
            }
            
        }
        
        
        
        operationSolver(self.arr, solverInfoArr: self.infoArr, info: "顺序")
        
        
        operationSolver(self.arr, solverInfoArr: self.infoArr.reverse(), info: "倒序")
        
        self.infoArr.sortInPlace {$0.allowValues.count < $1.allowValues.count}
        operationSolver(self.arr, solverInfoArr: self.infoArr, info: "拟人顺序")
        
//        self.infoArr.sortInPlace {$0.allowValues.count > $1.allowValues.count}
//        operationSolver(self.arr, solverInfoArr: self.infoArr, info: "拟人倒序")
        
        self.infoArr.sortInPlace {$0.col > $1.col}
        operationSolver(self.arr, solverInfoArr: self.infoArr, info: "列顺序")
        
        self.infoArr.sortInPlace {$0.col < $1.col}
        operationSolver(self.arr, solverInfoArr: self.infoArr, info: "列倒序")
        
        
    }
    
    
    func operationSolver(var solverArr:[[Int]], var solverInfoArr:[ItemInfo], info:String){
        NSOperationQueue().addOperationWithBlock { () -> Void in
            
            var valueIndex:Int = 0
            var difficuty:CGFloat = 0.0
            var aim:Int = 1
            
            while(true){
                //                print(solveArr)
                if solverInfoArr[valueIndex].baseValue == 0 {
                    //                    print(valueIndex)
                    solverInfoArr[valueIndex].currentIndex += 1
                    
                    
                    if solverInfoArr[valueIndex].currentIndex >= solverInfoArr[valueIndex].allowValues.count {
                        solverInfoArr[valueIndex].currentIndex = 0
                        
                        solverArr[solverInfoArr[valueIndex].row][solverInfoArr[valueIndex].col] = 0
                        
                        difficuty += 1
                        aim = -1
                        
                        
                    }else if self.testValue(solverArr, value:solverInfoArr[valueIndex].allowValues[solverInfoArr[valueIndex].currentIndex], row: solverInfoArr[valueIndex].row, col: solverInfoArr[valueIndex].col){
                        
                        
                        solverArr[solverInfoArr[valueIndex].row][solverInfoArr[valueIndex].col] =
                            solverInfoArr[valueIndex].allowValues[solverInfoArr[valueIndex].currentIndex]
                        
                        aim = 1
                        
                        
                    }else{
                        aim = 0
                    }
                    
                }
                valueIndex += aim
                
                if valueIndex >= 81 {
                    self.printResult(solverArr, difficuty: difficuty, info: info)
                    aim = -1
                    valueIndex += aim
                }
                
                
                if valueIndex == -1 {
                    self.printStop(difficuty, info: info)
                    break
                }
                
                
            }
            
            
        }
    
    }
    func printResult(solverArr:[[Int]], difficuty:CGFloat, info:String){
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            print("----------------------Result：\(info)----------------------")
            print("Difficuty:\(difficuty/10000)")
            self.result!(tempArr:solverArr)
            print(solverArr)
        })
    }
    func printStop(difficuty:CGFloat, info:String){
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            print("----------------------Stop：\(info)----------------------")
            print("Difficuty:\(difficuty/10000)")
        })
    
    }
    
}
