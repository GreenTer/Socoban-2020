//
//  main.swift
//  Socoban
//
//  Created by Baravitski Aliaksandr on 13.12.20.
//

import Foundation

// глобальная переменная, для вывода неправильных действий героя
let WrongTurn = "Wrong way! Please, check your self.."
 
// структура комнаты (уровня) и все что будет связанно с ней (стены, ящики, герой, поле: визуальный контент)
struct Room {
    enum RoomParams: String {
        case Field      = "◽️"
        case Wall       = "🧱"
        case Hero       = "👲"
        case Box        = "📦"
        case CheckPoint = "❗️"
    }
    
    // условия самого поля для игры
    let byWidth: Int  // ширина
    let byHeight: Int // высота
    
    // функция печати самого игрового поля, со всеми условиями (само поле, герой, ящики, стены)
    mutating func printRoom(hero: Hero, box: [Box], checkPoint: [CheckPoint]) {
        // массив с маштабом самого поля ("◽️")
        let fieldArray = Array(repeating: (Array(repeating: RoomParams.Field.rawValue, count: byWidth)), count: byHeight)
        
        for (indexHeight, height) in fieldArray.enumerated() {
            var fieldString = ""
            
            for (indexWidth, width) in height.enumerated() {
                
                // условия вывода на поле, самого героя ("👲")
                if hero.heroByWidth - 1 == indexWidth && hero.heroByHeight - 1 == indexHeight {
                    // условия печати самого героя в комнате ("👲")
                    fieldString += Room.RoomParams.Hero.rawValue
                    
                } else {
                    var infoBox = 0
                    
                    // условия вывода на поле ящика ("📦")
                    for each in box {
                        if each.boxByWidth - 1 == indexWidth && each.boxByHeight - 1 == indexHeight {
                            // условия печати самого ящика в комнате ("📦")
                            fieldString += Room.RoomParams.Box.rawValue
                            infoBox += 1
                        }
                    }
                    
                    // условия вывода на поле чек-поинта ("❗️")
                    for each in checkPoint {
                        if each.checkPointByWidth - 1 == indexWidth && each.checkPointByHeight - 1 == indexHeight {
                            // условия печати чек-поинта в комнате ("❗️")
                            if infoBox == 0 {
                                fieldString += Room.RoomParams.CheckPoint.rawValue
                                infoBox += 1
                            }
                        }
                    }
                    
                    if infoBox == 0 {
                        fieldString += String(width)
                        infoBox = 0
                    }
                }
                
                // проверка на вывод поля
                if fieldString.count == height.count {
                    print(fieldString)
                    fieldString = ""
                }
            }
        }
    }
}
 
 
// класс, ящика (класс, т.к. ящик можно двигать - изменишь в одном месте, поменяется во всех)
class Box {
    // условия самого поля для игры
    var boxByWidth: Int  // ширина
    var boxByHeight: Int // высота
    
    init(boxByWidth: Int, boxByHeight: Int) {
        self.boxByWidth = boxByWidth
        self.boxByHeight = boxByHeight
    }
}
 
 
// структура чек-поинта, именно структура - потому что чек-поинт статичен
struct CheckPoint {
    // условия самого поля для игры
    var checkPointByWidth: Int  // ширина
    var checkPointByHeight: Int // высота
}
 
 
// структура героя, и все что будет связанно с его действиями
struct Hero {
    // передвижения героя (Int мало ли понадобится!)
    enum Move: Int {
        case Up
        case Down
        case Left
        case Right
    }
    // начальные координаты героя, откуда начинает игру
    var heroByWidth: Int  // ширина
    var heroByHeight: Int // высота
    
    // проверка героя, на перемещения по комнате + проверка на передвижения ящика
    mutating func moveHero(move: Move, room: Room, box: [Box]) {
        switch move {
        case .Up:
            // условия перемещения героя "👲"
            if (heroByHeight - 1) > 0 {
                heroByHeight += -1
 
                // условия перемещения ящика "📦"
                for each in box {
                    if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByHeight - 1) > 0 {
                        each.boxByHeight += -1
                        
                    } else if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByHeight - 1) == 0 {
                        heroByHeight += 1
                        print(WrongTurn)
                        break
                    }
                }
 
                print("You move: Up!")
            
            } else {
                print(WrongTurn)
            }
            
        case .Down:
            if (heroByHeight + 1) <= room.byHeight {
                heroByHeight += 1
                
                for each in box {
                    if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByHeight + 1) <= room.byHeight {
                        each.boxByHeight += 1
                        
                    } else if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByHeight + 1) > room.byHeight {
                        heroByHeight += -1
                        print(WrongTurn)
                        break
                    }
                }
                
                print("You move: Down!")
                
            } else {
                print(WrongTurn)
            }
            
        case .Left:
            if (heroByWidth - 1) > 0 && (heroByWidth - 1) <= room.byWidth {
                heroByWidth += -1
                
                for each in box {
                    if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByWidth - 1) > 0 && (each.boxByWidth - 1) <= room.byWidth {
                        each.boxByWidth += -1
                        
                    } else if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByWidth - 1) <= 0 && (each.boxByWidth - 1) <= room.byWidth {
                        heroByWidth += 1
                        print(WrongTurn)
                        break
                    }
                }
                
                print("You move: Left!")
                
            } else {
                print(WrongTurn)
            }
            
        case .Right:
            if (heroByWidth + 1) <= room.byWidth {
                heroByWidth += 1
                
                for each in box {
                    if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByWidth + 1) <= room.byWidth {
                        each.boxByWidth += 1
                        
                    } else if heroByHeight == each.boxByHeight && heroByWidth == each.boxByWidth && (each.boxByWidth + 1) > room.byWidth {
                        heroByWidth += -1
                        print(WrongTurn)
                        break
                    }
                }
                
                print("You move: Right!")
                
            } else {
                print(WrongTurn)
            }
        }
    }
}
 
 
// функция для проверки на выигрыш
var InfoNextLevel = 0
func checkForWin(box: [Box], checkPoint: [CheckPoint]) {
    var arrBox = [Int]()
    var arrCheckPoint = [Int]()
 
    for each in box {
        arrBox.append(Int(each.boxByWidth))
        arrBox.append(Int(each.boxByHeight))
    }
    
    for each in checkPoint {
        arrCheckPoint.append(Int(each.checkPointByWidth))
        arrCheckPoint.append(Int(each.checkPointByHeight))
    }
    // сравниваем массивы на наличие переменных, которых нету в них
    if Set(arrBox).subtracting(Set(arrCheckPoint)).count == 0 {
        print("Congratulations! You have passed the level!")
        arrBox.removeAll()
        arrCheckPoint.removeAll()
        InfoNextLevel += 1
        
    } else {
        arrBox.removeAll()
        arrCheckPoint.removeAll()
    }
}
 
 
 
////////////////////////////////////////////////////////////////////////////////////
// функции для самой игры, уровней и т.д.
// level_1
var room = Room(byWidth: 5, byHeight: 5)
var hero = Hero(heroByWidth: 3, heroByHeight: 3)
 
var box_1 = Box(boxByWidth: 3, boxByHeight: 2)
var box_2 = Box(boxByWidth: 3, boxByHeight: 4)
var boxArray = [box_1, box_2]
 
var checkPoint_1 = CheckPoint(checkPointByWidth: 1, checkPointByHeight: 1)
var checkPoint_2 = CheckPoint(checkPointByWidth: 5, checkPointByHeight: 5)
var checkPointArray = [checkPoint_1, checkPoint_2]
 
// функция для распечатывания комнаты
func printRoom() {
    room.printRoom(hero: hero, box: boxArray, checkPoint: checkPointArray)
}
 
func level_2() {
    room = Room(byWidth: 7, byHeight: 7)
    hero = Hero(heroByWidth: 4, heroByHeight: 4)
    
    box_1 = Box(boxByWidth: 3, boxByHeight: 3)
    box_2 = Box(boxByWidth: 5, boxByHeight: 5)
    boxArray = [box_1, box_2]
    
    checkPoint_1 = CheckPoint(checkPointByWidth: 2, checkPointByHeight: 2)
    checkPoint_2 = CheckPoint(checkPointByWidth: 6, checkPointByHeight: 6)
    checkPointArray = [checkPoint_1, checkPoint_2]
}
 
 
// функция проверки на переход следующего уровня
func nextLevel() {
    if InfoNextLevel == 1 {
        level_2()
        printRoom()
        InfoNextLevel += 1
        
    } else if InfoNextLevel == 3 {
        print("And you completed all levels!")
        exit(1)
    }
}
 
 
// функция самой игры
func game() {
    print("Hero can move: D(d) - Right, S(s) - Down, A(a) - Left, W(w) - Up")
    printRoom()
 
 
    for _ in 1...10000 {
        let playerTurn = readLine()?.capitalized


        if playerTurn?.count != 0 {
            
            switch playerTurn {
            case "W", "Ц":
                hero.moveHero(move: .Up, room: room, box: boxArray)
                printRoom()
                checkForWin(box: boxArray, checkPoint: checkPointArray)
                nextLevel()
            case "D", "В":
                hero.moveHero(move: .Right, room: room, box: boxArray)
                printRoom()
                checkForWin(box: boxArray, checkPoint: checkPointArray)
                nextLevel()
            case "A", "Ф":
                hero.moveHero(move: .Left, room: room, box: boxArray)
                printRoom()
                checkForWin(box: boxArray, checkPoint: checkPointArray)
                nextLevel()
            case "S", "Ы":
                hero.moveHero(move: .Down, room: room, box: boxArray)
                printRoom()
                checkForWin(box: boxArray, checkPoint: checkPointArray)
                nextLevel()
            default:
                game()
            }
            
        } else {
            print(WrongTurn)
        }
    }
}
 
game()
