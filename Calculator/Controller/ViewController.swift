//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    //privateにすることでこのクラスの中カッコ内で使えるようにする
    private var isFinishedTypingNumber: Bool = true
    
    
    
    
    //privateにすることでこのクラスの中カッコ内で使えるようにする
    private var displayValue : Double {
        
        get {
            //まずはディスプレイにある数字をDoubleで取得する
            //Doubleに変換できなかったらエラーを出す
            guard let text = displayLabel.text, let number = Double(text) else {
                fatalError("Cannot convert display label text to a Double.")
            }
            //成功すればその数値をdisplayValueの値として返す
            return number
        }
        //displayValueが更新された際は、瞬間を正確に把握し、更新された値をセットする
        set {
            //更新された値（Double）を文字列に変換しセット
            displayLabel.text = String(newValue)
        }
    }
    
    //グローバル変数にしないと他のクラスがインスタンスにアクセスし、いじることができなくなるのでprivateにする。
    //プロパティのイニシャライザはselfが実行可能になる前に実行されているので、プロパティのイニシャライザ内でdisplayValueを使用することはできない。
    //グローバル変数なのでviewDidLoadが呼ばれる前にも起こり、CalculatorLogicを指揮下しようとしてる時点でdisplayValueがにnilではないことを確認できる。
    //画面の初期化からviewDidLoadの呼び出し、すべての準備作業にかかる時間によって、displayValueがにnilになったりならなかったりすることがあるので、displayValueはここでは使えないということになる。
    //calcButtonPressedのIB Actionをトリガーしたボタンの内部に数字（タイトル）がある場合、
    //displayValueの数値が渡されたCalculatorLogicクラスの新しいインスタンスであるcalculatorという定数を作ることで
    //CalculatorLogicオブジェクトのnumberプロパティがここで渡した値で初期化
    private var calculator = CalculatorLogic()
    
    
    
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        isFinishedTypingNumber = true
        calculator.setNumber(displayValue)
        
        //計算ボタンが押されたら再度新たに数字を入力し始めることができるようにし、計算
        //非nil値を得たときだけdisplayValueを更新するようにすれば
        //そしてもしユーザーが誤って＝をタップしてもその前に数値や操作がない場合は、アプリはクラッシュすることなく、コードはそれを無視することになる
        guard let calcMethod = sender.currentTitle, let result = calculator.calculate(symbol: calcMethod) else { return }
        displayValue = result
    }
    
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        //現在押されている数字を取得する
        guard let numValue = sender.currentTitle else { return }
        
        //一つの数字を入力完了（true）時は
        if isFinishedTypingNumber {
            
            //現在押されている数字をディスプレイに表示し
            displayLabel.text = numValue
            
            //一つの数の入力完了が解除し切り替えられる
            isFinishedTypingNumber = false
            
        } else {
            //現在押されている数字が小数点以下の時
            if numValue == "." {
                
                //変換されたDoubleを四捨五入し切り捨ててfloor整数に変換し、切り捨てないバージョンと等しいかを比較する）
                let isInt = floor(displayValue) == displayValue
                //比較し、ディスプレイに表示された数字が整数でない場合（isIntがfalse、つまり!Intの場合ということ）は
                if !isInt {
                    //強制的に関数をリターンさせ現在押されている数字（numValue、つまりここでは「．」）を押せないようにする
                    return
                }
            }
            //一つの数字を入力未完了（false）時はその値をディスプレイしていくに追加し蓄積していく
            guard let currentText = displayLabel.text else { return }
            displayLabel.text = currentText + numValue
        }
    }
    
}


