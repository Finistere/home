self: super:

let
  unstable = import <nixos-unstable> { overlays = []; };
in {
  brabier = {
    pycharm = unstable.jetbrains.pycharm-professional.override {
      jdk = unstable.jetbrains.jdk;
    };
    intellij = unstable.jetbrains.idea-ultimate.override {
      jdk = unstable.jetbrains.jdk;
    };
  };
}
