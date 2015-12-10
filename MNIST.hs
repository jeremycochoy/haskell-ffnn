module MNIST where

import           Data.Word
import qualified Data.Vector as V
import           Data.Binary.Get
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as LB

data ImageSet = ImageSet {
	magic          :: Word32,
	number_entries :: Word32,
	width          :: Word32,
	height         :: Word32,
	images         :: [V.Vector Word8]
	} deriving Show

bs2vec = V.fromList . B.unpack

loadFileGet :: Get ImageSet
loadFileGet = do
	magic <- getWord32be
	nb_ent <- getWord32be
	w <- getWord32be
	h <- getWord32be
	imgs <- sequence . take (fromIntegral nb_ent) . repeat $ getByteString (fromIntegral $ w*h)
	return $ ImageSet magic nb_ent w h (fmap bs2vec imgs)

loadFile :: String -> IO ImageSet
loadFile fileName = do
	bytes <- LB.readFile fileName
	return $ runGet loadFileGet bytes

Ok, on a nos images, c'est fini pour today :)