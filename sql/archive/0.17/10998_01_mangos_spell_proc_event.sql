ALTER TABLE db_version CHANGE COLUMN required_10993_01_mangos_loot_template required_10998_01_mangos_spell_proc_event bit;

DELETE FROM spell_proc_event WHERE entry IN (64440, 71564);
INSERT INTO spell_proc_event VALUES
(71564, 0x7F,  0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000002, 0.000000, 0.000000,  0),
(64440, 0x7F,  0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000020, 0.000000, 0.000000,  0);