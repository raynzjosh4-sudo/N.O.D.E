Add-Type -AssemblyName System.Drawing
$path = "c:\Users\user\Desktop\dev\node_app\assets\icon\nodeiconsymble.png"
$bmp = [System.Drawing.Bitmap]::FromFile($path)
$cyan = [System.Drawing.Color]::FromArgb(255, 18, 187, 240)
$bmp.MakeTransparent($cyan)

$cropWidth = [int]($bmp.Width * 0.8)
$cropHeight = [int]($bmp.Height * 0.8)
$cropX = [int]($bmp.Width * 0.1)
$cropY = [int]($bmp.Height * 0.1)

$rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropWidth, $cropHeight
$newBmp = $bmp.Clone($rect, $bmp.PixelFormat)

$outPath = "c:\Users\user\Desktop\dev\node_app\assets\icon\nodeiconsymble_pure.png"
$newBmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
