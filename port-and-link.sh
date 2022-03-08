system_compiler_dir="/usr/lib/gcc/x86_64-linux-gnu/9"
rts_dir="${PWD}/zfp_rts"
 
for f in "ada.ads" "a-unccon.ads" "a-uncdea.ads" "gnat.ads" "g-souinf.ads" \
"interfac.ads" "s-atacco.adb" "s-atacco.ads" "s-maccod.ads" "s-stoele.adb" \
"s-stoele.ads"
do
	cp "${system_compiler_dir}/adainclude/$f" "${rts_dir}/src/"
	ln -s "${rts_dir}/src/$f" "${rts_dir}/build/adainclude/$f"
done
