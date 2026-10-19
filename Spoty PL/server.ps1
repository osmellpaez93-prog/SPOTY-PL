$port = 8888
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Servidor en http://localhost:$port/" -ForegroundColor Green
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $filePath = $request.Url.LocalPath
    if ($filePath -eq "/") { $filePath = "/index.html" }
    $fullPath = Join-Path $PSScriptRoot $filePath.TrimStart("/")
    if (Test-Path $fullPath) {
        $content = [System.IO.File]::ReadAllBytes($fullPath)
        $response.ContentType = "text/html"
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else { $response.StatusCode = 404 }
    $response.Close()
}
