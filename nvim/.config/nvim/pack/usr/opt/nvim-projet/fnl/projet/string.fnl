(fn escape [str char]
  (string.gsub str char (.. "\\" char)))

{: escape}

