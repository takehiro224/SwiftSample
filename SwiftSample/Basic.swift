//
//  Basic.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/05/24.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import Dispatch
import UIKit

class Play {
    func main() {
        //クロージャー@escaping属性
        enqueue { print("add queue") }
        //クロージャー@autoclosure属性
        print( autoclosure(lhs(), rhs()) ) //@autoclosureが無い場合 autoclosure(lhs(), { return rhs() })
        //サブスクリプト
        var progression = Progression(numbers: [1, 2, 3])
        print(progression[1])
        progression[1] = 4
        
        _ = Matrix(rows: [[1,2],[2,3]])
        
        let gameC = GameClosure()
        gameC.start { result in
            print("result is \(result)")
        }
        
        let object1 = CaptureList(id: 1)
        let object2 = CaptureList(id: 2)
        
        let captureClosure = { [weak object1, unowned object2]() -> Void in
            print(object1 ?? 1) //nilになる可能性がある
            print(object2)
        }
        captureClosure()
    }
    
    //クロージャー@escaping属性: 非同期的に実行されるクロージャ
    var queue = [() -> Void]()
    func enqueue(operation: @escaping () -> Void) {
        queue.append(operation)
    }
    //クロージャー@autoclosure属性: クロージャを用いた遅延評価
    func autoclosure(_ lhs: Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
        if lhs {
            return true
        } else {
            let rhs = rhs()
            return rhs
        }
    }
    func lhs() -> Bool {
        return true
    }
    func rhs() -> Bool {
        return false
    }
    //サブスクリプト: 配列や辞書などのコレクションの要素へのアクセスを統一的に表すための文法
    struct Progression {
        var numbers: [Int]
        subscript(index: Int) -> Int {
            get {
                return numbers[index]
            }
            set {
                numbers[index] = newValue
            }
        }
    }
    //サブスクリプト(引数が複数)
    struct Matrix {
        var rows: [[Int]]
        subscript(row: Int, column: Int) -> Int {
            get {
                return rows[row][column]
            }
            set {
                rows[row][column] = newValue
            }
        }
    }
}
//指定イニシャライザ: 主となるイニシャライザ
class Mail2 {
    let from: String
    let to: String
    let title: String
    //指定イニシャライザ
    init(from: String, to: String, title: String) {
        self.from = from
        self.to = to
        self.title = title
    }
    //コンビニエンスイニシャライザ
    convenience init(from: String, to: String) {
        self.init(from: from, to: to, title: "Zzz")
    }
}

//mutating: 値型のインスタンスの変更を宣言するキーワード
protocol SomeProtocol2 {
    mutating func mutatingMethod()
    func method()
}
struct SomeStruct: SomeProtocol2 {
    var number: Int
    mutating func mutatingMethod() {
        number = 1
    }
    func method() {
        print("method")
    }
}

//連想型: プロトコルの準拠時に指定可能な型
protocol AssociationProtocol {
    associatedtype AssociatedTypeName
    //連想型はプロパティやメソッドでも使用可能
    var value: AssociatedTypeName { get }
    func someMethod(value: AssociatedTypeName) -> AssociatedTypeName
}
//AssociatedTypeNameを定義することで要件を満たす
struct AssociatedClass1: AssociationProtocol {
    typealias AssociatedTypeName = Int
    var value: AssociatedTypeName
    func someMethod(value: AssociatedTypeName) -> AssociatedTypeName {
        return 1
    }
}
//Sequenceプロトコル : 要素の列挙のためのプロトコル
struct IntIterator: IteratorProtocol {
    var count = 0
    mutating func next() -> Int? {
        guard count < 10 else {
            return nil
        }
        defer {
            count += 1
        }
        return count
    }
}
struct IntSequence: Sequence {
    func makeIterator() -> IntIterator {
        return IntIterator()
    }
}
//ジェネリクス
func isEqual<T: Equatable>(_ x: T, _ y: T) -> Bool {
    return x == y
}
//デリゲートパターン: あるオブジェクトの処理を別のオブジェクトに代替させるパターン
class TwoPersonGameDelegate: GameDelegate {
    var numberOfPlayers: Int { return 2 }
    func gameDidStart() {
        print("game start")
    }
    func gameDidEnd() {
        print("game end")
    }
}

class Game {
    weak var delegate: GameDelegate? //インスタンス化した際にGameDelegateに準拠したクラスを割り当てる
    
    func start() {
        print("number of players is \(delegate?.numberOfPlayers ?? 1)")
        delegate?.gameDidStart()
        print("playing")
        delegate?.gameDidEnd()
    }
}

protocol GameDelegate: class { //委譲する処理をプロトコルのメソッドとして宣言
    var numberOfPlayers: Int { get }
    func gameDidStart()
    func gameDidEnd()
}

//クロージャパターン:別のオブジェクトへのコールバック時の処理の登録
class GameClosure {
    private var result = 0
    
    func start(completion: (Int) -> Void) {
        print("Playing")
        result = 42
        completion(result)
    }
}

//キャプチャリスト
class CaptureList {
    let id: Int
    init(id: Int) {
        self.id = id
    }
}

//オブザーバパターン: 状態変化を別オブジェクトへ通知する
//(1)通知を受け取るオブジェクトにNotification型の値を引数に持つメソッドを実装する
//(2)NotificationCenterクラスに通知を受け取るオブジェクトを登録する
//(3)NotificationCenterクラスに通知を投稿する
class Poster { //通知を発生させる
    static let notificationName = Notification.Name("SomeNotification")
    func post() {
        NotificationCenter.default.post(name: Poster.notificationName, object: nil)
    }
}
class Observer { //通知を受け取る
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: Poster.notificationName,
                                               object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handleNotification(_ notification: Notification) {
        print("通知を受け取りました")
    }
}

/** 非同期処理 */
//実行中に別の処理を止めない処理のこと
//複数の処理を並列化して処理を行う
//Swiftはスレッドを利用して非同期処理を実現する
//3つの手法
//(1)GCDを用いる: 非同期処理のための低レベルAPI群
//(2)Operation, OperationQueueクラスを用いる
//(3)Threadクラスを用いる

//GCD(Grand Central Dispatch)
let mainQueue = DispatchQueue.main //メインディスパッチキューを取得
let globalQueue = DispatchQueue.global(qos: .userInteractive) //グローバルキューを取得

/** エラー処理 */
//Result<T, Error>型: 列挙型による成功、失敗の表現
enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

enum DatabaseError: Error {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

struct User {
    let id: Int
    let name: String
    let email: String
}

func findUser(byID id: Int) -> Result<User, DatabaseError> {
    let users = [
        User(id: 1,
             name: "Kuroda",
             email: "kuroda@example.com"),
        User(id: 2,
             name: "Sanada",
             email: "sanada@example.com")
    ]
    for user in users {
        if user.id == id {
            return .success(user)
        }
    }
    return .failure(.entryNotFound)
}

func resultTError() {
    let id = 0
    let result = findUser(byID: id)
    switch result {
    case let .success(name):
        print(".success: \(name)")
    case let .failure(error):
        switch error {
        case .entryNotFound:
            print(".failure: .entryNotFound")
        case .duplicatedEntry:
            print(".failure: .duplicatedEntry")
        case .invalidEntry(let reason):
            print(".failure: .invalidEntry(\(reason))")
        }
    }
}

//do-catch: Swift標準のエラー処理機構
struct SomeError: Error {}

func testDoCatch0() {
    do {
        print("Success")
        throw SomeError()
    } catch {
        print("Failure: \(error)")
    }
}

enum SomeError2: Error {
    case error1
    case error2(reason: String)
}

func testDoCatch1() {
    do {
        throw SomeError2.error2(reason: "some error ocer")
    } catch SomeError2.error1 {
        print("error1")
    } catch SomeError2.error2(let reason) {
        print("error2: \(reason)")
    } catch {
        print("Unknown error:\(error)")
    }
}

//throwsキーワード: エラーを発生させる可能性のある処理定義
enum OperationError: Error {
    case overCapacity
}

func triple(of int: Int) throws -> Int {
    guard int <= Int.max / 3 else {
        throw OperationError.overCapacity
    }
    return int * 3
}

//throwsキーワード(イニシャライザでの使用)
enum AgeError: Error {
    case outRange
}

struct TeenAger {
    let age: Int
    init(age: Int) throws {
        guard case 13 ... 19 = age else {
            throw AgeError.outRange
        }
        self.age = age
    }
}

//rethrowsキーワード: 引数のクロージャが発生させるエラーを呼び出し元への伝播
func rethrowingFunction(_ throwwingClosure: () throws -> Void) rethrows {
    try throwwingClosure()
}
func testRethrows() {
    do {
        try rethrowingFunction {
            throw SomeError()
        }
    } catch {
        //引数のクロージャが発生させるエラーを関数の呼び出し元で処理
        print(error)
    }
}

/** アサーション */
//assert(_: _:)関数: 条件を満たさない場合に終了するアサーション
func format(minute: Int, second: Int) -> String {
    assert(second < 60, "secondは60未満に設定してください")
    return "\(minute)分\(second)秒"
}

//assertionFailure(_:)関数: 必ず終了するアサーション
func printSeason(forMonth month: Int) {
    switch month {
    case 1...2, 12:
        print("")
    case 3...5:
        print("")
    case 6...8:
        print("")
    case 9...11:
        print("")
    default:
        assertionFailure("1から12までで設定してください")
    }
}


class sample {
    
    var targetView: UIView? = nil
    
    func startAnimation(_ sender: Any) {
        //ビューの角を丸める
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        //変更前の値は0
        animation.fromValue = 0
        //変更後の値は20
        animation.toValue = 20
        //アニメーションの時間は1秒
        animation.duration = 1
        //アニメーションをレイヤーに追加する
        targetView?.layer.add(animation, forKey: "cornerRadius")
        //変形後も維持
        targetView?.layer.cornerRadius = 20
    }
    
    let days = 31 //1ヶ月の日数
    let firstDay = 2 //1日目の曜日
    var w = 0 //曜日のための変数
    func cal(days: Int, firstDay: Int) {
        while w < firstDay {
            print(" ", terminator: "")
            w += 1
        }
        var d = 1 //日にちを示す変数
        loop: while true {
            while w < 7 {
                let pad = d < 10 ? " " : ""
                print(pad + " \(d)", terminator: "")
                d += 1
                if d > days { //月末になったら
                    print("") //改行
                    break loop
                }
                w += 1
            }
            print("")
        }
    }
    
    var monthDays = [1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31]
    
    //閏年計算
    func isLeap(year: Int) -> Bool {
        if year % 4 == 0 {
            if year % 100 == 0 {
                if year % 400 == 0 {
                    return true
                }
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    /** 曜日と日数を引数に取り、カレンダーを描画する */
    func printMonth(firstDay: Int, _ days: Int) {
        func daystr(_ d: Int) -> String {
            if d <= 0 { //
                return "    " //空白で埋める4
            } else {
                return (d < 10 ? "   \(d)" : "  \(d)") //xxx1 xx10
            }
        }
        var d: Int = 1 - firstDay //sat => 1 - 6 = -5
        while d <= days { //
            var line = ""
            for _ in 0 ..< 7 {
                line += daystr(d)
                
                d += 1
                if d > days { break } //月末を迎えた場合終了する
            }
            print(line)
        }
    }
    
    func firstDayOfWeek( _ year: Int, _ month: Int) -> Int {
        var year = year
        var month = month
        if month < 3 {
            month += 12
            year -= 1
        }
        let leap = year + year / 4 - year / 100 + year / 400
        return (leap + (13 * month + 8) / 5 + 1) % 7
    }
    
    func showCalendar(year: Int, month: Int) {
        let dayOfWeek = firstDayOfWeek(year, month)
        if isLeap(year: year) {
            monthDays[2]! = 29
        }
        printMonth(firstDay: dayOfWeek, monthDays[month]!)
    }
}

private func mainZ() {
    
    /** 範囲演算子 */
    let range1: CountableRange<Int> = 1 ..< 4
    let range2: Range<Double> = 1.0 ..< 4.0
    let range3: CountableClosedRange<Int> = 1 ... 4
    let range4: ClosedRange<Double> = 1.0 ... 4.0
    
    /** Optional
     1 オプショナルバインディング
     2 ??演算子
     3 オプショナルチェイン
     */
    enum Optional<Wrapped> {
        case none
        case some(Wrapped)
    }
    
    let none: Optional<Int> = Optional<Int>.none
    let some: Optional<Int> = Optional<Int>.some(1)
    let some1 = Optional.some(1)
    let none1: Optional<Int> = Optional.none
    
    var a: Int?
    
    //optional binding
    let op1: Int? = 1
    if let wr1 = op1 {
        print(wr1)
    }
    
    //??演算子
    let optionalInt: Int? = 1
    let int = optionalInt ?? 3
    
    //オプショナルチェイン
    let optionalDouble: Double? = 1.0
    let optionalIsInfinite: Bool?
    if let double = optionalDouble {
        optionalIsInfinite = double.isInfinite
    } else {
        optionalIsInfinite = nil
    }
    
    let optionalDouble1: Double? = 1.0
    let optionalIsInfinite1: Bool? = optionalDouble?.isInfinite
    
    let optionalRange: CountableRange<Int>? = 0 ..< 10
    let containsSeven = optionalRange?.contains(7)
    
    //ImplicitlyUnwrappedOptional<Wrapped>
    var b: ImplicitlyUnwrappedOptional<Int>!
    b = nil
    b = ImplicitlyUnwrappedOptional(1)
    b = 1
    
    /** tuple */
    var tuple: (Int, String) = (1, "a")
    //インデックスでのアクセス
    let tupleInt = tuple.0
    let tupleString = tuple.1
    //要素名によるアクセス
    var tuple2 = (int: 1, string: "a")
    let tupleInt2 = tuple2.int
    let tupleString2 = tuple2.string
    //代入によるアクセス
    let tupleInt3: Int
    let tupleString3: String
    (tupleInt3, tupleString3) = (1, "a")
    let (tupleInt4, tupleString4) = (1, "a")
    
    /** キャスト */
    let cast: Any = 1
    let isInt: Bool = cast is Int
    let any = "abc" as Any //アップキャスト
    let any1: Any = "abc" //暗黙的なアップキャスト
    let downAny = 1 as Any
    let downInt = downAny as? Int //Int?
    let downString = downAny as? String //nil
    
    let ifletA: String? = "a"
    let ifletB: String? = "b"
    if let a = ifletA, let b = ifletB {
        print("値あり")
    }
    
    let ifletC: Any = 1
    if let c = ifletC as? Int {
        print("値あり")
    }
    
    //if-case パターンマッチによる分岐
    let ifcase = 9
    if case 1 ... 10 = ifcase {
        print("1以上10以下")
    }
    
    /** guard文 条件不成立時に早期退出する分岐 */
    let guardValue = -1
    guard guardValue >= 0 else {
        print("0未満")
        return
    }
    print(guardValue) //0以上であることが保証されている
    
    //guardでオプショナルバインディング
    func someFunction() {
        let a: Any = 1
        guard let guardInt = a as? Int else {
            return
        }
        print(guardInt)
    }
    
    func addByGuard(_ optionalA: Int?, _ optionalB: Int?) -> Int? {
        guard let a = optionalA else {
            print("a is empty")
            return nil
        }
        guard let b = optionalB else {
            print("b is empty")
            return nil
        }
        return a + b
    }
    print(addByGuard(1, 2)!)
    
    /** switch 複数のパターンマッチによる分岐 */
    let switchValue = 1
    
    switch switchValue {
    case Int.min ..< 0:
        print("aは負の値")
    case 0 ..< Int.max:
        print("aは正の値")
    default:
        print("aは0です")
    }
    
    //whereキーワード ケースにマッチする条件の追加
    let switchWhereO: Int? = 1
    switch switchWhereO {
    case .some(let a) where a > 10:
        print("10よりも大きい値\(a)が存在します")
    default:
        print("値が存在しない")
    }
    
    /** 繰り返し */
    //for 要素の列挙
    //for-in 全ての要素の列挙
    let forDic = ["a": 1, "b": 2]
    for (key, value) in forDic {
        print("key:\(key), value\(value)")
    }
    
    //for-case-in パターンマッチによって絞りこまれた要素の列挙
    let forCaseInArray = [1, 2, 3, 4]
    for case 2 ... 3 in forCaseInArray {
        print("2以上3以下の値")
    }
    
    /* while 継続条件による繰り返し */
    /**
     while 条件式 {
     条件が成立する間繰り返し実行する
     }
     */
    var whileInt = 1
    while whileInt < 3 {
        print(whileInt)
        whileInt += 1
    }
    
    //repeat-while 初回実行を保証する繰り返し処理
    /**
     repeat {
     1回は必ず実行され、それ以降は条件式が成立する限り繰り返し実行される処理
     } while 条件式
     */
    var repeatInt = 1
    repeat {
        print(repeatInt)
        repeatInt += 1
    } while repeatInt < 1
    
    /** プログラムの制御を移す文
     1 fallthrough swith文の次のケースへの制御移動
     2 break switch文のケースの実行や繰り返しの中断
     3 continue 繰り返しの継続
     4 return
     5 throw
     */
    
    /** 遅延実行
     defer {
     deferが記述されているスコープの退出時に実行される文
     }
     */
    var deferCount = 0
    func deferFunction() -> Int {
        defer {
            deferCount += 1
        }
        return deferCount
    }
    someFunction() //0
    print(deferCount) //1
    
    /** パターンマッチ
     1 式パターン
     2 バリューバインディングパターン
     3 列挙型ケースパターン
     4 型キャスティングパターン
     */
    
    //バリューバインディング
    let valueBinding = 3
    switch valueBinding {
    case let machedValue:
        print(machedValue)
    }
    
    //列挙型ケースパターン
    enum Hemispere {
        case northern
        case southern
    }
    let hemi = Hemispere.northern
    switch hemi {
    case .northern:
        print("northern")
    case .southern:
        print("southern")
    }
    
    //連想値のパターンマッチ
    enum Color {
        case rgb(Int, Int, Int)
        case cmyk(Int, Int, Int, Int)
    }
    let color = Color.rgb(255, 255, 255)
    switch color {
    case .rgb(let r, let g, let b):
        print("rgb: \(r),\(g),\(b)")
    case .cmyk(let c, let m, let y, let k):
        print("cmyk: \(c),\(m),\(y),\(k)")
    }
    
    //型キャスティングパターン(is)
    let isAny: Any = 1
    switch isAny {
    case is String:
        print("String")
    case is Int:
        print("Int")
    default:
        print("another")
    }
    
    //型キャスティングパターン(as)
    let asAny: Any = 1
    switch asAny {
    case let string as String:
        print("match: \(string)")
    case let int as Int:
        print("match: \(int)")
    default:
        print("another")
    }
    
    var arr = [5, 3, 4, 2, 1]
    
    //関数
    func compare(a: Int, b: Int) -> Bool {
        return a < b
    }
    arr.sorted(by: compare)
    
    //クロージャ
    arr.sorted(by: {
        (a: Int, b: Int) -> Bool in
        return a < b
    })
    
    //(型推測)クロージャ
    arr.sorted(by: {
        a, b in
        return a < b
    })
    
    //(パラメーター省略)クロージャ
    arr.sorted(by: {
        return $0 < $1
    })
    
    //(return省略)クロージャ
    arr.sorted(by: {
        $0 < $1
    })
    
    //演算子のみ
    arr.sorted(by: <)
    
    //トレイリングクロージャ
    arr.sorted(){$0 < $1}
    
    //通常表記
    arr.map({
        (number: Int) -> String in
        return "(\(number))"
    })
    
    //トレイリングクロージャ()省略
    arr.map{
        (number: Int) -> String in
        return "\(number)"
    }
    
    //トレイリングクロージャ引数型省略
    arr.map{
        a -> String in
        return "\(a)"
    }
    
    //トレイリングクロージャ戻り値型省略
    arr.map{
        a in
        return "\(a)"
    }
    
    //トレイリングクロージャ引数省略
    arr.map{
        return "\($0)"
    }
    
    let strings = arr.map{ return "\($0)" }
    
    //値のキャプチャ
    func makeProgressBar(mark: String) -> () -> String {
        var bar = ""
        func progressBar() -> String {
            bar += mark
            return bar
        }
        return progressBar
    }
    
    let plusProgressBar = makeProgressBar(mark: "+")
    print(plusProgressBar()) //+
    print(plusProgressBar()) //++
    print(plusProgressBar()) //+++
    
    let c1 = Counter()
    print(c1.count)
    print(c1.increment())
    
    print(Foo.stored)
    print(Foo.computed)
    print(Foo.overrideableComputed)
    
    let g = Guiter()
    g.rangeOfOctaves = 4
    print(g.numberOfStrings)
    
    let a1 = Article()
    a1.category //default
    let a2 = Article(category: "hoge")
    a2.category //hoge
    
    
    //失敗可能イニシャライザ init?
    let urlOptional = URL(string: "")
    if let url = urlOptional {
        //成功
    } else {
        //失敗
    }
    
    let itemCode = ItemCode.ISBN("123456789")
    
    Point2.offsetX = 100
    Point2.offsetY = -100
    let p = Point2(x: 150, y: 150)
    print(p.actualX)
    print(p.actualY)
    
    var colorStruct = Colors(red: 255, green: 0, blue: 0)
    let color2 = colorStruct
    colorStruct.red = 0
    print(color2.red)
    
}

//ストアドプロパティ
class Counter {
    var count = 0
    func increment() -> Int {
        count += 1
        return count
    }
}

//コンピューテッドプロパティ
class Rectangle {
    var origin = (x: 0, y: 0)
    var size = (width: 0, height: 0)
    var center: (x: Int, y: Int) {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return (x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.width / 2)
        }
    }
}

//読取専用コンピューテッドプロパティ
class RectAngle2 {
    var origin = (x: 0, y: 0)
    var size = (height: 0, width: 0)
    var center: (x: Int, y: Int) {
        let centerX = origin.x + (size.width / 2)
        let centerY = origin.y + (size.height / 2)
        return (x: centerX, y: centerY)
    }
}

//タイププロパティ: インスタンスを生成せずに使用可能なプロパティ
class Foo {
    static var stored: Int = 100
    static var computed: Int {
        return 200
    }
    class var overrideableComputed: Int {
        return 300
    }
}

//プロパティオブザーバ: プロパティに値が設定されるたびに呼び出される関数
class Wallet {
    var money: Int = 0 {
        willSet {
            print("財布の中身が\(newValue)円になりました。")
        }
        didSet {
            if oldValue < money {
                print("\(money - oldValue)円増えました。")
            } else {
                print("\(oldValue - money)円減りました。")
            }
        }
    }
}

//メソッド: クラスに関連付けられた関数
//インスタンスメソッド: クラスのインスタンスに属するメソッド
class Counter2 {
    var count = 0
    
    func increment () -> Int {
        count += 1
        return count
    }
    
    func increment(by amount: Int) -> Int {
        count += amount
        return count
    }
    
    func increment(by amount: Int, times: Int) -> Int {
        count += amount * times
        return count
    }
}

//タイプメソッド: インスタンスを作成することなく実行が可能なメソッド
class Foo2 {
    static func typeMethod() {
        //タイプメソッドの処理
    }
    class func overrideableTypeMethod() {
        //オーバーライド可能なタイプメソッド
    }
}

//継承
class Instrument {
    var rangeOfOctaves = 1
    var description: String {
        return "\(rangeOfOctaves)オクターブの音が出ます。"
    }
    func play() {}
}

class Guiter: Instrument {
    var numberOfStrings = 6
    override func play() {
        print("hogehoge")
    }
    override var description: String {
        return "\(numberOfStrings)" + super.description
    }
}

//初期化: インスタンス生成時にインスタンスを使用可能にするための処理のこと
class Distance {
    var distanceInKm: Double
    var km: Double? //オプショナルは初期化の省略可能
    init() {
        distanceInKm = 0 //プロパティの初期化
    }
}

//定数プロパティの初期化
class Article {
    var title: String?
    let category: String
    convenience init() {
        self.init(category: "default")
    }
    init(category: String) {
        self.category = category
    }
}

//複数のイニシャライザ
class Distance2 {
    var distanceInKm: Double
    
    init() {
        distanceInKm = 0
    }
    init(fromMeter meter: Double) {
        distanceInKm = meter / 1000
    }
    init(frommile: Double) {
        distanceInKm = frommile * 1.609344
    }
}

//指定イニシャライザ: 全てのストアドプロパティを初期化(サブクラスの場合親クラスのイニシャライザを実行する)
//コンビニエンスイニシャライザ: 必須ではない。
//サブクラスのイニシャライザ例
class Instrument2 {
    var rangeOfOctaves = 0
    var description: String {
        return "\(rangeOfOctaves)オクターブの音が出ます。"
    }
    func play() {}
}

class Trumpet: Instrument2 {
    var lowestNote: String
    
    override init() {
        lowestNote = "C4" //サブクラス初期化
        super.init() //スーパークラスのイニシャライザ
        rangeOfOctaves = 1 //スーパークラス値変更
    }
}

//関数、クロージャを使用した初期化
class Dice {
    var spot: UInt32 = {
        return arc4random_uniform(6)
    }()
}

/** プロトコル
 クラスのメソッドやプロパティの設計のみを定義する機能
 */
protocol SomeProtocol {
    var someProperty: Int { get set }
    var someReadOnlyProperty: Int { get }
    static func someTypeMethod()
    func someInstanceMethod(str: String) -> String
}

//プロトコルの採用
class SomeClass: SomeProtocol {
    var someProperty = 10
    var someReadOnlyProperty = 30
    class func someTypeMethod() {
        print("type method")
    }
    func someInstanceMethod(str: String) -> String {
        return "instance method"
    }
}

/** mutating
 自身の値の変更を宣言するキーワード
 mutatingが指定されたメソッドの呼び出しは再代入として扱われる
 */

//structをletに代入する -> インスタンスが保持する値の変更を防ぎたい場合に使用する

/** 値型と参照型の使い分け
 値型は自身の変更情報は共有されない。-> 値型は1度代入されたら明示的に再代入されない限りは不変
 
 */

/** 構造体
 値型のデータ構造
 データを構造化して取り扱うことを目的とした機能
 「継承」「型キャスト」「デイニシャライザ」は使用できない
 */
struct Point {
    var x = 0
    var y = 0
}
struct Size {
    var width = 0
    var height = 0
    func area() -> Int {
        return width * height
    }
}
struct Rectangle3 {
    var origin = Point()
    var size = Size()
}

struct Articl {
    let id: Int
    let title: String
    let body: String
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
    func printBody() {
        print(body)
    }
}

struct someStruct {
    var id: Int
    init(id: Int) {
        self.id = id
    }
    mutating func someMethod() {
        id = 4
    }
}

struct Colors {
    var red: Int
    var green: Int
    var blue: Int
}

extension Int {
    mutating func increment() {
        self += 1
    }
}

//メンバーワイズイニシャライ: デフォルトで用意されるイニシャライザ
//init(id: Int, title: String, body: String)

/** クラス
 参照型のデータ構造
 */
//基本
class DataClass {
    let id: Int
    let name: String
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    func printName() {
        print(name)
    }
}
//継承
class UserSuper {
    let id: Int
    var message: String {
        return "Hoge"
    }
    init(id: Int) {
        self.id = id
    }
}
class UserSub: UserSuper {
    let name: String
    init(id: Int, name: String) {
        self.name = name
        super.init(id: id)
    }
}

/**
 継承: 型の構成要素の引き継ぎ
 オーバーライド: 型の構成要素の再定義
 final: 継承とオーバーライドの禁止
 クラスプロパティ: クラス自身に紐づくプロパティ.インスタンスではなくクラスに紐付き、インスタンスに依存しない値を扱う場合に有効
 クラスメソッド: クラス自身に紐づくメソッド.インスタンスに依存しない処理を実装する場合に利用する
 */

/**
 「イニシャライザ」
 指定イニシャライザ: 主となるイニシャライザ
 コンビニエンスイニシャライザ: 指定イニシャライザをラップするイニシャライザ
 デフォルトイニシャライザ: プロパティの初期化が不要な場合に定義されるイニシャライザ
 */

//コンビニエンスイニシャライザ
class Mail {
    let from: String
    let to: String
    let title: String
    init(from: String, to: String, title: String) {
        self.from = from
        self.to = to
        self.title = title
    }
    convenience init(from: String, to: String) {
        self.init(from: from, to: to, title: "Hello \(to).")
    }
}

/** 列挙型
 一連の値とそれを表す名前をまとめたもの
 */

enum Weekday {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    init?(japaneseName: String) {
        switch japaneseName {
        case "": self = .sunday
        case "": self = .monday
        case "": self = .tuesday
        case "": self = .wednesday
        case "": self = .thursday
        case "": self = .friday
        case "": self = .saturday
        default: return nil
        }
    }
    //コンピューテッドプロパティ
    var name: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "月"
        case .tuesday: return "火"
        case .wednesday: return "水"
        case .thursday: return "木"
        case .friday: return "金"
        case .saturday: return "土"
        }
    }
}

//ローバリュー



enum Suit {
    case Spades
    case Hearts
    case Diamonds
    case Clubs
    func color() -> String {
        switch self {
        case .Spades, .Clubs:
            return "black"
        case .Hearts, .Diamonds:
            return "red"
        }
    }
}

//列挙型の型の指定
enum Suit2: Int {
    case Spades = 0
    case Hearts = 1
    case Diamonds = 2
    case Clubs = 3
}
//アソシエイト値: メンバごとに異なる型を持たせることができる
enum ItemCode {
    case JAN(String)
    case ISBN(String)
    case ItemId(Int)
}

//ストアドタイププロパティ: クラスはストアドタイププロパティの定義は不可
struct Point2 {
    static var offsetX = 0
    static var offsetY = 0
    var x = 0
    var y = 0
    var actualX: Int {
        return x + Point2.offsetX
        
    }
    var actualY: Int {
        return y + Point2.offsetY
    }
}



/**
 class = 参照型
 struct, enum = 値型
 */


//タイプメソッド: 構造体と列挙型ではタイプメソッドの使用にはstaticの使用可能で、classは使用できない
struct ProgressBar {
    static var progress = 0
    static func gain() {
        ProgressBar.progress += 1
    }
}

/** メソッド内でのプロパティ更新
 構造体、列挙型のメソッド内部からプロパティの値を変更することはできない
 変更したい場合はメソッド定義の先頭に「mutating」をつける
 */
struct Point3 {
    var x = 0, y = 0
}
struct Size2 {
    var width = 0, height = 0
    func area() -> Int {
        return width * height
    }
}
struct Rectangle4 {
    var origin = Point3()
    var size = Size2()
    mutating func moveBy(x: Int, y: Int) {
        origin.x += x
        origin.y += y
    }
}

//selfを使用した自身の更新
struct Point4 {
    var x = 0, y = 0
    mutating func reset() {
        self = Point4()
    }
}

/**
 クラスのメモリ管理
 ARC(Automatic Reference Counting)
 クラスのインスタンスのために確保したメモリ領域を解放する
 でイニシャライザ: インスタンスの終了処理
 */




