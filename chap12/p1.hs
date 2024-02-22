import Control.Monad -- 主要是要导入 guard

applyMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
applyMaybe Nothing f = Nothing
applyMaybe (Just x) f = f x

-- haskell 中就是这么定义的
-- instance Monad Maybe where
--   return x = Just x
--   Nothing >>= f = Nothing
--   Just x >>= f = f x

type Birds = Int

type Pole = (Birds, Birds)

-- landLeft :: Birds -> Pole -> Pole
-- landLeft n (left, right) = (left + n, right)

-- landRight :: Birds -> Pole -> Pole
-- landRight n (left, right) = (left, right + n)

-- 定义函数
(-:) :: t1 -> (t1 -> t2) -> t2
x -: f = f x

-- 走钢丝
landLeft :: Birds -> Pole -> Maybe Pole
landLeft n (left, right)
  | abs ((left + n) - right) < 4 = Just (left + n, right)
  | otherwise = Nothing

landRight :: Birds -> Pole -> Maybe Pole
landRight n (left, right)
  | abs (left - (right + n)) < 4 = Just (left, right + n)
  | otherwise = Nothing

-- 添加一个令人滑倒的香蕉皮
banana :: p -> Maybe a
banana _ = Nothing

(>>) :: (Monad m) => m a -> m b -> m b
m >> n = m >>= const n

-- 这个教程老了，请用 const n 来替代 \_ -> n
-- m >> n = m >>= \_ -> n

-- 路线
-- landLeft 1 (0, 0) -> pole(1, 0)
-- landRight 4 pole1(1, 0) -> pole(1, 4)
routine :: Maybe Pole
routine = case landLeft 1 (0, 0) of
  Nothing -> Nothing
  Just pole1 -> case landRight 4 pole1 of
    Nothing -> Nothing
    Just pole2 -> case landLeft 2 pole2 of
      Nothing -> Nothing
      Just pole3 -> landLeft 1 pole3

-- class Monad m where
--   return :: a -> m a
--   (>>=) :: m a -> (a -> m b) -> m b
--   (>>) :: m a -> m b -> m b
--   x >> y = x >>= \_ -> y

-- x >> y = x >>= \_ -> y，将 x 的值传递给 (\_ -> y) 这个函数，
-- -- 这个函数返回 y

---------- ---------- >>= 的使用范例 ---------- ----------

maybeValue :: Maybe Int
maybeValue = Just 3

addFive :: Int -> Maybe Int
addFive x = Just (x + 5)

result :: Maybe Int
result = maybeValue >>= addFive -- result 将会是 Just 8

---------- ---------- >>= 的使用范例 ---------- ----------

-- [(1,'a'),(1,'b'),(2,'a'),(2,'b')]
-- [ (n,ch) | n <- [1,2], ch <- ['a','b'] ]
listOfTuples :: [(Integer, Char)]
listOfTuples = do
  n <- [1, 2]
  ch <- ['a', 'b']
  return (n, ch)

---------- ---------- 移动 knight ---------- ----------

type KnightPos = (Int, Int)

-- 定义了 knight 可以往哪里走
moveKnight :: KnightPos -> [KnightPos]
moveKnight (c, r) = do
  (c', r') <-
    [ (c + 2, r - 1),
      (c + 2, r + 1),
      (c - 2, r - 1),
      (c - 2, r + 1),
      (c + 1, r - 2),
      (c + 1, r + 2),
      (c - 1, r - 2),
      (c - 1, r + 2)
      ]
  guard (c' `elem` [1 .. 8] && r' `elem` [1 .. 8])
  return (c', r')

-- 另一种实现方式：filter
-- moveKnight :: KnightPos -> [KnightPos]
-- moveKnight (c, r) =
--   filter
--     onBoard
--     [ (c + 2, r - 1),
--       (c + 2, r + 1),
--       (c - 2, r - 1),
--       (c - 2, r + 1),
--       (c + 1, r - 2),
--       (c + 1, r + 2),
--       (c - 1, r - 2),
--       (c - 1, r + 2)
--     ]
--   where
--     onBoard (c, r) = c `elem` [1 .. 8] && r `elem` [1 .. 8]

-- -- 3 步之内可以到达的所有位置
-- in3 :: KnightPos -> [KnightPos]
-- in3 start = do
--   first <- moveKnight start
--   second <- moveKnight first
--   moveKnight second
in3 :: KnightPos -> [KnightPos]
in3 start = moveKnight start >>= moveKnight >>= moveKnight

canReachIn3 :: KnightPos -> KnightPos -> Bool
canReachIn3 start end = end `elem` in3 start

(<=<) :: (Monad m) => (b -> m c) -> (a -> m b) -> (a -> m c)
f <=< g = g >=> f
