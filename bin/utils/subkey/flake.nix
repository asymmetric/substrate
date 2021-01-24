{
  description = "subkey tool";

  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.rust-overlay = {
    url = github:oxalica/rust-overlay;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay }: {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; overlays = [ rust-overlay.overlay ]; };

      (makeRustPlatform {
        rustc = rust-bin.nightly.latest.rust;
        cargo = rust-bin.nightly.latest.cargo;
      }).buildRustPackage {
        pname = "subkey";
        version = "2.0.0";

        src = self;

        cargoSha256 = "sha256-+t2B3Kg9htMbrhjd4dNEE0RbC4GoWujTbUp2bPZjFrw=";
        LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
        PROTOC = "${protobuf}/bin/protoc";
        BUILD_DUMMY_WASM_BINARY = 1;

        nativeBuildInputs = [ clang pkg-config ];
        buildInputs = [ openssl ];
      };
  };
}
