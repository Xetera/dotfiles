{
  enable = true;
  overrideDevices = true;
  overrideFolders = true;

  settings = {
    devices = {
      "android" = {
        id = "3XF6A5F-CYLDFAV-O7TJGYF-44BWU66-SX4RSXZ-752G362-SCYCF5X-6XJFMAU";
      };
    };
    folders = {
      "obsidian" = {
        id = "obsidian";
        # syncthing filewatcher does not work on fucking macos for some reason
        fsWatcherEnabled = true;
        rescanIntervalS = 5;
        path = "/Users/xetera/Obsidian";
        devices = [ "android" ];
      };
    };
  };
}
