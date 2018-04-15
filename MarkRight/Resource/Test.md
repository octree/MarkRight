# 微小的工作

- [三件小事](#三件小事)
- [一点成绩](#一点成绩)
- [人生的经验](#人生的经验)
- [没香港记者跑得快的 Swift](#没香港记者跑得快的Swift)
- [并不 Naive 的香港记者](#并不Naive的香港记者)
- [嵌套](#嵌套)
- [Task List](#TaskList)
- [Table](#Table)


## 三件小事

1. 一个，确立了*社会主义市场经济*
2. 把 [邓小平的理论](https://zh.wikipedia.org/wiki/%E9%82%93%E5%B0%8F%E5%B9%B3%E7%90%86%E8%AE%BA) 列入了党章
3. 第三个，就是我们知道的`三个代表`


## 一点成绩

* 军队一律不得经商
+ 九八年的抗洪也是很重要地


## 人生的经验

> 我今天是作为一个长者给你们讲的。
> 我不是新闻工作者，但是我见得太多了。
> 我……我有这个必要好告诉你们一点，人生的经验。


## 没香港记者跑得快的 Swift

```swift
struct Parser<Result> {

    typealias Stream = Substring
    let parse: (Stream) -> (Result, Stream)?
}

/// atxHeading1 = "#", space, textualContent, atxClosingSequence;
let atxHeading1 = BlockNode.h1 <^> (string("#") *> space *> textualContent <* space.many.optional <* lineEnding)

```


## 并不 Naive 的香港记者

![真正的粉丝](https://2-im.guokr.com/sFp7eZ-PiCYjlJ7nNtnu7nusCu2psuY_BKrelYER7SL0AQAAAQIAAEdJ.gif)


## 嵌套

1. 小明的`爷爷`
    * 小明的`爸爸`
        + 这是`小明`

        ```javascript
        // 小明是傻逼，只会 JS
        console.log("Javascript === Shit")
        ```
2. `创世`节点，没有爸爸
3. 学 `PHP` 并不能救中国
    ```php
    echo "PHP 是世界上最好的语言"
    ```


## Task List


- [x] Parser Combinator
- [x] Generic String Parser
- [x] Inline Parser
- [ ] Block Parser
- [ ] Container Parser

    

## Table
    
------

| Programming Language        | Ratings           | Change  |
| -------------- |:-------------:| -----:|
| Swift    |  1.534 % | 1.34% |
| Kotlin      |  0.32%   |  1.45% |
| Scala | 2.1234%      |  0.233333%  |
| Haskell | 0.233333333%      |    0.123% |
| Objective-C | 3.25%    |   -1.02% |
    

