{
  description = "Dev environment for pnpm + Node";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        nodejs_24
        pnpm
        gemini-cli
        # effectively an alias to pn
        (pkgs.writeShellScriptBin "pn" ''
          exec pnpm "$@"
        '')
      ];

      shellHook = ''
        echo "[direnv] Nix dev shell activated"
        echo "Node:  $(node --version 2>/dev/null || echo 'not found')"
        echo "pnpm:  $(pnpm --version 2>/dev/null || echo 'not found')"
      '';
    };
  };
}
