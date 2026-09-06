{ config, pkgs, ... }:
let
  mountPoint = "${config.home.homeDirectory}/OneDrive";
  rcloneConfig = "${config.home.homeDirectory}/.config/rclone/rclone.conf";
  cacheDir = "${config.home.homeDirectory}/.cache/rclone-onedrive";
in {
  # OneDrive for Business (tsukasa-ind.co.jp) を ~/OneDrive にFUSEマウントする。
  #
  # 前提条件（Nixコード側では関与しない、事前に手動実行が必要）:
  #   `rclone config` を対話実行し、remote名 "onedrive" で OAuth2 認証を完了させておくこと。
  #   認証済みの rclone.conf は ~/.config/rclone/rclone.conf にそのまま置かれる
  #   （home-manager の home.file 等では一切管理しない。機密情報のため Nix store には焼き込まない）。
  #
  # 実装上の注意点（社内Wiki `/knowledge/ネットワーク・運用関連/docker/CIFSマウント` の知見を反映）:
  #   - `--daemon` は使わない。rcloneプロセスをforeground実行し、サービス停止時に
  #     systemdからのSIGTERMをrclone本体が直接受け取ってアンマウントできるようにする。
  #     `--daemon` でフォーク・デタッチすると、シグナルがマウントを維持する子プロセスに
  #     届かず、停止時にFUSEマウントの残骸が残り "Transport endpoint is not connected" になる。
  #   - systemdユニットにはPATH/HOMEが渡らない場合があるため、--config と --cache-dir は
  #     絶対パスに展開して渡す（~展開に依存しない）。
  systemd.user.services.rclone-onedrive = {
    Unit = {
      Description = "rclone mount: OneDrive for Business (tsukasa-ind.co.jp)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mountPoint}";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount onedrive: ${mountPoint} \
          --config ${rcloneConfig} \
          --cache-dir ${cacheDir} \
          --vfs-cache-mode writes
      '';
      # rcloneはSIGTERMを受けて自発的にアンマウントするが、失敗時の保険としてfusermount3も実行する。
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u ${mountPoint}";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
