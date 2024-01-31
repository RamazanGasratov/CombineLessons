//
//  Two Sum.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 31.01.2024.
//

import Foundation

/*
 Для массива целых чисел nums и целого числа target верните индексы двух чисел так, чтобы их сумма была равна target.

 Вы можете предполагать, что каждый ввод будет иметь ровно одно решение, и вы не можете использовать один и тот же элемент дважды.

 Ответ можно возвращать в любом порядке.
 */

class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        for i in 0..<nums.count {
            if let idx = nums.firstIndex(of: target - nums[i]), idx != i {
                return [i, idx]
            }
        }
        return []
    }
}
