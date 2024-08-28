# Osert-WoW-Addons

Репозиторий для разработки UI-аддонов для World of Warcraft.

## Cоздание символьной ссылки между модификациями в каталоге /src/ репозитория и каталогом «Addons» игры:
1. Открыть файл «___Link_toAddons.ps1___»;
2. В строке:

```PowerShell
$wowAddonsPath = "..."
```

Содержимое «___...___» заменить на полный путь до каталога модификаций интерфейса.

Пример:
```PowerShell
$wowAddonsPath = "G:\World of Warcraft\_retail_\Interface\AddOns\"
```

3. Запустить терминал ___PowerShell___ с правами адмнистратора;
4. В терминале вызвать комманду:

```PowerShell
# Разрешение на выполнение PowerShell-скриптов
Set-ExecutionPolicy RemoteSigned
```

5. Ввести ___Y___ и нажать ___Enter___;

6. Выполнить скрипт «___Link_toAddons.ps1___»;

7. Вызвать комманду:
```PowerShell
# Сброс политики выполненеия PowerShell-скриптов к значениям по-умолчанию
Set-ExecutionPolicy Default
```

8. Ввести ___Y___ и нажать ___Enter___;