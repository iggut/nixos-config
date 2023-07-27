_: {
  services.syncthing = {
    enable = false;
    extraOptions = [
      "-gui-address=gaminix.tailnet-d5da.ts.net:8384"
      "-home=/home/iggut/data/.syncthing"
    ];
  };
}
