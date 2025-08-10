# Fix External Plugins Issues
Write-Host "Starting external plugin fixes..."

# 1. Create missing ExtUtils class
$extUtilsDir = "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\externals\utils"
if (-not (Test-Path $extUtilsDir)) {
    New-Item -ItemType Directory -Path $extUtilsDir -Force
}

$extUtilsContent = @'
package net.runelite.client.plugins.externals.utils;

import net.runelite.client.plugins.Plugin;

public class ExtUtils extends Plugin
{
    // ExtUtils implementation
}
'@

Set-Content -Path "$extUtilsDir\ExtUtils.java" -Value $extUtilsContent

Write-Host "Created ExtUtils.java"

# 2. Fix ItemData to use proper Lombok
$itemDataPath = "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\pojos\ItemData.java"
$itemDataContent = @'
package net.runelite.client.plugins.externals.oneclick.pojos;

import lombok.AllArgsConstructor;
import lombok.Getter;
import net.runelite.api.ItemComposition;

@Getter
@AllArgsConstructor
public class ItemData
{
	private final int id;
	private final int quantity;
	private final int index;
	private final String name;
	private final ItemComposition definition;
}
'@

Set-Content -Path $itemDataPath -Value $itemDataContent
Write-Host "Fixed ItemData.java with proper Lombok annotations"

Write-Host "External plugin fixes completed"
