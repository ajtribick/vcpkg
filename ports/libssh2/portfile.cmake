vcpkg_download_distfile(LIBSSH2_CVE_2026_58051_PATCH
    URLS https://github.com/libssh2/libssh2/commit/a9758da45a52bc8c630ec9493804d0c6ea30b24a.patch?full_index=1
    FILENAME libssh2-a9758da.patch
    SHA512 ffbb2ad956f178d5a7cbe6c338d661dc9fa7db96e49176cddfb6701c7eea36a6608e989dc6eb10d774f25d83338aeec0c24ef906b10cc963c5cb6ec5ed925a2a
)

vcpkg_download_distfile(LIBSSH2_CVE_2026_55199_PATCH
    URLS https://github.com/libssh2/libssh2/commit/17626857d20b3c9a1addfa45979dadcee1cd84a4.patch?full_index=1
    FILENAME libssh2-1762685.patch
    SHA512 14d0f94e9b3544f2c9b5ef528447f3eeba7e2a3a716cf93a36b32ceecba54f3b4d2b3807928a841db8f1f9b22f81b246c955fadc569061230a5c9c21feb7e54a
)

vcpkg_download_distfile(LIBSSH2_STRING_BUF_PATCH
    URLS https://github.com/libssh2/libssh2/commit/606c102e52f8447de2b745dd6c5ddf418defc519.patch?full_index=1
    FILENAME libssh2-606c102.patch
    SHA512 f0e02c087c9ea07f0f40e242554ab5924703be02f19126bf3d0151860671dd2fb6ada1d02e540a8f1681d16b315cbf819f03f0a41bfc6502bdb806b135d765e5
)

vcpkg_download_distfile(LIBSSH2_SFTP_SYMLINK_PATCH
    URLS https://github.com/libssh2/libssh2/commit/4ed26f5740bdd409269ed9fb48a28bf8f565b681.patch?full_index=1
    FILENAME libssh2-sftp-symlink.patch
    SHA512 5bc8a333cfdb0aaa9003daa315aea4306096ab0afbfc6541ce8643369a9bb8376dc176b54d2b0ef85007c3a503269d2b61cecbabb658a2a5493f5590696677fc
)

vcpkg_download_distfile(LIBSSH2_CVE_2026_66033_PATCH
    URLS https://github.com/libssh2/libssh2/commit/a2ed82d40964bbc0d64cd717aa0a5a892117d2e6.patch?full_index=1
    FILENAME libssh2-a2ed82d.patch
    SHA512 0c0c2c61f2f26b5bdf9224b59d4926887d7697e7b8433ea93691469f4f8a3b6ddeef8575ada7cc3e33e1e51e0e921875c0493a2602a9c415d5cdceb5fc2fe2d3
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libssh2/libssh2
    REF "libssh2-${VERSION}"
    SHA512 616efcd7f5c1fb1046104ebce70549e4756e2a55150efa2df5bb7123051d3bf336023cedcbfe932cd7c690a0b4d1f1a93c760ea39f1dba50c2b06d0945dca958
    HEAD_REF master
    PATCHES
        cmake-config.diff
        pkgconfig.diff
        CVE-2026-7598-256d04b-applied.diff
        CVE-2026-7598-2fedc0b-applied.diff
        CVE-2026-7598-338f4e5-applied.diff
        CVE-2026-7598-7b1fdaa-applied.diff
        ${LIBSSH2_CVE_2026_58051_PATCH}
        CVE-2026-58050-3449752-applied.diff
        CVE-2026-55200-97acf3d-applied.diff
        ${LIBSSH2_CVE_2026_55199_PATCH}
        ${LIBSSH2_STRING_BUF_PATCH} # required for CVE-2025-15661 fix
        CVE-2025-15661-2dae302-applied.diff
        ${LIBSSH2_SFTP_SYMLINK_PATCH}
        CVE-2026-66032-5e47761-applied.diff
        ${LIBSSH2_CVE_2026_66033_PATCH}
        CVE-2026-66034-a13bb6c-applied.diff
        CVE-2026-66035-42e33d8-applied.diff
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        zlib    ENABLE_ZLIB_COMPRESSION
)
if("openssl" IN_LIST FEATURES)
    list(APPEND FEATURE_OPTIONS "-DCRYPTO_BACKEND=OpenSSL")
elseif(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND FEATURE_OPTIONS "-DCRYPTO_BACKEND=WinCNG")
else()
    message(FATAL_ERROR "Port ${PORT} only supports OpenSSL and WinCNG crypto backends.")
endif()
if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    list(APPEND FEATURE_OPTIONS "-DBUILD_STATIC_LIBS:BOOL=OFF")
endif()

vcpkg_find_acquire_program(PKGCONFIG)
set(ENV{PKG_CONFIG} "${PKGCONFIG}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_DEBUG_LOGGING=OFF
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libssh2)

vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libssh2.h"
    "1.11.1_DEV"
    "${VERSION}"
)
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libssh2.pc"
    "1.11.1_DEV"
    "${VERSION}"
)
if(NOT VCPKG_BUILD_TYPE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libssh2.pc"
        "1.11.1_DEV"
        "${VERSION}"
    )
endif()

if (VCPKG_TARGET_IS_WINDOWS)
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libssh2.h" "defined(_WINDLL)" "1")
    endif()
    if(VCPKG_TARGET_STATIC_LIBRARY_PREFIX STREQUAL "")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libssh2.pc" " -lssh2" " -llibssh2")
        if(NOT VCPKG_BUILD_TYPE)
            vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libssh2.pc" " -lssh2" " -llibssh2")
        endif()
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/man")

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
