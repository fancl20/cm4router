{ lib
, clang
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "dae";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = pname;
    rev = "e04b16fdea70f38f8e3dd6637a8bb38739cd8baa";
    hash = "sha256-0kIBINHEkMB574TadHCdAjA/BS+wFUbt9RK+qMSe5JY";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-LaR7SO1PDla/ipFUcCVqpJUHQAWEDjv9F1mJbMk8KVo=";

  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/daeuniverse/dae/cmd.Version=${version}"
    "-X github.com/daeuniverse/dae/common/consts.MaxMatchSetLen_=64"
  ];

  preBuild = ''
    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
    NOSTRIP=y \
    ebpf
  '';

  # network required
  doCheck = false;

  postInstall = ''
    install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
    substituteInPlace $out/lib/systemd/system/dae.service \
      --replace /usr/bin/dae $out/bin/dae
  '';

  meta = with lib; {
    description = "A Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    mainProgram = "dae";
  };
}
