//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by 内田麻美 on 2023/01/30.
//  Copyright © 2023 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    
    
    
    
    //中間計算を行うためにprivateをつけてデータ型を指定しタプルでグローバル変数を作成する。
    //他の人が誤って変更したり修正試合しないように守らなければならない。
    //CalculatorLogic構造体の初期化時にこのタプルの値を持っていないので、calculatorLogic作成時にnilに設定できるようにしなければならないので？をつけてオプショナルにする
    var intermediateCalculation: (n1: Double, calcMethod: String)?
    
    //ユーザーが数字を押している場合もあれば押していない場合もあるのでオプショナルに
    //すべてのクラスからアクセス可能になってしまうためアクセスレベルをprivateにする。
    //つまり意図的でなくてもこのプロパティのnumberが変更されたり　nilになったりする可能性が出てきてしまうので阻止する
    private var number: Double?
    
    //「_ number: Double」とすると、ViewController内部で「calculator.setNumber(number: displayValue)」ではなく「calculator.setNumber(displayValue)」とすることができる。
    //この意味は外部パラメータは無しで内部パラメータ名を設定するという意味。
    mutating func setNumber(_ number: Double){
        //[Cannot assign to property: 'self' is immutable]というエラーが出るのは、Structの中のプロパティを変更しようとしているから。
        //なのでメソッドにmutatingをつけている
        self.number = number
    }
    
    //calcMethodをsymbolパラメータとして渡しこの関数内でそのシンボルに対してチェックを行うということ。
    //nilを返せるようにするために、オプショナルのDoubleで返すようになっている。
    //（ノーマルのDoubleで返すことにしてしまうと、nilになることはないのでエラーが出てしまうから）
    mutating func calculate(symbol: String) -> Double? {
        
        //他のどのケースでもキャッチできなかったら何もしないのでnilを返すようにする
        guard let n = number else { return nil }
        
        
        //「+/-」ボタンを押した時ディスプレイに表示している数字が+の時は-にする
        //例えば6を押した後「+/-」ボタンを押すと、6が「var number: Double」に渡されて、
        //「+/-」が「func calculate(symbol: String) -> Double」の関数に渡され、
        //正しければ6に　-1をかけたものをreturnで返すことになる
        switch symbol {
        case "+/-":
            return n * -1
            //「AC」ボタンを押した時ディスプレイに表示している数字を0にする
            //例えば6を押した後「AC」ボタンを押すと、6が「var number: Double」に渡されて、
            //「AC」が「func calculate(symbol: String) -> Double」の関数に渡され、
            //正しければ0をreturnで返すことになる
        case "AC":
            return  0
            //「％」ボタンを押した時ディスプレイに表示している数字を/100する（もしくは　number * 0.01　でも可）
            //例えば6を押した後「%」ボタンを押すと、6が「var number: Double」に渡されて、
            //「%」が「func calculate(symbol: String) -> Double」の関数に渡され、
            //正しければ6に　0.01をかけたものをreturnで返すことになる
        case "%":
            return n * 0.01
            
            //「=」を押した時、全体の計算を行う関数を呼び出し、最初の数値に足す必要がある2番目の数値を渡す。
            //returnを付け関数の出力として返さないと「result of call to 'performTwoNumberCalculation(n2:)' is unused」というエラーが出る
        case "=":
            return performTwoNumberCalculation(n2: n)
            
            //「AC」「*/-」「%」「=」以外が押された時、intermediateCalculationというタプルの中に保存し次の数字が入力されるのを待つ。
            //[Cannot assign to property: 'self' is immutable]というエラーが出るのは、Structの中のプロパティを変更しようとしているから。
            //なのでメソッドにmutatingをつけている
        default:
            intermediateCalculation = (n1: n, calcMethod: symbol)
        }
        return nil
    }
    
    //全体を計算する電卓の内部計算部分.
    //このメソッドをprivateにすることで、他のクラスや構造体が誤ってこのメソッドを呼び出すことを防ぐ
    private func performTwoNumberCalculation (n2: Double) -> Double? {
        
        //ユーザーが数値の指定をせずにたまたま等号ボタンを押してしまった場合nilになりクラッシュしてしまったら困るため
        //intermediateCalculationがnilでないことを確認
        //もしintermediateCalculationがnilでなければ再びそこからcalcMethodを取り出しoperationに代入
        guard let n1 = intermediateCalculation?.n1, let operation = intermediateCalculation?.calcMethod else { return nil }
        //switchステートメントで各ケースを設定
        //どのケースにもマッチしなかったら最後のデフォルトのケースを設定
        switch operation {
            
        case "+":
            return n1 + n2
            
        case "-":
            return n1 - n2
        case "×":
            return n1 * n2
        case "÷":
            return n1 / n2
        default:
            fatalError("The operation passed in does not match any of the cases.")
        }
    }
}
