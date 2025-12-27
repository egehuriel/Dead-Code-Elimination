CXX      := g++
CXXFLAGS := -std=c++17 -I build -I src

BISON := bison
FLEX  := flex

SRC_DIR   := src
BUILD_DIR := build
TEST_DIR  := test

BISON_SRC := $(SRC_DIR)/dce.y
FLEX_SRC  := $(SRC_DIR)/dce.l
MAIN_SRC  := $(SRC_DIR)/main.cpp

BISON_OUT := $(BUILD_DIR)/dce.tab.c
BISON_HDR := $(BUILD_DIR)/dce.tab.h
FLEX_OUT  := $(BUILD_DIR)/lex.yy.c

TARGET := $(BUILD_DIR)/dce

# Test files
TEST1 := $(TEST_DIR)/test1.il
TEST2 := $(TEST_DIR)/test2.il
TEST3 := $(TEST_DIR)/test3.il
TEST4 := $(TEST_DIR)/test4.il
TEST5 := $(TEST_DIR)/test5.il

ALL_TESTS := $(TEST1) $(TEST2) $(TEST3) $(TEST4) $(TEST5)

all: $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BISON_OUT) $(BISON_HDR): $(BISON_SRC) | $(BUILD_DIR)
	$(BISON) -d -o $(BISON_OUT) $(BISON_SRC)

$(FLEX_OUT): $(FLEX_SRC) | $(BUILD_DIR)
	$(FLEX) -o $(FLEX_OUT) $(FLEX_SRC)

$(TARGET): $(MAIN_SRC) $(BISON_OUT) $(FLEX_OUT)
	$(CXX) $(CXXFLAGS) -o $@ $^


run: $(TARGET)
	@echo
	@echo "Running all tests..."
	@echo
	@for t in $(ALL_TESTS); do \
		echo "----- $$t -----"; \
		./$(TARGET) $$t || exit 1; \
	done
	@echo
	@echo "All tests completed."
	@echo

run_test1: $(TARGET)
	@echo
	@echo "----- $(TEST1) -----"
	@./$(TARGET) $(TEST1)
	@echo

run_test2: $(TARGET)
	@echo
	@echo "----- $(TEST2) -----"
	@./$(TARGET) $(TEST2)
	@echo

run_test3: $(TARGET)
	@echo
	@echo "----- $(TEST3) -----"
	@./$(TARGET) $(TEST3)
	@echo

run_test4: $(TARGET)
	@echo
	@echo "----- $(TEST4) -----"
	@./$(TARGET) $(TEST4)
	@echo

run_test5: $(TARGET)
	@echo
	@echo "----- $(TEST5) -----"
	@./$(TARGET) $(TEST5)
	@echo

clean:
	@echo
	@rm -rf $(BUILD_DIR)
	@echo "---- CLEANED ----"
	@echo

clear:
	@echo
	@rm -rf $(BUILD_DIR)
	@echo "---- CLEARED ----"
	@echo

.PHONY: all run run_test1 run_test2 run_test3 run_test4 run_test5 clean