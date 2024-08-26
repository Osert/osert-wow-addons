# Скрипт для создания символьной ссылки между репозиторием и каталогом модификаций в WoW

# Путь до каталога с модификациями
$wowAddonsPath = "G:\World of Warcraft\_retail_\Interface\AddOns\"

$addons = Get-ChildItem -Path "src"

for (
    $i = 0
    $i -lt $addons.Count
    $i++
) {
    $linkPath = $wowAddonsPath+$addons[$i].Name
    $targetPath = $addons[$i].FullName

    if (Test-Path $linkPath) {
        Remove-Item -Path $linkPath
    }

    New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath
}

