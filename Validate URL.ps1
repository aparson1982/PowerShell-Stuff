#this ensures the address is a valid url
function isURI($address)
{
    ($address -as [System.URI]).AbsoluteURI -ne $null
}

#this checks href if it is absolute or relative
function isURIWeb($address)
{
    $uri = $address -as [System.URI]
    $uri.AbsoluteURI -ne $null -and $uri.Scheme -match '[http|https]'
}