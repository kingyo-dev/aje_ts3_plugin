CC=g++
CFLAGS=-Wall -Iinclude
LFLAGS=
TARGET=aje_ts3plugin_64bit.dll

default: clear
	$(CC) $(CFLAGS) -c src/plugin.c
	$(CC) -shared -o ${TARGET} plugin.o -Wl,--out-implib,libplugin_win64.a

clear:
	rm -rf *.o
	rm -rf $(TARGET)
