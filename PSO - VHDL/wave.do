onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_particle_update/CLK
add wave -noupdate /tb_particle_update/RESET
add wave -noupdate /tb_particle_update/en
add wave -noupdate /tb_particle_update/current_pos
add wave -noupdate /tb_particle_update/current_velocity
add wave -noupdate /tb_particle_update/best_personal_pos
add wave -noupdate /tb_particle_update/best_global_pos
add wave -noupdate /tb_particle_update/r1
add wave -noupdate /tb_particle_update/r2
add wave -noupdate /tb_particle_update/c1
add wave -noupdate /tb_particle_update/c2
add wave -noupdate /tb_particle_update/w
add wave -noupdate /tb_particle_update/new_pos
add wave -noupdate /tb_particle_update/new_velocity
add wave -noupdate /tb_particle_update/finish
add wave -noupdate /tb_particle_update/v0
add wave -noupdate /tb_particle_update/v1
add wave -noupdate /tb_particle_update/v2
add wave -noupdate /tb_particle_update/v3
add wave -noupdate /tb_particle_update/p0
add wave -noupdate /tb_particle_update/p1
add wave -noupdate /tb_particle_update/p2
add wave -noupdate /tb_particle_update/p3
add wave -noupdate -label r1_0 -radix unsigned {/tb_particle_update/L0/r1(19 downto 0)}
add wave -noupdate -label r1_1 -radix unsigned {/tb_particle_update/L0/r1(39 downto 20)}
add wave -noupdate -label r1_2 -radix unsigned {/tb_particle_update/L0/r1(59 downto 40)}
add wave -noupdate -label r1_3 -radix unsigned {/tb_particle_update/L0/r1(79 downto 60)}
add wave -noupdate -label r2_0 -radix unsigned {/tb_particle_update/L0/r2(19 downto 0)}
add wave -noupdate -label r2_1 -radix unsigned {/tb_particle_update/L0/r2(39 downto 20)}
add wave -noupdate -label r2_2 -radix unsigned {/tb_particle_update/L0/r2(59 downto 40)}
add wave -noupdate -label r2_3 -radix unsigned {/tb_particle_update/L0/r2(79 downto 60)}
add wave -noupdate /tb_particle_update/L0/state
add wave -noupdate -label aux1_0 -radix decimal {/tb_particle_update/L0/aux1(31 downto 0)}
add wave -noupdate -label aux1_1 -radix decimal {/tb_particle_update/L0/aux1(63 downto 32)}
add wave -noupdate -label aux1_2 -radix decimal {/tb_particle_update/L0/aux1(95 downto 64)}
add wave -noupdate -label aux1_3 -radix decimal {/tb_particle_update/L0/aux1(127 downto 96)}
add wave -noupdate -label aux20_0 -radix decimal {/tb_particle_update/L0/aux20(31 downto 0)}
add wave -noupdate -label aux20_1 -radix decimal {/tb_particle_update/L0/aux20(63 downto 32)}
add wave -noupdate -label aux20_2 -radix decimal {/tb_particle_update/L0/aux20(95 downto 64)}
add wave -noupdate -label aux20_3 -radix decimal {/tb_particle_update/L0/aux20(127 downto 96)}
add wave -noupdate -label aux2_0 -radix decimal {/tb_particle_update/L0/aux2(31 downto 0)}
add wave -noupdate -label aux2_1 -radix decimal {/tb_particle_update/L0/aux2(63 downto 32)}
add wave -noupdate -label aux2_2 -radix decimal {/tb_particle_update/L0/aux2(95 downto 64)}
add wave -noupdate -label aux2_3 -radix decimal {/tb_particle_update/L0/aux2(127 downto 96)}
add wave -noupdate -label aux30_0 -radix decimal {/tb_particle_update/L0/aux30(31 downto 0)}
add wave -noupdate -label aux30_1 -radix decimal {/tb_particle_update/L0/aux30(63 downto 32)}
add wave -noupdate -label aux30_2 -radix decimal {/tb_particle_update/L0/aux30(95 downto 64)}
add wave -noupdate -label aux30_3 -radix decimal {/tb_particle_update/L0/aux30(127 downto 96)}
add wave -noupdate -label aux3_0 -radix decimal {/tb_particle_update/L0/aux3(31 downto 0)}
add wave -noupdate -label aux3_1 -radix decimal {/tb_particle_update/L0/aux3(63 downto 32)}
add wave -noupdate -label aux3_2 -radix decimal {/tb_particle_update/L0/aux3(95 downto 64)}
add wave -noupdate -label aux3_3 -radix decimal {/tb_particle_update/L0/aux3(127 downto 96)}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {853443 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {913500 ps}
