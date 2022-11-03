# AJE TeamSpeak3 Plugin

За основу взято вот это SDK для плагина с примером: [https://github.com/TeamSpeak-Systems/ts3client-pluginsdk](https://github.com/TeamSpeak-Systems/ts3client-pluginsdk)

Документации к SDK ноль =\

Вроде, как есть какая то инфа в SDK тут [https://www.teamspeak.com/en/downloads/#sdk](https://www.teamspeak.com/en/downloads/#sdk). Много букв, но про плагины там ни слова =( Какие то примеры с кучей `printf` и `SLEEP` O_o

В результате `Google` в помощь, у меня вроде получилось =) Сложил все что нарыл в папку `doc`.

Там же можно найти `pluginsdk_3.1.1.1`, который я нашёл на просторах интернетов, там есть что то похожее на документацию, но это не точно.

# Установка

Поместить `aje_ts3plugin_64bit.dll` в папку с плагинами `config\plugins\`.

У меня переносная версия и папка `config` находится в папке приложения. Для версий `Team Speak 3` установленных через инсталлятор папка должна быть где то тут `%APPDATA%\TS3Client\`

Напомню, папка `%APPDATA` находится где то тут - `C:\Users\UserName\AppData\Roaming`. В место `UserName` укажите имя вашего пользователя Windows.

В результате получаем что то вроде: `C:\Users\UserName\AppData\Roaming\TS3Client\config\plugins\`

# Что делает плагин

Если нажать на канал правой кнопкой, в меню появится `AJE Plugin`, внутри будет `Сохранить рейд`. При сохранении рейда формируется запрос в виде ссылки в который передается список пользователей на выбранном канале. Ссылка передается в систему и теоретически открывается в броузере.

# Код

Код плагина находится в файле `src/plugin.c`.

Оригинальный код примера я почистил. Главная часть где то ближе к концу, в функции `ts3plugin_onMenuItemEvent`.

```c++
void ts3plugin_onMenuItemEvent(uint64 serverConnectionHandlerID, enum PluginMenuType type, int menuItemID, uint64 selectedItemID) {
	char configPath[PATH_BUFSIZE];
	std::string requestUrl;
	anyID *channelClientsIdList;
	switch(type) {
		case PLUGIN_MENU_TYPE_CHANNEL:
			/* Channel contextmenu item was triggered. selectedItemID is the channelID of the selected channel */
			switch(menuItemID) {
				case MENU_ID_CHANNEL_SAVE_RAID:

					// Получаем путь к папке config для TS3.
    				// ts3Functions.getConfigPath(configPath, PATH_BUFSIZE);
					// ts3Functions.printMessageToCurrentTab(configPath);

					// Получаем урл для запроса из файла конфигурации.
					requestUrl = AJE_DEFAULT_REQUEST_URL;
					// Получаем список клиентов на канале.
					ts3Functions.printMessageToCurrentTab("AJE Plugin: save raid.");
					if (ts3Functions.getChannelClientList(serverConnectionHandlerID, selectedItemID, &channelClientsIdList) == ERROR_ok) {
						std::string players;
						for (int i = 0; channelClientsIdList[i]; ++i) {
							// Добавляем имена участников канала в список players через запятую предварительно кодируя их для передачи в URL.
							char *name = new char[255];
							if (ts3Functions.getClientDisplayName(serverConnectionHandlerID, channelClientsIdList[i], name, 255) == ERROR_ok) {
								if (players.length()) {
									players.append(",");
								}
								players.append(urlencode(name));
							}

							// TEST BEGIN: Get client unique ID from user ID

							// char* uid;
							// if (ts3Functions.getClientVariableAsString(serverConnectionHandlerID, channelClientsIdList[i], CLIENT_UNIQUE_IDENTIFIER, &uid) == ERROR_ok) {
							// 	std::string s = std::string(name) + ": " + uid;
							// 	ts3Functions.printMessageToCurrentTab(s.c_str());
							// 	ts3Functions.freeMemory(uid);
							// }

							// TEST END

							delete name;
						}
						// Формируем запрос.
						std::string request = requestUrl + players;
						ts3Functions.printMessageToCurrentTab("AJE Plugin: open URL.");
						ts3Functions.printMessageToCurrentTab(request.c_str());
						// Передаем запрос с броузер.
						ShellExecute(0, "Open", request.c_str(), 0, 0, SW_SHOW);
					}
					ts3Functions.printMessageToCurrentTab("AJE Plugin: done.");
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
}
```

Некоторые дефайны вынесены в `aje.h` для удобства модификации.

Там строки а также префикс адреса запроса.

```c++
#define AJE_DEFAULT_REQUEST_URL "http://localhost/Projects/experiments/aje_ts3_plugin/web.test?players="
```

Есть идея подгружать префикс из конфиг файла, но пока не реализовано, хотя в коде можно найти закомментированные строки определения пати к папке `config`, так что, дело за малым =)

```c++
// Получаем путь к папке config для TS3.
// ts3Functions.getConfigPath(configPath, PATH_BUFSIZE);
// ts3Functions.printMessageToCurrentTab(configPath);
```

Идея спорная, с одной стороны вынести URL в конфиг было бы удобно, с другой стороны для вызова запроса используется `ShellExecute`, что позволит выполнить любую команду, а это ппц какая дыра в безопасности =\ Надо курить как получить путь для запуска броузера по умолчанию, либо топорно вызывать `Internet Explorer` который уже не используется но многие так делают... В общем, идет оно все лесом, лениво.

# Изучение API

Выше я писал, что вменяемой документации нет и либо `Google` либо майним код. 

Кое что есть внутри оригинального примера `doc\ts3client-pluginsdk\srс\plugin.c`.

Также, читаем `include\ts3_functions.h` - список функций клиента, по именам можно о многом догадаться.

# Сборка

Проект рассчитан на сборку с использованием компилятора `mingw` (`mingw32-make.exe`).