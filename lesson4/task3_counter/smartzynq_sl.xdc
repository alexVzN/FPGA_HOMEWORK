# Smart ZYNQ SL rev 1.3B (XC7Z020-CLG484) — піни зі схеми
# docs/SmartZynq_SL_Schematic_V1d3.pdf (стор. 6, 9, 11).
# УВАГА: імена в get_ports мають збігатися з портами ВАШОГО top-модуля —
# перейменуйте під себе. Зайві рядки закоментуйте, інакше Vivado
# видасть помилку про констрейнт на неіснуючий порт.

# Тактовий генератор PL: 50 МГц на піні M19 (період 20 нс)
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 20.000 -name clk_50 [get_ports clk]

# Світлодіоди (активний ВИСОКИЙ рівень)
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports {led[1]}]

# Кнопки: підтягнуті до 3.3V через 47k, натискання замикає на GND
# => АКТИВНИЙ НИЗЬКИЙ рівень (натиснута кнопка = 0). Врахуйте це,
# якщо KEY1 буде вашим reset.
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports key1]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports key2]
