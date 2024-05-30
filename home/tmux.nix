# tmux.nix
{ config, pkgs, ... }:
let 

	tmux-save = pkgs.writeShellScriptBin "tmux-save" ''
# scripts/tmux-save.sh
#!/usr/bin/env bash

SAVE_SH=${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh

if [ "$(pgrep tmux)" ]; then
  $SAVE_SH quiet
fi

	'';
in
{
	home.packages = [
		tmux-save
	];

	systemd.user.services.tmux-autosave = {
		Unit = {
			Description = "Run tmux_resurrect save script every 15 minutes";
			OnFailure = "error@%n.service";
		};
		Service = {
			Type = "oneshot";
			Environment = [ ];
			ExecStart = "tmux-save";
		};
	};
	systemd.user.timers.tmux-autosave = {
		Unit = {
			Description = "Run tmux_resurrect save script every 15 minutes";
		};
		Timer = {
			OnBootSec = "5min";
			OnUnitActiveSec = "15min";
			Unit = "tmux-autosave.service";
		};
		Install = {
			WantedBy = [ "timers.target" ];
		};
	};

}
