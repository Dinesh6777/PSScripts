<# This script is a powerful tool for scanning log files and searching for specific patterns. 
It provides a detailed report of the results, making it easier to analyze the log files. Please note 
that you need to have the necessary permissions to read the files in the specified directory to run this script. 
If you encounter any issues, feel free to ask for help! 

#>

# Define the time 2000 hours ago
$age = (Get-Date).AddHours(-40)

# Define Log files location.
$logpath = "C:\Temp\Azcopylogs"


# Define the patterns to search for
$pattern1 = "imdb"
$pattern2 = "" #SUCCESSFULLY RECEIVED"

# Initialize counters for total files and results
$totalFiles = 0
$totalResults = 0

# Initialize counters for files with and without matches
$filesWithMatches = 0
$filesWithoutMatches = 0

# Get all .log files in the directory that have been modified after $age
Get-ChildItem -Path $logpath -Filter *.log -Recurse | Where-Object { $_.LastWriteTime -gt $age } | ForEach-Object {
    # Exclude files with "-scanning.log" in their name
    if ($_.Name -notlike "*-scanning.log*") {
        # Increment the total files counter
        $totalFiles++
        
        # Initialize a counter for the results
        $i = 0
        
        # Search for $pattern1 in the file and store the results
        $output1 = Select-String -Path $_.FullName -Pattern $pattern1 | ForEach-Object { "-----> Result ${i}: Line $($_.LineNumber): $($_.Line)`n"; $i++ }
        
        # Initialize $output2 as null
        $output2 = $null
        
        # If $pattern2 is not an empty string, search for it in the file and store the results
        if ($pattern2 -ne "") {
            $i = 0
            $output2 = Select-String -Path $_.FullName -Pattern $pattern2 | ForEach-Object { "--------------------> Result ${i}: Line $($_.LineNumber): $($_.Line)`n"; $i++ }
        }
        
        # If either $output1 or $output2 is not null, print the results
        if ($output1 -or $output2) {
            # Increment the counter for files with matches
            $filesWithMatches++
            
            Write-Host "`n=============================================`nFile: $($_.FullName)`n" -ForegroundColor Cyan
            
            # If $output1 is not null, print the results for $pattern1
            if ($output1) {
                Write-Host "`nPattern: $pattern1`n" -ForegroundColor Yellow
                Write-Host $output1 -ForegroundColor Green
                $totalResults += $output1.Count
                Write-Host "`nNumber of matches for Pattern1 in this file: $($output1.Count)" -ForegroundColor Yellow
                Write-Host "File: $($_.FullName)`n" -ForegroundColor Yellow
            }
            
            # If $output2 is not null, print the results for $pattern2
            if ($output2) {
                Write-Host "`nPattern: $pattern2`n" -ForegroundColor Yellow
                Write-Host $output2 -ForegroundColor Green
                $totalResults += $output2.Count
                Write-Host "`nNumber of matches for Pattern2 in this file: $($output2.Count)" -ForegroundColor Yellow
                Write-Host "File: $($_.FullName)`n" -ForegroundColor Yellow
            }
        } else {
            # Increment the counter for files without matches
            $filesWithoutMatches++
        }
    }
}

# Print the total number of files scanned and the total number of results
Write-Host "`n=============================================`nTotal number of files scanned: $totalFiles`nTotal number of results: $totalResults" -ForegroundColor Cyan

# Print the total number of files with and without matches
Write-Host "`nTotal number of files that has the matching pattern: $filesWithMatches`nTotal number of files that has no matching pattern: $filesWithoutMatches" -ForegroundColor Cyan
