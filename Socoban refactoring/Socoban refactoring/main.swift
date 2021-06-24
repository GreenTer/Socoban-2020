
//
//  main.swift
//  Game
//
//  Created by Baravitski Aliaksandr on 20.12.20.
//

import Foundation

// Images
enum Images: String {
    case Field  = "🌑"
    case Hero   = "🧙‍♂️"
    case Dragon = "🐉"
}

// Params for all
struct Params {
    var byHeight: Int, byWidth: Int
    static let wrongWay: () = print("Wrong way")
}

// Field
struct Field {
    var field: Params
}

// Hero
class Hero {
    var hero: Params
    
    init(hero: Params) {
        self.hero = hero
    }
}

// Dragon
class Dragon {
    var dragon: Params
    
    init(dragon: Params) {
        self.dragon = dragon
    }
}

// func dictionary with all Images
func game(gField: Field, gHero: Hero, gArrDragons: [Dragon]) {
    var dicField = [Int: String]()
    
    // dictionary - field работает до 9 клеток!
    for height in 1...gField.field.byHeight {
        for width in 1...gField.field.byWidth {
            dicField[Int(String(height) + String(width))!] = Images.Field.rawValue
        }
    }
    
    // add hero in dictionary
    for (key, _) in dicField {
        if key == Int(String(gHero.hero.byHeight) + String(gHero.hero.byWidth))! {
            dicField[key] = Images.Hero.rawValue
        }
    }

    // add dragon
    for each in gArrDragons {
        for (key, _) in dicField {
            if key == Int(String(each.dragon.byHeight) + String(each.dragon.byWidth))! {
                dicField[key] = Images.Dragon.rawValue
            }
        }
    }
        
    // print field
    var str = ""
    for (_, value) in dicField.sorted(by: <) {
        
        if str.count <= field.field.byWidth {
            str += value
        }
        
        if str.count == field.field.byWidth {
            print(str)
            str = ""
        }
    }
}

// Moves
enum Move: String {
    case Up     = "W"
    case Down   = "S"
    case Left   = "A"
    case Right  = "D"
}

// player move
func playerMove(move: Move, hero: Hero, gArrDragons: [Dragon]) {
    // player move
    switch move {
    case .Up:
        if hero.hero.byHeight > 1 {
            hero.hero.byHeight += -1
        }
    case .Down:
        if hero.hero.byHeight >= 1 && hero.hero.byHeight < field.field.byHeight {
            hero.hero.byHeight += 1
        }
    case .Left:
        if hero.hero.byWidth > 1 {
            hero.hero.byWidth += -1
        }
    case .Right:
        if hero.hero.byWidth >= 1 && hero.hero.byWidth < field.field.byWidth {
            hero.hero.byWidth += 1
        }
    }
    
    // check move dragons
    for each in gArrDragons {
        // дописать код на перемещение драконов!
        switch move {
        case .Up :
            if hero.hero.byWidth == each.dragon.byWidth && hero.hero.byHeight == each.dragon.byHeight && each.dragon.byHeight - 1 >= 1 {
                each.dragon.byHeight += -1
            }
        default:
            break
        }
    }
}

// level 1
var field = Field.init(field: .init(byHeight: 9, byWidth: 9))
var hero = Hero.init(hero: .init(byHeight: 5, byWidth: 5))
var dragon1 = Dragon.init(dragon: .init(byHeight: 1, byWidth: 1))
var dragon2 = Dragon.init(dragon: .init(byHeight: 9, byWidth: 9))
var arrDragons = [dragon1, dragon2]

// game
for _ in 1...1000 {
    // print field
    game(gField: field, gHero: hero, gArrDragons: arrDragons)

    // player turn
    let playerTurn: String = readLine()!.capitalized

    // player move
    switch Move.init(rawValue: playerTurn) {
    case .Up :
        playerMove(move: .Up, hero: hero, gArrDragons: arrDragons)
    case .Down:
        playerMove(move: .Down, hero: hero, gArrDragons: arrDragons)
    case .Left:
        playerMove(move: .Left, hero: hero, gArrDragons: arrDragons)
    case .Right:
        playerMove(move: .Right, hero: hero, gArrDragons: arrDragons)
    default:
        Params.wrongWay
    }
}
