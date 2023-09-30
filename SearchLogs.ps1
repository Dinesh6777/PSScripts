$age = (Get-Date).AddHours(-2000)
$pattern1 = "searchpattern"
$pattern2 = "" #SUCCESSFULLY RECEIVED"
$totalFiles = 0
$totalResults = 0

Get-ChildItem -Path "C:\Temp\Azcopylogs" -Filter *.log -Recurse | Where-Object { $_.LastWriteTime -gt $age } | ForEach-Object {
  if ($_.Name -notlike "*-scanning.log*") {
    $totalFiles++
    $i = 0
    $output1 = Select-String -Path $_.FullName -Pattern $pattern1 | ForEach-Object { "-------------------------------------------------`nResult ${i}: $($_.Line)`n"; $i++ }
    $output2 = $null
    if ($pattern2 -ne "") {
      $i = 0
      $output2 = Select-String -Path $_.FullName -Pattern $pattern2 | ForEach-Object { "-------------------------------------------------`nResult ${i}: $($_.Line)`n"; $i++ }
    }
     
    if ($output1 -or $output2) {
      "`n=============================================`nFile: $($_.FullName)`n"
      if ($output1) {
        "`nPattern: $pattern1`n"
        $output1
        $totalResults += $output1.Count
        "`nNumber of matches for pattern1 in this file: $($output1.Count)`n"
      }
       
      if ($output2) {
        "`nPattern: $pattern2`n"
        $output2
        $totalResults += $output2.Count
        "`nNumber of matches for pattern2 in this file: $($output2.Count)`n"
      }
    }
  }
}

"`n=============================================`nTotal number of files scanned: $totalFiles`nTotal number of results: $totalResults"
