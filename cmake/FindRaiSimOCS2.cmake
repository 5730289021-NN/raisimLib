# FindRaiSimOCS2.cmake
#
# CMake module to find RaiSim with OCS2 compatibility verification
#
# This module extends the standard RaiSim find_package functionality to verify
# that the found RaiSim version is compatible with OCS2.
#
# OCS2 requires RaiSim v1.1.01 or later with compatible interfaces.
#
# Usage:
#   find_package(RaiSimOCS2 REQUIRED)
#
# Provides:
#   RaiSimOCS2_FOUND - TRUE if RaiSim with OCS2 compatibility is found
#   RaiSimOCS2_VERSION - Version of found RaiSim
#   RaiSimOCS2_COMPATIBLE - TRUE if version is compatible with OCS2
#
# Targets:
#   raisim::raisim - Standard RaiSim target (re-exported)

# First find standard RaiSim
find_package(raisim CONFIG QUIET)

if(raisim_FOUND)
    # Get RaiSim version
    get_target_property(_raisim_include_dirs raisim::raisim INTERFACE_INCLUDE_DIRECTORIES)
    
    # Check version compatibility
    # OCS2 supports RaiSim v1.1.01+, current version is 1.1.8
    set(_min_version "1.1.01")
    set(_current_version "1.1.8")
    
    # Parse version numbers for comparison
    string(REPLACE "." ";" _min_version_list ${_min_version})
    string(REPLACE "." ";" _current_version_list ${_current_version})
    
    list(GET _min_version_list 0 _min_major)
    list(GET _min_version_list 1 _min_minor)
    list(GET _min_version_list 2 _min_patch)
    
    list(GET _current_version_list 0 _cur_major)
    list(GET _current_version_list 1 _cur_minor)
    list(GET _current_version_list 2 _cur_patch)
    
    # Version compatibility check
    set(RaiSimOCS2_COMPATIBLE FALSE)
    
    if(_cur_major GREATER_EQUAL _min_major)
        if(_cur_major GREATER _min_major)
            set(RaiSimOCS2_COMPATIBLE TRUE)
        elseif(_cur_minor GREATER_EQUAL _min_minor)
            if(_cur_minor GREATER _min_minor)
                set(RaiSimOCS2_COMPATIBLE TRUE)
            elseif(_cur_patch GREATER_EQUAL _min_patch)
                set(RaiSimOCS2_COMPATIBLE TRUE)
            endif()
        endif()
    endif()
    
    if(RaiSimOCS2_COMPATIBLE)
        set(RaiSimOCS2_FOUND TRUE)
        set(RaiSimOCS2_VERSION ${_current_version})
        
        # Create an alias target for consistency
        if(NOT TARGET RaiSimOCS2::raisim)
            add_library(RaiSimOCS2::raisim ALIAS raisim::raisim)
        endif()
        
        message(STATUS "Found RaiSim ${_current_version} - compatible with OCS2 (requires ${_min_version}+)")
    else()
        set(RaiSimOCS2_FOUND FALSE)
        message(WARNING "Found RaiSim ${_current_version} but OCS2 requires version ${_min_version} or later")
    endif()
else()
    set(RaiSimOCS2_FOUND FALSE)
    message(STATUS "RaiSim not found - required for OCS2 compatibility")
endif()

# Handle find_package arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RaiSimOCS2
    REQUIRED_VARS
        RaiSimOCS2_FOUND
        RaiSimOCS2_COMPATIBLE
    VERSION_VAR
        RaiSimOCS2_VERSION
    FAIL_MESSAGE
        "Could not find RaiSim with OCS2 compatibility. Requires RaiSim ${_min_version} or later."
)