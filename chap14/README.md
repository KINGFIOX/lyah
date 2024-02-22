# chap14

## 二叉树

### 定义二叉树

首先，我们定义一个二叉树，它可以是一个空节点，或者是一个包含值以及两个子树（左子树和右子树）的节点。

```haskell
data BinaryTree a = Empty | Node a (BinaryTree a) (BinaryTree a)
    deriving (Show, Eq)
```

这里，`BinaryTree a`是一个泛型类型，可以存储任何类型`a`的值。
`Empty`表示一个空的树节点，而`Node`构造器接受三个参数：一个值和两个`BinaryTree a`类型的子树。
我们还通过`deriving (Show, Eq)`让这个类型自动派生`Show`和`Eq`类型类的实例，这样我们就可以打印树并比较树是否相等了。

### 构建一棵树

接下来，我们构建一棵具体的树。假设我们想构建下面这样一棵二叉树：

```
    5
   / \
  3   7
 / \   \
2   4   9
```

使用我们定义的`BinaryTree`类型，我们可以这样创建这棵树：

```haskell
myTree :: BinaryTree Int
myTree = Node 5
             (Node 3
                  (Node 2 Empty Empty)
                  (Node 4 Empty Empty))
             (Node 7
                  Empty
                  (Node 9 Empty Empty))
```

这里，`myTree`是一个`BinaryTree Int`类型的值，它详细描述了树的结构，包括每个节点的值和它的子树。

### 使用树

现在我们已经定义了树的数据结构并创建了一棵树，我们可以写一些函数来操作这棵树。例如，我们可以写一个函数来查找树中是否存在某个值：

```haskell
contains :: (Eq a) => a -> BinaryTree a -> Bool
contains _ Empty = False
contains x (Node y left right)
    | x == y    = True
    | otherwise = contains x left || contains x right
```

这个`contains`函数检查一个值是否在树中。它首先检查当前节点，如果当前节点不是要找的值，则递归地在左右子树中查找。

现在，如果我们想检查我们的树`myTree`中是否包含值`4`，我们可以这样做：

```haskell
contains 4 myTree
```

这将返回`True`，因为`4`确实是树中的一个节点。

通过这种方式，你可以定义更多的函数来遍历树、修改树、计算树的深度等等，这些都是操作树结构的常见任务。

## 二叉树的常见操作

### 遍历树

遍历树通常有几种方式：前序遍历、中序遍历和后序遍历。这里，我们实现中序遍历作为示例：

```haskell
inorderTraversal :: BinaryTree a -> [a]
inorderTraversal Empty = []
inorderTraversal (Node value left right) =
    inorderTraversal left ++ [value] ++ inorderTraversal right
```

这个函数将树中的所有值收集到一个列表中，按照“左-根-右”的顺序。

### 修改树

假设我们想要修改树中的每个元素，例如，将每个元素乘以 2。我们可以定义一个函数来实现这一点：

```haskell
modifyTree :: (a -> b) -> BinaryTree a -> BinaryTree b
modifyTree _ Empty = Empty
modifyTree f (Node value left right) =
    Node (f value) (modifyTree f left) (modifyTree f right)
```

这个函数接受一个函数`f`和一棵树，然后应用`f`到树中的每个元素上，生成一棵新的树。

### 计算树的深度

树的深度是从根到最远叶子的最长路径上的节点数。我们可以这样计算它：

```haskell
depthOfTree :: BinaryTree a -> Int
depthOfTree Empty = 0
depthOfTree (Node _ left right) =
    1 + max (depthOfTree left) (depthOfTree right)
```

这个函数计算树的深度，如果树是空的，深度为 0；否则，它是左右子树深度的最大值加 1（加的这 1 是根节点）。

### 使用示例

假设我们使用之前定义的`myTree`：

```haskell
myTree :: BinaryTree Int
myTree = Node 5
             (Node 3
                  (Node 2 Empty Empty)
                  (Node 4 Empty Empty))
             (Node 7
                  Empty
                  (Node 9 Empty Empty))
```

我们可以这样使用这些函数：

- 遍历树：

```haskell
inorderTraversal myTree
-- 结果应该是 [2,3,4,5,7,9]
```

- 修改树（例如，将所有值乘以 2）：

```haskell
modifyTree (*2) myTree
-- 新树中的所有值都是原来的两倍
```

- 计算树的深度：

```haskell
depthOfTree myTree
-- 结果应该是 3
```

这些函数展示了如何在 Haskell 中处理和操作自定义的数据结构，如二叉树，使用函数式编程的方法。

## 层序遍历

```haskell
import Data.Maybe (catMaybes)

-- 假设之前已定义的二叉树类型
data BinaryTree a = Empty | Node a (BinaryTree a) (BinaryTree a) deriving (Show)

-- 层序遍历函数
levelOrderTraversal :: BinaryTree a -> [a]
levelOrderTraversal tree = bfs [tree]
  where
    bfs [] = []
    bfs nodes = catMaybes (map nodeValue nodes) ++ bfs (concatMap childNodes nodes)

    nodeValue Empty = Nothing
    nodeValue (Node value _ _) = Just value

    childNodes Empty = []
    childNodes (Node _ left right) = filter isNotEmpty [left, right]

    isNotEmpty Empty = False
    isNotEmpty _ = True
```

这个实现包含以下几个部分：

1. **`levelOrderTraversal`函数**：这是层序遍历的主函数，它以一棵树（或多棵树的列表）作为输入，并返回一个包含遍历结果的列表。

2. **`bfs`函数**：这是一个辅助函数，用于实际进行遍历。它递归地处理一个节点列表，每次调用处理一层的节点。
   对于每个节点，它使用`nodeValue`提取节点的值（如果存在），并使用`childNodes`获取其子节点以进行下一次递归调用。

3. **`nodeValue`函数**：这个辅助函数从一个节点中提取值。

4. **`childNodes`函数**：这个辅助函数从给定节点获取其非空的子节点列表。

5. **`isNotEmpty`函数**：检查一个节点是否不为空。

使用这个`levelOrderTraversal`函数，你可以对任何`BinaryTree a`类型的树进行层序遍历。例如：

```haskell
let myTree = Node 1 (Node 2 Empty (Node 4 Empty Empty)) (Node 3 Empty Empty)
levelOrderTraversal myTree
-- 这将返回 [1, 2, 3, 4]
```

这段代码通过列表模拟队列，逐层遍历树中的所有节点。
每次递归调用处理一层的节点，并准备下一层的节点列表。
这种方式虽然不是最高效的（因为列表操作可能比真正的队列操作更耗时），但它展示了如何使用纯函数式编程语言来实现层序遍历。
