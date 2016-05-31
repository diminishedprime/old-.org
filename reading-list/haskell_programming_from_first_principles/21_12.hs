import Data.Traversable
import Data.Foldable
import Control.Applicative
import Data.Monoid

-- Identity
-- Write a Traversable instance for Identity.
newtype Identity a = Identity a
  deriving (Eq, Ord, Show)

instance Functor Identity where
   fmap f (Identity a) = Identity $ f a

instance Applicative Identity where
   pure = Identity
   (Identity f) <*> a = fmap f a

instance Foldable Identity where
   foldMap f (Identity a) = f a

instance Traversable Identity where
   traverse f (Identity a) = Identity <$> f a


-- Constant
newtype Constant a b = Constant { getConstant :: a }

instance Functor (Constant a) where
  fmap _ (Constant a) = Constant a

instance (Monoid a) => Applicative (Constant a) where
  pure _ = Constant mempty
  (Constant a) <*> (Constant b) = Constant $ a `mappend` b

instance Foldable (Constant a) where
  foldMap _ (Constant _) = mempty

instance Traversable (Constant a) where
  traverse _ (Constant a) = pure $ Constant a

-- Maybe
data Optional a = Nada
  | Yep a

instance Functor Optional where
  fmap _ Nada = Nada
  fmap f (Yep a) = Yep $ f a

instance Applicative Optional where
  pure = Yep
  Nada <*> _ = Nada
  _ <*> Nada = Nada
  (Yep f) <*> (Yep a) = Yep $ f a

instance Foldable Optional where
  foldr _ c Nada = c
  foldr f c (Yep a) = f a c

instance Traversable Optional where
  traverse _ Nada = pure Nada
  traverse f (Yep a) = Yep <$> f a

-- List
data List a = Nil
  | Cons a (List a)

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons a b) = Cons (f a) (fmap f b)

instance Applicative List where
  pure a = Cons a Nil
  fs <*> xs = flatMap (\f -> fmap f xs) fs

append :: List a -> List a -> List a
append Nil ys = ys
append (Cons x xs) ys = Cons x $ xs `append` ys

myFold :: (a -> b -> b) -> b -> List a -> b
myFold _ b Nil = b
myFold f b (Cons h t) = f h (myFold f b t)

flatMap :: (a -> List b) -> List a -> List b
flatMap f as = myFold append Nil $ fmap f as

instance Foldable List where
  foldMap _ Nil = mempty
  foldMap f (Cons h t) = f h `mappend` foldMap f t

instance Traversable List where
  traverse _ Nil = pure Nil
  traverse f (Cons h t) = Cons <$> f h <*> traverse f t
