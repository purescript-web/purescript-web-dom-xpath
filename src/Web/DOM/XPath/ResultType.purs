module Web.DOM.Document.XPath.ResultType where

import Prelude

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

