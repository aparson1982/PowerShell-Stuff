<#
    Author:  Robert Parson
    Date:  4/15/16
    Group 2: Web Spider
#>

$Script:Hash = @{}
[Double]$Script:HashCount = 1  
[Double]$Script:totalCount = 1
[Int]$Script:depth = 1  

Function Summon-Spider($url, [Int]$Script:depth)  
{
    Process
    {
        Try  
        {
            if([Int]$Script:depth -eq 0) 
            {
                return   
            }
                "`nNow Crawling $url"
                $Test = curl -Uri $url  
                $Hrefs = $Test.links.href 
                Foreach($href in $Hrefs)  
                {
                    $Script:Hash."$($href)" = [Double]$Script:HashCount  
                    [Double]$Script:HashCount = [Double]$Script:HashCount + 1  
                }
                [Int]$Script:depth = [Int]$Script:depth -1  
                if($Script:depth -ge 1)
                {                                                                                
                    $Script:hash.GetEnumerator() | % {Summon-Spider -url $_.key $Script:depth }  
                }
        }
        catch [System.exception]  
        {
        }
        [Double]$Script:totalCount = [Double]$Script:Hash.Count + [Double]$Script:totalCount  
        $Script:Hash.GetEnumerator() | Sort-Object -Property @{Expression="Value"; Descending=$false} | `
        Format-Table -Property Name, Value -AutoSize| Out-String | Out-Host 
    }
    End 
    {
        " `nResults For URL: $url"
        "`nTotal Hrefs Crawled:  $Script:totalCount `n`n"
       "`nNext depth at:  $Script:depth"
    }
}