{ ... }: {
  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=100.64.118.39:8384"
      "-home=/home/jon/data/.syncthing"
    ];
  };
}