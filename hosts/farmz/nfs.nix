{ config, pkgs, ...}:
{
	services.nfs.server.enable = true;
	services.nfs.server.exports = ''
/export  192.168.1.0/24 (insecure,rw,sync,no_subtree_check,crossmnt,fsid=0)
	'';
	networking.firewall.allowedTCPPorts = [2049];

	fileSystems."/export/EEGEyeNet" = {
		device = "/home/ed/EEGEyeNet";
		options = [ "bind" ];
	};
}
