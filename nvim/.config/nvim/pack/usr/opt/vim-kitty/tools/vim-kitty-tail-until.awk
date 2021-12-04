#!/usr/bin/awk -f

awk NR == 1 {
  ps1 = "^" $0
}

$0 ~ ps1 && $0 ~ search_text {
  exit
}

// {
  print
}
