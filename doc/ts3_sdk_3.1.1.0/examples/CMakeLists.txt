cmake_minimum_required (VERSION 3.18)

SET(CMAKE_SKIP_BUILD_RPATH  FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
SET(CMAKE_INSTALL_RPATH "\$ORIGIN")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
#SET(CMAKE_BUILD_RPATH "\$ORIGIN")

list(APPEND TS_SAMPLES
    client
    client_customdevice
    client_minimal
    client_minimal_filetransfer
    server
    server_creation_params
    server_filetransfer
    server_minimal
    server_permissions
)
list(APPEND TS_SAMPLE_TYPES client client client client server server server server server)
foreach(sample_folder sample_type IN ZIP_LISTS TS_SAMPLES TS_SAMPLE_TYPES)
    if("${sample_type}" STREQUAL "server" AND CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        continue()
    endif()

    message(STATUS "sample_folder=${sample_folder}, sample_type=${sample_type}")
    project ("ts_${sample_folder}_sample" LANGUAGES C)

    include("${CMAKE_CURRENT_LIST_DIR}/../cmake/ide.cmake")

    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../cmake")

    include("${CMAKE_CURRENT_LIST_DIR}/${sample_folder}/sources.cmake")
    message("TS_SAMPLE_SRC ${TS_SAMPLE_SRC}")
    # Create named folders for the sources within the .vcproj
    # Empty name lists them directly under the .vcproj
    source_group("" FILES ${TS_SAMPLE_SRC})

    # Turn on the ability to create folders to organize projects (.vcproj)
    # It creates "CMakePredefinedTargets" folder by default and adds CMake
    # defined projects like INSTALL.vcproj and ZERO_CHECK.vcproj
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)

    # Set compiler flags and options. 
    # Here it is setting the Visual Studio warning level to 4
    # set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")

    # Command to output information to the console
    # Useful for displaying errors, warnings, and debugging
    # message ("cxx Flags:" ${CMAKE_CXX_FLAGS})
    set(ts_sample_bin "ts_${sample_folder}")
    add_executable(${ts_sample_bin} ${TS_SAMPLE_SRC} ${TS_COMMON_SDK_IDE} ${TS_SDK_IDE})

    if ("${sample_type}" STREQUAL "client")
        set(TSClientSdk_DIR "${CMAKE_CURRENT_LIST_DIR}/../cmake")
        find_package(TSClientSdk REQUIRED)
        message("TSClientSdk_FOUND: ${TSClientSdk_FOUND}")
        message("TSClientSdk_INCLUDE_DIRS: ${TSClientSdk_INCLUDE_DIRS}")
        message("TSClientSdk_LIBRARIES: ${TSClientSdk_LIBRARIES}")
        target_include_directories(${ts_sample_bin} PUBLIC ${TSClientSdk_INCLUDE_DIRS})
        target_link_libraries(${ts_sample_bin} "${TSClientSdk_LIBRARIES}")
    elseif("${sample_type}" STREQUAL "server")
        set(TSServerSdk_DIR "${CMAKE_CURRENT_LIST_DIR}/../cmake")
        find_package(TSServerSdk REQUIRED)
        message("TSServerSdk_FOUND: ${TSServerSdk_FOUND}")
        message("TSServerSdk_INCLUDE_DIRS: ${TSServerSdk_INCLUDE_DIRS}")
        message("TSServerSdk_LIBRARIES: ${TSServerSdk_LIBRARIES}")
        target_include_directories(${ts_sample_bin} PUBLIC ${TSServerSdk_INCLUDE_DIRS})
        target_link_libraries(${ts_sample_bin} "${TSServerSdk_LIBRARIES}")
    else()
        message("example type not specified.")
    endif()

    if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
        set_target_properties(${ts_sample_bin}
            PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${ts_sample_bin}/lib"
            LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${ts_sample_bin}/lib"
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${ts_sample_bin}/bin"
        )
    else()
        set_target_properties(${ts_sample_bin}
            PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${ts_sample_bin}/lib"
            LIBRARY_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${ts_sample_bin}/lib"
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${ts_sample_bin}/bin"
        )
    endif()

    if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
        if ("${sample_type}" STREQUAL "client")
            add_custom_command(TARGET ${ts_sample_bin} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/../bin/windows/win64/ts3client.dll $<TARGET_FILE_DIR:${ts_sample_bin}>/.
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/../bin/windows/win64/soundbackends $<TARGET_FILE_DIR:${ts_sample_bin}>/soundbackends
            )
        elseif("${sample_type}" STREQUAL "server")
            add_custom_command(TARGET ${ts_sample_bin} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_SOURCE_DIR}/../bin/windows/win64/ts3server.dll $<TARGET_FILE_DIR:${ts_sample_bin}>/.
            )
        endif()
    elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
        target_link_libraries(${ts_sample_bin} dl)
        if ("${sample_type}" STREQUAL "client")
            add_custom_command(TARGET ${ts_sample_bin} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/../bin/linux/amd64/libts3client.so $<TARGET_FILE_DIR:${ts_sample_bin}>/.
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/../bin/linux/amd64/soundbackends $<TARGET_FILE_DIR:${ts_sample_bin}>/soundbackends
            )
        elseif("${sample_type}" STREQUAL "server")
            add_custom_command(TARGET ${ts_sample_bin} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_SOURCE_DIR}/../bin/linux/amd64/libts3server.so $<TARGET_FILE_DIR:${ts_sample_bin}>/.
            )
        endif()
    endif()

endforeach()
# hack to create a specified visual studio solution
project("TeamSpeak SDK Samples" NONE)
