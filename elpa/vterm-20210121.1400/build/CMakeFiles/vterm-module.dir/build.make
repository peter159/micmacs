# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/linyi/.emacs.d/elpa/vterm-20210121.1400

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/linyi/.emacs.d/elpa/vterm-20210121.1400/build

# Include any dependencies generated for this target.
include CMakeFiles/vterm-module.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/vterm-module.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/vterm-module.dir/flags.make

CMakeFiles/vterm-module.dir/vterm-module.c.o: CMakeFiles/vterm-module.dir/flags.make
CMakeFiles/vterm-module.dir/vterm-module.c.o: ../vterm-module.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/linyi/.emacs.d/elpa/vterm-20210121.1400/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/vterm-module.dir/vterm-module.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/vterm-module.dir/vterm-module.c.o   -c /home/linyi/.emacs.d/elpa/vterm-20210121.1400/vterm-module.c

CMakeFiles/vterm-module.dir/vterm-module.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/vterm-module.dir/vterm-module.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/linyi/.emacs.d/elpa/vterm-20210121.1400/vterm-module.c > CMakeFiles/vterm-module.dir/vterm-module.c.i

CMakeFiles/vterm-module.dir/vterm-module.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/vterm-module.dir/vterm-module.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/linyi/.emacs.d/elpa/vterm-20210121.1400/vterm-module.c -o CMakeFiles/vterm-module.dir/vterm-module.c.s

CMakeFiles/vterm-module.dir/utf8.c.o: CMakeFiles/vterm-module.dir/flags.make
CMakeFiles/vterm-module.dir/utf8.c.o: ../utf8.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/linyi/.emacs.d/elpa/vterm-20210121.1400/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/vterm-module.dir/utf8.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/vterm-module.dir/utf8.c.o   -c /home/linyi/.emacs.d/elpa/vterm-20210121.1400/utf8.c

CMakeFiles/vterm-module.dir/utf8.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/vterm-module.dir/utf8.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/linyi/.emacs.d/elpa/vterm-20210121.1400/utf8.c > CMakeFiles/vterm-module.dir/utf8.c.i

CMakeFiles/vterm-module.dir/utf8.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/vterm-module.dir/utf8.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/linyi/.emacs.d/elpa/vterm-20210121.1400/utf8.c -o CMakeFiles/vterm-module.dir/utf8.c.s

CMakeFiles/vterm-module.dir/elisp.c.o: CMakeFiles/vterm-module.dir/flags.make
CMakeFiles/vterm-module.dir/elisp.c.o: ../elisp.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/linyi/.emacs.d/elpa/vterm-20210121.1400/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object CMakeFiles/vterm-module.dir/elisp.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/vterm-module.dir/elisp.c.o   -c /home/linyi/.emacs.d/elpa/vterm-20210121.1400/elisp.c

CMakeFiles/vterm-module.dir/elisp.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/vterm-module.dir/elisp.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/linyi/.emacs.d/elpa/vterm-20210121.1400/elisp.c > CMakeFiles/vterm-module.dir/elisp.c.i

CMakeFiles/vterm-module.dir/elisp.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/vterm-module.dir/elisp.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/linyi/.emacs.d/elpa/vterm-20210121.1400/elisp.c -o CMakeFiles/vterm-module.dir/elisp.c.s

# Object files for target vterm-module
vterm__module_OBJECTS = \
"CMakeFiles/vterm-module.dir/vterm-module.c.o" \
"CMakeFiles/vterm-module.dir/utf8.c.o" \
"CMakeFiles/vterm-module.dir/elisp.c.o"

# External object files for target vterm-module
vterm__module_EXTERNAL_OBJECTS =

../vterm-module.so: CMakeFiles/vterm-module.dir/vterm-module.c.o
../vterm-module.so: CMakeFiles/vterm-module.dir/utf8.c.o
../vterm-module.so: CMakeFiles/vterm-module.dir/elisp.c.o
../vterm-module.so: CMakeFiles/vterm-module.dir/build.make
../vterm-module.so: libvterm-prefix/src/libvterm/.libs/libvterm.a
../vterm-module.so: CMakeFiles/vterm-module.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/linyi/.emacs.d/elpa/vterm-20210121.1400/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking C shared module ../vterm-module.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/vterm-module.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/vterm-module.dir/build: ../vterm-module.so

.PHONY : CMakeFiles/vterm-module.dir/build

CMakeFiles/vterm-module.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/vterm-module.dir/cmake_clean.cmake
.PHONY : CMakeFiles/vterm-module.dir/clean

CMakeFiles/vterm-module.dir/depend:
	cd /home/linyi/.emacs.d/elpa/vterm-20210121.1400/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/linyi/.emacs.d/elpa/vterm-20210121.1400 /home/linyi/.emacs.d/elpa/vterm-20210121.1400 /home/linyi/.emacs.d/elpa/vterm-20210121.1400/build /home/linyi/.emacs.d/elpa/vterm-20210121.1400/build /home/linyi/.emacs.d/elpa/vterm-20210121.1400/build/CMakeFiles/vterm-module.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/vterm-module.dir/depend

