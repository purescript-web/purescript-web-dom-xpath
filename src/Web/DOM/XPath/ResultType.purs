module Web.DOM.Document.XPath.ResultType where

import Prelude

import Data.Maybe              (Maybe(..))

newtype ResultType = ResultType Int
instance showResultType :: Show ResultType where
  show (ResultType val) = "(ResultType " <> show val <> ")"
derive instance eqResultType :: Eq ResultType

foreign import any_type :: ResultType
foreign import number_type :: ResultType
foreign import string_type :: ResultType
foreign import boolean_type :: ResultType
foreign import unordered_node_iterator_type :: ResultType
foreign import ordered_node_iterator_type :: ResultType
foreign import unordered_node_snapshot_type :: ResultType
foreign import ordered_node_snapshot_type :: ResultType
foreign import any_unordered_node_type :: ResultType
foreign import first_ordered_node_type :: ResultType


data SnapshotType
  = UnorderedSnapshotType
  | OrderedSnapshotType

-- | Map from restricted type `SnapshotType` to `ResultType` values.
snap2ResType :: SnapshotType -> ResultType
snap2ResType UnorderedSnapshotType = unordered_node_snapshot_type
snap2ResType OrderedSnapshotType = ordered_node_snapshot_type

-- | Inverse of `snap2ResType`.
res2SnapType :: ResultType -> Maybe SnapshotType
res2SnapType r | r == unordered_node_snapshot_type = Just UnorderedSnapshotType
res2SnapType r | r == ordered_node_snapshot_type = Just OrderedSnapshotType
res2SnapType _ = Nothing

data IteratorType
  = UnorderedIteratorType
  | OrderedIteratorType

-- | Map from restricted type `IteratorType` to `ResultType` values.
iter2ResType :: IteratorType -> ResultType
iter2ResType UnorderedIteratorType = unordered_node_iterator_type
iter2ResType OrderedIteratorType = ordered_node_iterator_type

-- | Inverse of `iter2ResType`.
res2IterType :: ResultType -> Maybe IteratorType
res2IterType r | r == unordered_node_iterator_type = Just UnorderedIteratorType
res2IterType r | r == ordered_node_iterator_type = Just OrderedIteratorType
res2IterType _ = Nothing
