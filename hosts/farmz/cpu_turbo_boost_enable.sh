if [[ -z $(which rdmsr) ]]; then 
	echo "msr-tools is missing" >&2
	exit 1
fi

cores=$(cat /proc/cpuinfo | grep processor | awk '{print $3}')
for core in $cores; do
	wrmsr -p${core} 0x1a0 0x850089
	echo 0 | tee /sys/devices/system/cpu/intel_pstate/no_turbo

	state=$(rdmsr -p${core} 0x1a0 -f 38:38)
	if [[ $state -eq 1 ]]; then
		echo "core ${core}: disabled"
	else
		echo "core ${core}: enabled"
	fi
done
