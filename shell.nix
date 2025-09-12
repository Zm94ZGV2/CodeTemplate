{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  pname = "vulkan-devshell";
  # paket untuk build + toolchain vulkan/grafis
  buildInputs = with pkgs; [
    cmake
    ninja
    pkg-config
    gcc
    clang

    # Vulkan core pieces (headers, loader, tools, validation layers)
    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers

    # shader toolchain
    shaderc        # menyediakan glslc / libshaderc
    glslang
    spirv-tools

    # windowing / helper libs (pilih sesuai engine kamu)
    glfw
    sdl3
  ];

  nativeBuildInputs = with pkgs; [
    git
  ];

  # optional: environment tweaks supaya cmake/find-vulkan lebih mudah menemukan SDK-like layout
  shellHook = ''
    # tunjukkan info saat masuk shell
    echo "Entered Vulkan devshell"

    # beberapa proyek expect VULKAN_SDK; set ke headers path (bisa disesuaikan)
    export VULKAN_SDK=${pkgs.vulkan-headers}

    # jika perlu override ICD (driver) file path, set VK_ICD_FILENAMES ke direktori icd.d
    # (driver vendor biasanya menaruh .json icd di /run/opengl-driver/share/vulkan/icd.d or in package share)
    # contoh (bisa di-comment kalau tidak perlu):
    # export VK_ICD_FILENAMES=${pkgs.vulkan-loader}/share/vulkan/icd.d

    # tambahkan bin glslc / vulkan tools ke PATH (seharusnya sudah otomatis via buildInputs)
    export PATH=$PATH:${pkgs.shaderc}/bin:${pkgs.vulkan-tools}/bin

    # print sedikit info
    command -v glslc >/dev/null 2>&1 && echo "glslc available: $(glslc --version 2>/dev/null | head -n1)"
    command -v vulkaninfo >/dev/null 2>&1 && echo "vulkaninfo available"
  '';
}
