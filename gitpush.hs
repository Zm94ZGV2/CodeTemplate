{-# LANGUAGE OverloadedStrings #-}

import System.Process (callCommand)
import System.Environment (getArgs)

main :: IO ()
main = do
    args <- getArgs
    let msg = if null args
              then "update via Haskell script"
              else unwords args
    putStrLn "=== Git add semua file ==="
    callCommand "git add ."

    putStrLn $ "=== Git commit dengan pesan: " ++ msg ++ " ==="
    callCommand $ "git commit -m \"" ++ msg ++ "\" || echo \"Tidak ada perubahan untuk di-commit\""

    putStrLn "=== Git push ke origin (branch saat ini) ==="
    callCommand "git push"
