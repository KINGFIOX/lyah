import Control.Monad.State
import Control.Monad.Writer

-- import System.Random

-- 定义过了 writer 的 >>=
-- instance (Monoid w) => Monad (Writer w) where
--   return x = Writer (x, mempty)
--   (Writer (x, v)) >>= f = let (Writer (y, v')) = f x in Writer (y, v `mappend` v')

applyLog :: (Monoid m) => (a, m) -> (a -> (b, m)) -> (b, m)
applyLog (x, log) f = let (y, newLog) = f x in (y, log `mappend` newLog)

gcd' :: Int -> Int -> Writer [String] Int
gcd' a b
  | b == 0 = do
      tell ["Finished with " ++ show a]
      return a
  | otherwise = do
      tell [show a ++ " mod " ++ show b ++ " = " ++ show (a `mod` b)]
      gcd' b (a `mod` b)

newtype DiffList a = DiffList {getDiffList :: [a] -> [a]}

-- instance Monoid (DiffList a) where
--   mempty = DiffList (\xs -> [] ++ xs)
--   (DiffList f) `mappend` (DiffList g) = DiffList (\xs -> f (g xs))

-- finalCountDown :: Int -> Writer [String] ()
finalCountDown :: (Eq a, Num a, MonadWriter [String] m, Show a) => a -> m ()
finalCountDown 0 = do
  tell ["0"]
finalCountDown x = do
  finalCountDown (x - 1)
  tell [show x]

-- threeCoins :: StdGen -> (Bool, Bool, Bool)
-- threeCoins gen =
--   let (firstCoin, newGen) = random gen
--       (secondCoin, newGen') = random newGen
--       (thirdCoin, newGen''') = random newGen'
--    in (firstCoin, secondCoin, thirdCoin)

-- -- 这行代码是为 state 实现 monad 的接口
-- instance Monad (State s) where
--   -- return x = State $ \s -> (x,s)
--   return x = State State (x,) (x,)
--   (State h) >>= f = State $ \s ->
--     let (a, newState) = h s
--         (State g) = f a
--      in g newState

readMaybe :: (Read a) => String -> Maybe a
readMaybe st = case reads st of
  [(x, "")] -> Just x
  _ -> Nothing
