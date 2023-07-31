_: {
  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=gs66.tailnet-d5da.ts.net:8384"
      "-home=/home/iggut/data/.syncthing"
    ];
  };
}
