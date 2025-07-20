CXX = g++
CXXFLAGS = -Wall -std=c++17
CXXDEBUGFLAGS = -ggdb -fsanitize=address -fsanitize=undefined

# MODELFILES = \
# 	Models/Entities/EntityModel.cpp \
# 	Models/BattleModel.cpp \
# 	Models/Equipment/EquipmentFactory.cpp \
# 	Models/OverworldModel.cpp \
# 	Models/PartyModel.cpp

# LOGICFILES = \
# 	LogicLayer/EntityLogic.cpp \
# 	LogicLayer/GameLogic.cpp \
# 	LogicLayer/BattleLogic.cpp \
# 	LogicLayer/AttackLogic.cpp \
# 	LogicLayer/LogicWrapper.cpp \
# 	LogicLayer/EncounterLogic.cpp

# UIFILES = \
# 	UILayer/UIHandler.cpp \
# 	UILayer/IOHandler.cpp \
# 	UILayer/BattleHandler.cpp \
# 	UILayer/AsciiHandler.cpp \
# 	UILayer/OverworldHandler.cpp \
# 	UILayer/EncounterHandler.cpp \
# 	UILayer/StoryHandler.cpp

# Combine all source files
CXXFILES = main.cpp #$(MODELFILES) $(LOGICFILES) $(UIFILES)

TARGETS = debug main

.PHONY: all fresh clean

OBJFILES = $(CXXFILES:.cpp=.o)

all: main

main:
	$(info Building $@)
	$(CXX) $(CXXFLAGS) -o bt-bot.out $(CXXFILES)

debug: clean
	$(info Building debug $@)
	$(CXX) $(CXXFLAGS) $(CXXDEBUGFLAGS) -o debug.out $(CXXFILES)
	gdb ./debug.out

run: clean
	$(CXX) $(CXXFLAGS) -o bt-bot.out $(CXXFILES)
	./bt-bot.out
# "short" target: incremental build that compiles only changed source files
short: $(OBJFILES)
	$(info Linking object files to create executable)
	$(CXX) $(CXXFLAGS) -o bt-bot.out $(OBJFILES)
	./bt-bot.out

fast:
	./bt-bot.out

deb:
	gdb ./debug.out

clean:
	rm -f $(OBJFILES) ./bt-bot.out ./debug.out
	$(info Cleaned project)

fresh:
	$(MAKE) clean
	$(MAKE) all