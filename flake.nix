{
  description = "Collection of yazi plugins";

  inputs = {
    nix-lib.url = "github:ekala-project/nix-lib";

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    glow = {
      url = "github:Reledia/glow.yazi";
      flake = false;
    };
    miller = {
      url = "github:Reledia/miller.yazi";
      flake = false;
    };
    exifaudio = {
      url = "github:Sonico98/exifaudio.yazi";
      flake = false;
    };
    hexyl = {
      url = "github:Reledia/hexyl.yazi";
      flake = false;
    };
    mdcat = {
      url = "github:GrzegorzKozub/mdcat.yazi";
      flake = false;
    };
    mediainfo = {
      url = "github:boydaihungst/mediainfo.yazi";
      flake = false;
    };
    lazygit = {
      url = "github:Lil-Dank/lazygit.yazi";
      flake = false;
    };
    starship = {
      url = "github:Rolv-Apneseth/starship.yazi";
      flake = false;
    };
    what-size = {
      url = "github:pirafrank/what-size.yazi";
      flake = false;
    };
  };

  outputs = inputs @ {
    nix-lib,
    yazi-plugins,
    ...
  }: let
    lib = nix-lib.lib;
    yazi_plugins_name_list = lib.filterAttrs (name: ty: ty == "directory" && (lib.hasSuffix ".yazi" name)) (builtins.readDir yazi-plugins);
    yazi_plugins_list = builtins.listToAttrs (builtins.map ({name, ...}: {
      name = builtins.replaceStrings [".yazi"] [""] name;
      value = builtins.toPath "${yazi-plugins}/${name}";
    }) (lib.attrsToList yazi_plugins_name_list));

    external_plugins_list = builtins.listToAttrs (builtins.map (name: {
      inherit name;
      value = inputs.${name}.outPath;
    }) ["glow" "miller" "exifaudio" "hexyl" "mdcat" "mediainfo" "lazygit" "starship" "what-size"]);
  in (yazi_plugins_list // external_plugins_list);
}
