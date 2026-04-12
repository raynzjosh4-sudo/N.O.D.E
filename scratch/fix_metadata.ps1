$path = "lib/features/home/presentation/pages/specificationorderpage/page/specs_order_page.dart"
$content = Get-Content $path -Raw

# Replace currentStock: 0 with real data
$content = $content -replace 'currentStock: 0,', 'currentStock: widget.product?.currentStock ?? 0,'
# Replace leadTimeDays: 0 with real data
$content = $content -replace 'leadTimeDays: 0,', 'leadTimeDays: widget.product?.leadTimeDays ?? 0,'
# Replace seoDescription: '' with real data
$content = $content -replace "seoDescription: '',", "seoDescription: widget.product?.seoDescription ?? '',"
# Replace tradingTerms: const TradingTerms(id: '', content: '')
$content = $content -replace "tradingTerms: const TradingTerms\(id: '', content: ''\)", "tradingTerms: widget.product?.tradingTerms ?? const TradingTerms(id: '', content: '')"

$content | Set-Content $path -NoNewline
