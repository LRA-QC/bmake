#compiler, use g++ for now, not tested with clang++ yet 
_CC="g++"
#specify library or application, do you want to create a library or an application executable?
_TYPE="application"
#valid target is either debug or release
_TARGET="debug"
#output folder for binary, will be created if it doesn't exist
_OUTPUT_DIR="target"
#output filename of the binary file
_OUTPUT="test"
#folder and source files (can be an array if you doublequote and leave space between items)
_SOURCE="src/*.cpp"
#folder for include files (can be an array if you doublequote and leave space between items)
_INCLUDES="inc"
#folder for object files
_OBJ="obj"

#external libraries; ie: "GL glad glfw"
_LIBS=""
#custom libraries not in system path (can be an array if you doublequote and leave space between items)
_LIBS_CUSTOM=""

#C++ standard
_STD="-std=c++17"

# [FLAGS ]####
_FLAGS_STANDARD="-fPIC"
_FLAGS_DEBUG="-g -Wall -Werror -D _DEBUG"
_FLAGS_RELEASE="-O2"
# [link type for library output]#
_LINKTYPE="-shared -fPIC"


######################################################
### THERE IS NOTHING BELOW THAT LINE TO CONFIGURE ###
######################################################

if [ "${_TYPE}" == "library" ]; then
   _FLAGS_STANDARD="${_FLAGS_STANDARD} -c"
fi

if [ "$1" == "debug" ]; then
  _TARGET=$1
fi

if [ "$1" == "release" ]; then
  _TARGET=$1
fi

if [ "${_TARGET}" == "debug" ]; then
 _OPTIONS="${_FLAGS_DEBUG} ${_FLAGS_STANDARD}"
 _PATH="${_OUTPUT_DIR}/debug"
else
 _OPTIONS="${_FLAGS_RELEASE} ${_FLAGS_STANDARD}"
 _PATH="${_OUTPUT_DIR}/release"
fi
_LIBRARIES=""
for a in ${_LIBS}; 
do 
  _LIBRARIES="${_LIBRARIES} -l${a}"
done

_INCLUDE=""
for a in ${_INCLUDES}; 
do 
  _INCLUDE="${_INCLUDE} -I${a}"
done

\rm *.o 2>/dev/null
\rm ${_OBJ}/*.o  2>/dev/null
echo "Building ${_TARGET}"
mkdir -p ${_OBJ} 2>/dev/null
mkdir -p ${_PATH} 2>/dev/null
#THIS WILL CREATE A LIBRARY
if [ "${_TYPE}" == "library" ]; then
  echo "- compiling library"
  date
  ${_CC} -c  ${_STD} ${_OPTIONS}  ${_LIBRARIES}  ${_SOURCE} &&  ${_CC} ${_LINKTYPE} -o ${_PATH}/${_OUTPUT}  *.o 
  mv *.o ${_OBJ}
  date
else #THIS WILL CREATE AN EXECUTABLE
  \rm ${_PATH}/${_OUTPUT} 2>/dev/null
  date
  echo "- compiling application"
  ${_CC} -c  ${_STD} ${_OPTIONS}  ${_INCLUDE}  ${_SOURCE} && date #&& ls -al ${_PATH}/${_OUTPUT} && chmod +x ${_PATH}/${_OUTPUT}
  echo "- linking"
  ${_CC} ${_LIBRARIES} -o ${_PATH}/${_OUTPUT} *.o ${_LIBS_CUSTOM} && date
  chmod +x ${_PATH}/${_OUTPUT} 
  mv *.o ${_OBJ}
fi
