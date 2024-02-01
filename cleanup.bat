@echo off
rmdir qdb tmp-clearbox software DNI /s /q
rmdir .qsys_edit ip hil_sys /s /q
del *.rpt *.sof *.summary *.smsg *.pin *~ /s
del *.qsf *.qpf *.qws *.v *.sv *.sdc *.done *.qsys /s
del *.cdf *.sld *.qarlog *.legacy *.log *.rec /s
del *.json *.qdf *.xml *.ini #*# /s
del serv_req_info.txt


