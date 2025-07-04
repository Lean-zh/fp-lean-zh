// Lean compiler output
// Module: FPLeanZh.Examples.Commands.ShLex
// Imports: Init
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__3;
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__8;
lean_object* lean_array_push(lean_object*, lean_object*);
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__7;
LEAN_EXPORT lean_object* l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_FPLeanZh_Commands_Shell_shlex___lambda__1___boxed(lean_object*, lean_object*);
lean_object* lean_string_utf8_byte_size(lean_object*);
lean_object* lean_string_push(lean_object*, uint32_t);
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__5;
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__6;
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__1;
static lean_object* l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
uint32_t lean_string_utf8_get_fast(lean_object*, lean_object*);
static lean_object* l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
LEAN_EXPORT lean_object* l_FPLeanZh_Commands_Shell_shlex___lambda__1(lean_object*, lean_object*);
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__4;
LEAN_EXPORT lean_object* l_FPLeanZh_Commands_Shell_shlex(lean_object*);
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__2;
static lean_object* l_FPLeanZh_Commands_Shell_shlex___closed__9;
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
uint8_t lean_uint32_dec_eq(uint32_t, uint32_t);
lean_object* lean_string_utf8_next_fast(lean_object*, lean_object*);
lean_object* lean_array_mk(lean_object*);
static lean_object* _init_l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("", 0, 0);
return x_1;
}
}
static lean_object* _init_l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_2 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_10; uint8_t x_11; 
x_10 = lean_ctor_get(x_2, 1);
lean_inc(x_10);
x_11 = !lean_is_exclusive(x_10);
if (x_11 == 0)
{
uint8_t x_12; 
x_12 = !lean_is_exclusive(x_2);
if (x_12 == 0)
{
lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16; uint8_t x_17; 
x_13 = lean_ctor_get(x_10, 1);
x_14 = lean_ctor_get(x_10, 0);
x_15 = lean_ctor_get(x_2, 0);
x_16 = lean_ctor_get(x_2, 1);
lean_dec(x_16);
x_17 = !lean_is_exclusive(x_13);
if (x_17 == 0)
{
lean_object* x_18; lean_object* x_19; lean_object* x_20; lean_object* x_21; lean_object* x_22; uint8_t x_23; 
x_18 = lean_ctor_get(x_13, 0);
x_19 = lean_ctor_get(x_13, 1);
x_20 = lean_ctor_get(x_14, 0);
lean_inc(x_20);
x_21 = lean_ctor_get(x_14, 1);
lean_inc(x_21);
x_22 = lean_string_utf8_byte_size(x_20);
x_23 = lean_nat_dec_lt(x_21, x_22);
lean_dec(x_22);
if (x_23 == 0)
{
lean_object* x_24; 
lean_dec(x_21);
lean_dec(x_20);
x_24 = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(x_24, 0, x_2);
x_3 = x_24;
goto block_9;
}
else
{
uint8_t x_25; 
x_25 = !lean_is_exclusive(x_14);
if (x_25 == 0)
{
lean_object* x_26; lean_object* x_27; uint32_t x_28; lean_object* x_29; 
x_26 = lean_ctor_get(x_14, 1);
lean_dec(x_26);
x_27 = lean_ctor_get(x_14, 0);
lean_dec(x_27);
x_28 = lean_string_utf8_get_fast(x_20, x_21);
x_29 = lean_string_utf8_next_fast(x_20, x_21);
lean_dec(x_21);
lean_ctor_set(x_14, 1, x_29);
switch (lean_obj_tag(x_19)) {
case 0:
{
uint32_t x_30; uint8_t x_31; 
x_30 = 92;
x_31 = lean_uint32_dec_eq(x_28, x_30);
if (x_31 == 0)
{
uint32_t x_32; uint8_t x_33; 
x_32 = 39;
x_33 = lean_uint32_dec_eq(x_28, x_32);
if (x_33 == 0)
{
uint32_t x_34; uint8_t x_35; 
x_34 = 34;
x_35 = lean_uint32_dec_eq(x_28, x_34);
if (x_35 == 0)
{
uint32_t x_36; uint8_t x_37; 
x_36 = 32;
x_37 = lean_uint32_dec_eq(x_28, x_36);
if (x_37 == 0)
{
uint32_t x_38; uint8_t x_39; 
x_38 = 9;
x_39 = lean_uint32_dec_eq(x_28, x_38);
if (x_39 == 0)
{
uint32_t x_40; uint8_t x_41; 
x_40 = 10;
x_41 = lean_uint32_dec_eq(x_28, x_40);
if (x_41 == 0)
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_42; lean_object* x_43; lean_object* x_44; lean_object* x_45; 
x_42 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_43 = lean_string_push(x_42, x_28);
x_44 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_44, 0, x_43);
lean_ctor_set(x_2, 0, x_44);
x_45 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_45, 0, x_2);
x_3 = x_45;
goto block_9;
}
else
{
uint8_t x_46; 
x_46 = !lean_is_exclusive(x_15);
if (x_46 == 0)
{
lean_object* x_47; lean_object* x_48; lean_object* x_49; 
x_47 = lean_ctor_get(x_15, 0);
x_48 = lean_string_push(x_47, x_28);
lean_ctor_set(x_15, 0, x_48);
x_49 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_49, 0, x_2);
x_3 = x_49;
goto block_9;
}
else
{
lean_object* x_50; lean_object* x_51; lean_object* x_52; lean_object* x_53; 
x_50 = lean_ctor_get(x_15, 0);
lean_inc(x_50);
lean_dec(x_15);
x_51 = lean_string_push(x_50, x_28);
x_52 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_52, 0, x_51);
lean_ctor_set(x_2, 0, x_52);
x_53 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_53, 0, x_2);
x_3 = x_53;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_54; 
x_54 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_54, 0, x_2);
x_3 = x_54;
goto block_9;
}
else
{
lean_object* x_55; lean_object* x_56; lean_object* x_57; 
x_55 = lean_ctor_get(x_15, 0);
lean_inc(x_55);
lean_dec(x_15);
x_56 = lean_array_push(x_18, x_55);
lean_ctor_set(x_13, 0, x_56);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_57 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_57, 0, x_2);
x_3 = x_57;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_58; 
x_58 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_58, 0, x_2);
x_3 = x_58;
goto block_9;
}
else
{
lean_object* x_59; lean_object* x_60; lean_object* x_61; 
x_59 = lean_ctor_get(x_15, 0);
lean_inc(x_59);
lean_dec(x_15);
x_60 = lean_array_push(x_18, x_59);
lean_ctor_set(x_13, 0, x_60);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_61 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_61, 0, x_2);
x_3 = x_61;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_62; 
x_62 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_62, 0, x_2);
x_3 = x_62;
goto block_9;
}
else
{
lean_object* x_63; lean_object* x_64; lean_object* x_65; 
x_63 = lean_ctor_get(x_15, 0);
lean_inc(x_63);
lean_dec(x_15);
x_64 = lean_array_push(x_18, x_63);
lean_ctor_set(x_13, 0, x_64);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_65 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_65, 0, x_2);
x_3 = x_65;
goto block_9;
}
}
}
else
{
lean_object* x_66; 
x_66 = lean_box(2);
lean_ctor_set(x_13, 1, x_66);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_67; lean_object* x_68; 
x_67 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
lean_ctor_set(x_2, 0, x_67);
x_68 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_68, 0, x_2);
x_3 = x_68;
goto block_9;
}
else
{
uint8_t x_69; 
x_69 = !lean_is_exclusive(x_15);
if (x_69 == 0)
{
lean_object* x_70; 
x_70 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_70, 0, x_2);
x_3 = x_70;
goto block_9;
}
else
{
lean_object* x_71; lean_object* x_72; lean_object* x_73; 
x_71 = lean_ctor_get(x_15, 0);
lean_inc(x_71);
lean_dec(x_15);
x_72 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_72, 0, x_71);
lean_ctor_set(x_2, 0, x_72);
x_73 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_73, 0, x_2);
x_3 = x_73;
goto block_9;
}
}
}
}
else
{
lean_object* x_74; 
x_74 = lean_box(1);
lean_ctor_set(x_13, 1, x_74);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_75; lean_object* x_76; 
x_75 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
lean_ctor_set(x_2, 0, x_75);
x_76 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_76, 0, x_2);
x_3 = x_76;
goto block_9;
}
else
{
uint8_t x_77; 
x_77 = !lean_is_exclusive(x_15);
if (x_77 == 0)
{
lean_object* x_78; 
x_78 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_78, 0, x_2);
x_3 = x_78;
goto block_9;
}
else
{
lean_object* x_79; lean_object* x_80; lean_object* x_81; 
x_79 = lean_ctor_get(x_15, 0);
lean_inc(x_79);
lean_dec(x_15);
x_80 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_80, 0, x_79);
lean_ctor_set(x_2, 0, x_80);
x_81 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_81, 0, x_2);
x_3 = x_81;
goto block_9;
}
}
}
}
else
{
lean_object* x_82; lean_object* x_83; 
x_82 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_82, 0, x_19);
lean_ctor_set(x_13, 1, x_82);
x_83 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_83, 0, x_2);
x_3 = x_83;
goto block_9;
}
}
case 1:
{
uint32_t x_84; uint8_t x_85; 
x_84 = 39;
x_85 = lean_uint32_dec_eq(x_28, x_84);
if (x_85 == 0)
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_86; lean_object* x_87; lean_object* x_88; lean_object* x_89; 
x_86 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_87 = lean_string_push(x_86, x_28);
x_88 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_88, 0, x_87);
lean_ctor_set(x_2, 0, x_88);
x_89 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_89, 0, x_2);
x_3 = x_89;
goto block_9;
}
else
{
uint8_t x_90; 
x_90 = !lean_is_exclusive(x_15);
if (x_90 == 0)
{
lean_object* x_91; lean_object* x_92; lean_object* x_93; 
x_91 = lean_ctor_get(x_15, 0);
x_92 = lean_string_push(x_91, x_28);
lean_ctor_set(x_15, 0, x_92);
x_93 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_93, 0, x_2);
x_3 = x_93;
goto block_9;
}
else
{
lean_object* x_94; lean_object* x_95; lean_object* x_96; lean_object* x_97; 
x_94 = lean_ctor_get(x_15, 0);
lean_inc(x_94);
lean_dec(x_15);
x_95 = lean_string_push(x_94, x_28);
x_96 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_96, 0, x_95);
lean_ctor_set(x_2, 0, x_96);
x_97 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_97, 0, x_2);
x_3 = x_97;
goto block_9;
}
}
}
else
{
lean_object* x_98; lean_object* x_99; 
x_98 = lean_box(0);
lean_ctor_set(x_13, 1, x_98);
x_99 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_99, 0, x_2);
x_3 = x_99;
goto block_9;
}
}
case 2:
{
uint32_t x_100; uint8_t x_101; 
x_100 = 34;
x_101 = lean_uint32_dec_eq(x_28, x_100);
if (x_101 == 0)
{
uint32_t x_102; uint8_t x_103; 
x_102 = 92;
x_103 = lean_uint32_dec_eq(x_28, x_102);
if (x_103 == 0)
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_104; lean_object* x_105; lean_object* x_106; lean_object* x_107; 
x_104 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_105 = lean_string_push(x_104, x_28);
x_106 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_106, 0, x_105);
lean_ctor_set(x_2, 0, x_106);
x_107 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_107, 0, x_2);
x_3 = x_107;
goto block_9;
}
else
{
uint8_t x_108; 
x_108 = !lean_is_exclusive(x_15);
if (x_108 == 0)
{
lean_object* x_109; lean_object* x_110; lean_object* x_111; 
x_109 = lean_ctor_get(x_15, 0);
x_110 = lean_string_push(x_109, x_28);
lean_ctor_set(x_15, 0, x_110);
x_111 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_111, 0, x_2);
x_3 = x_111;
goto block_9;
}
else
{
lean_object* x_112; lean_object* x_113; lean_object* x_114; lean_object* x_115; 
x_112 = lean_ctor_get(x_15, 0);
lean_inc(x_112);
lean_dec(x_15);
x_113 = lean_string_push(x_112, x_28);
x_114 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_114, 0, x_113);
lean_ctor_set(x_2, 0, x_114);
x_115 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_115, 0, x_2);
x_3 = x_115;
goto block_9;
}
}
}
else
{
lean_object* x_116; lean_object* x_117; 
x_116 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_116, 0, x_19);
lean_ctor_set(x_13, 1, x_116);
x_117 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_117, 0, x_2);
x_3 = x_117;
goto block_9;
}
}
else
{
lean_object* x_118; lean_object* x_119; 
x_118 = lean_box(0);
lean_ctor_set(x_13, 1, x_118);
x_119 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_119, 0, x_2);
x_3 = x_119;
goto block_9;
}
}
default: 
{
uint8_t x_120; 
x_120 = !lean_is_exclusive(x_19);
if (x_120 == 0)
{
lean_object* x_121; 
x_121 = lean_ctor_get(x_19, 0);
lean_ctor_set(x_13, 1, x_121);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_122; lean_object* x_123; lean_object* x_124; 
x_122 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_123 = lean_string_push(x_122, x_28);
lean_ctor_set_tag(x_19, 1);
lean_ctor_set(x_19, 0, x_123);
lean_ctor_set(x_2, 0, x_19);
x_124 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_124, 0, x_2);
x_3 = x_124;
goto block_9;
}
else
{
uint8_t x_125; 
x_125 = !lean_is_exclusive(x_15);
if (x_125 == 0)
{
lean_object* x_126; lean_object* x_127; 
x_126 = lean_ctor_get(x_15, 0);
x_127 = lean_string_push(x_126, x_28);
lean_ctor_set(x_15, 0, x_127);
lean_ctor_set_tag(x_19, 1);
lean_ctor_set(x_19, 0, x_2);
x_3 = x_19;
goto block_9;
}
else
{
lean_object* x_128; lean_object* x_129; lean_object* x_130; 
x_128 = lean_ctor_get(x_15, 0);
lean_inc(x_128);
lean_dec(x_15);
x_129 = lean_string_push(x_128, x_28);
x_130 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_130, 0, x_129);
lean_ctor_set(x_2, 0, x_130);
lean_ctor_set_tag(x_19, 1);
lean_ctor_set(x_19, 0, x_2);
x_3 = x_19;
goto block_9;
}
}
}
else
{
lean_object* x_131; 
x_131 = lean_ctor_get(x_19, 0);
lean_inc(x_131);
lean_dec(x_19);
lean_ctor_set(x_13, 1, x_131);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_132; lean_object* x_133; lean_object* x_134; lean_object* x_135; 
x_132 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_133 = lean_string_push(x_132, x_28);
x_134 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_134, 0, x_133);
lean_ctor_set(x_2, 0, x_134);
x_135 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_135, 0, x_2);
x_3 = x_135;
goto block_9;
}
else
{
lean_object* x_136; lean_object* x_137; lean_object* x_138; lean_object* x_139; lean_object* x_140; 
x_136 = lean_ctor_get(x_15, 0);
lean_inc(x_136);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_137 = x_15;
} else {
 lean_dec_ref(x_15);
 x_137 = lean_box(0);
}
x_138 = lean_string_push(x_136, x_28);
if (lean_is_scalar(x_137)) {
 x_139 = lean_alloc_ctor(1, 1, 0);
} else {
 x_139 = x_137;
}
lean_ctor_set(x_139, 0, x_138);
lean_ctor_set(x_2, 0, x_139);
x_140 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_140, 0, x_2);
x_3 = x_140;
goto block_9;
}
}
}
}
}
else
{
uint32_t x_141; lean_object* x_142; lean_object* x_143; 
lean_dec(x_14);
x_141 = lean_string_utf8_get_fast(x_20, x_21);
x_142 = lean_string_utf8_next_fast(x_20, x_21);
lean_dec(x_21);
x_143 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_143, 0, x_20);
lean_ctor_set(x_143, 1, x_142);
switch (lean_obj_tag(x_19)) {
case 0:
{
uint32_t x_144; uint8_t x_145; 
x_144 = 92;
x_145 = lean_uint32_dec_eq(x_141, x_144);
if (x_145 == 0)
{
uint32_t x_146; uint8_t x_147; 
x_146 = 39;
x_147 = lean_uint32_dec_eq(x_141, x_146);
if (x_147 == 0)
{
uint32_t x_148; uint8_t x_149; 
x_148 = 34;
x_149 = lean_uint32_dec_eq(x_141, x_148);
if (x_149 == 0)
{
uint32_t x_150; uint8_t x_151; 
x_150 = 32;
x_151 = lean_uint32_dec_eq(x_141, x_150);
if (x_151 == 0)
{
uint32_t x_152; uint8_t x_153; 
x_152 = 9;
x_153 = lean_uint32_dec_eq(x_141, x_152);
if (x_153 == 0)
{
uint32_t x_154; uint8_t x_155; 
x_154 = 10;
x_155 = lean_uint32_dec_eq(x_141, x_154);
if (x_155 == 0)
{
lean_ctor_set(x_10, 0, x_143);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_156; lean_object* x_157; lean_object* x_158; lean_object* x_159; 
x_156 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_157 = lean_string_push(x_156, x_141);
x_158 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_158, 0, x_157);
lean_ctor_set(x_2, 0, x_158);
x_159 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_159, 0, x_2);
x_3 = x_159;
goto block_9;
}
else
{
lean_object* x_160; lean_object* x_161; lean_object* x_162; lean_object* x_163; lean_object* x_164; 
x_160 = lean_ctor_get(x_15, 0);
lean_inc(x_160);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_161 = x_15;
} else {
 lean_dec_ref(x_15);
 x_161 = lean_box(0);
}
x_162 = lean_string_push(x_160, x_141);
if (lean_is_scalar(x_161)) {
 x_163 = lean_alloc_ctor(1, 1, 0);
} else {
 x_163 = x_161;
}
lean_ctor_set(x_163, 0, x_162);
lean_ctor_set(x_2, 0, x_163);
x_164 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_164, 0, x_2);
x_3 = x_164;
goto block_9;
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_165; 
lean_ctor_set(x_10, 0, x_143);
x_165 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_165, 0, x_2);
x_3 = x_165;
goto block_9;
}
else
{
lean_object* x_166; lean_object* x_167; lean_object* x_168; 
x_166 = lean_ctor_get(x_15, 0);
lean_inc(x_166);
lean_dec(x_15);
x_167 = lean_array_push(x_18, x_166);
lean_ctor_set(x_13, 0, x_167);
lean_ctor_set(x_10, 0, x_143);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_168 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_168, 0, x_2);
x_3 = x_168;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_169; 
lean_ctor_set(x_10, 0, x_143);
x_169 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_169, 0, x_2);
x_3 = x_169;
goto block_9;
}
else
{
lean_object* x_170; lean_object* x_171; lean_object* x_172; 
x_170 = lean_ctor_get(x_15, 0);
lean_inc(x_170);
lean_dec(x_15);
x_171 = lean_array_push(x_18, x_170);
lean_ctor_set(x_13, 0, x_171);
lean_ctor_set(x_10, 0, x_143);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_172 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_172, 0, x_2);
x_3 = x_172;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_173; 
lean_ctor_set(x_10, 0, x_143);
x_173 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_173, 0, x_2);
x_3 = x_173;
goto block_9;
}
else
{
lean_object* x_174; lean_object* x_175; lean_object* x_176; 
x_174 = lean_ctor_get(x_15, 0);
lean_inc(x_174);
lean_dec(x_15);
x_175 = lean_array_push(x_18, x_174);
lean_ctor_set(x_13, 0, x_175);
lean_ctor_set(x_10, 0, x_143);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_176 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_176, 0, x_2);
x_3 = x_176;
goto block_9;
}
}
}
else
{
lean_object* x_177; 
x_177 = lean_box(2);
lean_ctor_set(x_13, 1, x_177);
lean_ctor_set(x_10, 0, x_143);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_178; lean_object* x_179; 
x_178 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
lean_ctor_set(x_2, 0, x_178);
x_179 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_179, 0, x_2);
x_3 = x_179;
goto block_9;
}
else
{
lean_object* x_180; lean_object* x_181; lean_object* x_182; lean_object* x_183; 
x_180 = lean_ctor_get(x_15, 0);
lean_inc(x_180);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_181 = x_15;
} else {
 lean_dec_ref(x_15);
 x_181 = lean_box(0);
}
if (lean_is_scalar(x_181)) {
 x_182 = lean_alloc_ctor(1, 1, 0);
} else {
 x_182 = x_181;
}
lean_ctor_set(x_182, 0, x_180);
lean_ctor_set(x_2, 0, x_182);
x_183 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_183, 0, x_2);
x_3 = x_183;
goto block_9;
}
}
}
else
{
lean_object* x_184; 
x_184 = lean_box(1);
lean_ctor_set(x_13, 1, x_184);
lean_ctor_set(x_10, 0, x_143);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_185; lean_object* x_186; 
x_185 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
lean_ctor_set(x_2, 0, x_185);
x_186 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_186, 0, x_2);
x_3 = x_186;
goto block_9;
}
else
{
lean_object* x_187; lean_object* x_188; lean_object* x_189; lean_object* x_190; 
x_187 = lean_ctor_get(x_15, 0);
lean_inc(x_187);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_188 = x_15;
} else {
 lean_dec_ref(x_15);
 x_188 = lean_box(0);
}
if (lean_is_scalar(x_188)) {
 x_189 = lean_alloc_ctor(1, 1, 0);
} else {
 x_189 = x_188;
}
lean_ctor_set(x_189, 0, x_187);
lean_ctor_set(x_2, 0, x_189);
x_190 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_190, 0, x_2);
x_3 = x_190;
goto block_9;
}
}
}
else
{
lean_object* x_191; lean_object* x_192; 
x_191 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_191, 0, x_19);
lean_ctor_set(x_13, 1, x_191);
lean_ctor_set(x_10, 0, x_143);
x_192 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_192, 0, x_2);
x_3 = x_192;
goto block_9;
}
}
case 1:
{
uint32_t x_193; uint8_t x_194; 
x_193 = 39;
x_194 = lean_uint32_dec_eq(x_141, x_193);
if (x_194 == 0)
{
lean_ctor_set(x_10, 0, x_143);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_195; lean_object* x_196; lean_object* x_197; lean_object* x_198; 
x_195 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_196 = lean_string_push(x_195, x_141);
x_197 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_197, 0, x_196);
lean_ctor_set(x_2, 0, x_197);
x_198 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_198, 0, x_2);
x_3 = x_198;
goto block_9;
}
else
{
lean_object* x_199; lean_object* x_200; lean_object* x_201; lean_object* x_202; lean_object* x_203; 
x_199 = lean_ctor_get(x_15, 0);
lean_inc(x_199);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_200 = x_15;
} else {
 lean_dec_ref(x_15);
 x_200 = lean_box(0);
}
x_201 = lean_string_push(x_199, x_141);
if (lean_is_scalar(x_200)) {
 x_202 = lean_alloc_ctor(1, 1, 0);
} else {
 x_202 = x_200;
}
lean_ctor_set(x_202, 0, x_201);
lean_ctor_set(x_2, 0, x_202);
x_203 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_203, 0, x_2);
x_3 = x_203;
goto block_9;
}
}
else
{
lean_object* x_204; lean_object* x_205; 
x_204 = lean_box(0);
lean_ctor_set(x_13, 1, x_204);
lean_ctor_set(x_10, 0, x_143);
x_205 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_205, 0, x_2);
x_3 = x_205;
goto block_9;
}
}
case 2:
{
uint32_t x_206; uint8_t x_207; 
x_206 = 34;
x_207 = lean_uint32_dec_eq(x_141, x_206);
if (x_207 == 0)
{
uint32_t x_208; uint8_t x_209; 
x_208 = 92;
x_209 = lean_uint32_dec_eq(x_141, x_208);
if (x_209 == 0)
{
lean_ctor_set(x_10, 0, x_143);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_210; lean_object* x_211; lean_object* x_212; lean_object* x_213; 
x_210 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_211 = lean_string_push(x_210, x_141);
x_212 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_212, 0, x_211);
lean_ctor_set(x_2, 0, x_212);
x_213 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_213, 0, x_2);
x_3 = x_213;
goto block_9;
}
else
{
lean_object* x_214; lean_object* x_215; lean_object* x_216; lean_object* x_217; lean_object* x_218; 
x_214 = lean_ctor_get(x_15, 0);
lean_inc(x_214);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_215 = x_15;
} else {
 lean_dec_ref(x_15);
 x_215 = lean_box(0);
}
x_216 = lean_string_push(x_214, x_141);
if (lean_is_scalar(x_215)) {
 x_217 = lean_alloc_ctor(1, 1, 0);
} else {
 x_217 = x_215;
}
lean_ctor_set(x_217, 0, x_216);
lean_ctor_set(x_2, 0, x_217);
x_218 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_218, 0, x_2);
x_3 = x_218;
goto block_9;
}
}
else
{
lean_object* x_219; lean_object* x_220; 
x_219 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_219, 0, x_19);
lean_ctor_set(x_13, 1, x_219);
lean_ctor_set(x_10, 0, x_143);
x_220 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_220, 0, x_2);
x_3 = x_220;
goto block_9;
}
}
else
{
lean_object* x_221; lean_object* x_222; 
x_221 = lean_box(0);
lean_ctor_set(x_13, 1, x_221);
lean_ctor_set(x_10, 0, x_143);
x_222 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_222, 0, x_2);
x_3 = x_222;
goto block_9;
}
}
default: 
{
lean_object* x_223; lean_object* x_224; 
x_223 = lean_ctor_get(x_19, 0);
lean_inc(x_223);
if (lean_is_exclusive(x_19)) {
 lean_ctor_release(x_19, 0);
 x_224 = x_19;
} else {
 lean_dec_ref(x_19);
 x_224 = lean_box(0);
}
lean_ctor_set(x_13, 1, x_223);
lean_ctor_set(x_10, 0, x_143);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_225; lean_object* x_226; lean_object* x_227; lean_object* x_228; 
x_225 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_226 = lean_string_push(x_225, x_141);
if (lean_is_scalar(x_224)) {
 x_227 = lean_alloc_ctor(1, 1, 0);
} else {
 x_227 = x_224;
 lean_ctor_set_tag(x_227, 1);
}
lean_ctor_set(x_227, 0, x_226);
lean_ctor_set(x_2, 0, x_227);
x_228 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_228, 0, x_2);
x_3 = x_228;
goto block_9;
}
else
{
lean_object* x_229; lean_object* x_230; lean_object* x_231; lean_object* x_232; lean_object* x_233; 
x_229 = lean_ctor_get(x_15, 0);
lean_inc(x_229);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_230 = x_15;
} else {
 lean_dec_ref(x_15);
 x_230 = lean_box(0);
}
x_231 = lean_string_push(x_229, x_141);
if (lean_is_scalar(x_230)) {
 x_232 = lean_alloc_ctor(1, 1, 0);
} else {
 x_232 = x_230;
}
lean_ctor_set(x_232, 0, x_231);
lean_ctor_set(x_2, 0, x_232);
if (lean_is_scalar(x_224)) {
 x_233 = lean_alloc_ctor(1, 1, 0);
} else {
 x_233 = x_224;
 lean_ctor_set_tag(x_233, 1);
}
lean_ctor_set(x_233, 0, x_2);
x_3 = x_233;
goto block_9;
}
}
}
}
}
}
else
{
lean_object* x_234; lean_object* x_235; lean_object* x_236; lean_object* x_237; lean_object* x_238; uint8_t x_239; 
x_234 = lean_ctor_get(x_13, 0);
x_235 = lean_ctor_get(x_13, 1);
lean_inc(x_235);
lean_inc(x_234);
lean_dec(x_13);
x_236 = lean_ctor_get(x_14, 0);
lean_inc(x_236);
x_237 = lean_ctor_get(x_14, 1);
lean_inc(x_237);
x_238 = lean_string_utf8_byte_size(x_236);
x_239 = lean_nat_dec_lt(x_237, x_238);
lean_dec(x_238);
if (x_239 == 0)
{
lean_object* x_240; lean_object* x_241; 
lean_dec(x_237);
lean_dec(x_236);
x_240 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_240, 0, x_234);
lean_ctor_set(x_240, 1, x_235);
lean_ctor_set(x_10, 1, x_240);
x_241 = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(x_241, 0, x_2);
x_3 = x_241;
goto block_9;
}
else
{
lean_object* x_242; uint32_t x_243; lean_object* x_244; lean_object* x_245; 
if (lean_is_exclusive(x_14)) {
 lean_ctor_release(x_14, 0);
 lean_ctor_release(x_14, 1);
 x_242 = x_14;
} else {
 lean_dec_ref(x_14);
 x_242 = lean_box(0);
}
x_243 = lean_string_utf8_get_fast(x_236, x_237);
x_244 = lean_string_utf8_next_fast(x_236, x_237);
lean_dec(x_237);
if (lean_is_scalar(x_242)) {
 x_245 = lean_alloc_ctor(0, 2, 0);
} else {
 x_245 = x_242;
}
lean_ctor_set(x_245, 0, x_236);
lean_ctor_set(x_245, 1, x_244);
switch (lean_obj_tag(x_235)) {
case 0:
{
uint32_t x_246; uint8_t x_247; 
x_246 = 92;
x_247 = lean_uint32_dec_eq(x_243, x_246);
if (x_247 == 0)
{
uint32_t x_248; uint8_t x_249; 
x_248 = 39;
x_249 = lean_uint32_dec_eq(x_243, x_248);
if (x_249 == 0)
{
uint32_t x_250; uint8_t x_251; 
x_250 = 34;
x_251 = lean_uint32_dec_eq(x_243, x_250);
if (x_251 == 0)
{
uint32_t x_252; uint8_t x_253; 
x_252 = 32;
x_253 = lean_uint32_dec_eq(x_243, x_252);
if (x_253 == 0)
{
uint32_t x_254; uint8_t x_255; 
x_254 = 9;
x_255 = lean_uint32_dec_eq(x_243, x_254);
if (x_255 == 0)
{
uint32_t x_256; uint8_t x_257; 
x_256 = 10;
x_257 = lean_uint32_dec_eq(x_243, x_256);
if (x_257 == 0)
{
lean_object* x_258; 
x_258 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_258, 0, x_234);
lean_ctor_set(x_258, 1, x_235);
lean_ctor_set(x_10, 1, x_258);
lean_ctor_set(x_10, 0, x_245);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_259; lean_object* x_260; lean_object* x_261; lean_object* x_262; 
x_259 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_260 = lean_string_push(x_259, x_243);
x_261 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_261, 0, x_260);
lean_ctor_set(x_2, 0, x_261);
x_262 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_262, 0, x_2);
x_3 = x_262;
goto block_9;
}
else
{
lean_object* x_263; lean_object* x_264; lean_object* x_265; lean_object* x_266; lean_object* x_267; 
x_263 = lean_ctor_get(x_15, 0);
lean_inc(x_263);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_264 = x_15;
} else {
 lean_dec_ref(x_15);
 x_264 = lean_box(0);
}
x_265 = lean_string_push(x_263, x_243);
if (lean_is_scalar(x_264)) {
 x_266 = lean_alloc_ctor(1, 1, 0);
} else {
 x_266 = x_264;
}
lean_ctor_set(x_266, 0, x_265);
lean_ctor_set(x_2, 0, x_266);
x_267 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_267, 0, x_2);
x_3 = x_267;
goto block_9;
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_268; lean_object* x_269; 
x_268 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_268, 0, x_234);
lean_ctor_set(x_268, 1, x_235);
lean_ctor_set(x_10, 1, x_268);
lean_ctor_set(x_10, 0, x_245);
x_269 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_269, 0, x_2);
x_3 = x_269;
goto block_9;
}
else
{
lean_object* x_270; lean_object* x_271; lean_object* x_272; lean_object* x_273; 
x_270 = lean_ctor_get(x_15, 0);
lean_inc(x_270);
lean_dec(x_15);
x_271 = lean_array_push(x_234, x_270);
x_272 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_272, 0, x_271);
lean_ctor_set(x_272, 1, x_235);
lean_ctor_set(x_10, 1, x_272);
lean_ctor_set(x_10, 0, x_245);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_273 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_273, 0, x_2);
x_3 = x_273;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_274; lean_object* x_275; 
x_274 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_274, 0, x_234);
lean_ctor_set(x_274, 1, x_235);
lean_ctor_set(x_10, 1, x_274);
lean_ctor_set(x_10, 0, x_245);
x_275 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_275, 0, x_2);
x_3 = x_275;
goto block_9;
}
else
{
lean_object* x_276; lean_object* x_277; lean_object* x_278; lean_object* x_279; 
x_276 = lean_ctor_get(x_15, 0);
lean_inc(x_276);
lean_dec(x_15);
x_277 = lean_array_push(x_234, x_276);
x_278 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_278, 0, x_277);
lean_ctor_set(x_278, 1, x_235);
lean_ctor_set(x_10, 1, x_278);
lean_ctor_set(x_10, 0, x_245);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_279 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_279, 0, x_2);
x_3 = x_279;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_280; lean_object* x_281; 
x_280 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_280, 0, x_234);
lean_ctor_set(x_280, 1, x_235);
lean_ctor_set(x_10, 1, x_280);
lean_ctor_set(x_10, 0, x_245);
x_281 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_281, 0, x_2);
x_3 = x_281;
goto block_9;
}
else
{
lean_object* x_282; lean_object* x_283; lean_object* x_284; lean_object* x_285; 
x_282 = lean_ctor_get(x_15, 0);
lean_inc(x_282);
lean_dec(x_15);
x_283 = lean_array_push(x_234, x_282);
x_284 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_284, 0, x_283);
lean_ctor_set(x_284, 1, x_235);
lean_ctor_set(x_10, 1, x_284);
lean_ctor_set(x_10, 0, x_245);
lean_inc(x_1);
lean_ctor_set(x_2, 0, x_1);
x_285 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_285, 0, x_2);
x_3 = x_285;
goto block_9;
}
}
}
else
{
lean_object* x_286; lean_object* x_287; 
x_286 = lean_box(2);
x_287 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_287, 0, x_234);
lean_ctor_set(x_287, 1, x_286);
lean_ctor_set(x_10, 1, x_287);
lean_ctor_set(x_10, 0, x_245);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_288; lean_object* x_289; 
x_288 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
lean_ctor_set(x_2, 0, x_288);
x_289 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_289, 0, x_2);
x_3 = x_289;
goto block_9;
}
else
{
lean_object* x_290; lean_object* x_291; lean_object* x_292; lean_object* x_293; 
x_290 = lean_ctor_get(x_15, 0);
lean_inc(x_290);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_291 = x_15;
} else {
 lean_dec_ref(x_15);
 x_291 = lean_box(0);
}
if (lean_is_scalar(x_291)) {
 x_292 = lean_alloc_ctor(1, 1, 0);
} else {
 x_292 = x_291;
}
lean_ctor_set(x_292, 0, x_290);
lean_ctor_set(x_2, 0, x_292);
x_293 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_293, 0, x_2);
x_3 = x_293;
goto block_9;
}
}
}
else
{
lean_object* x_294; lean_object* x_295; 
x_294 = lean_box(1);
x_295 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_295, 0, x_234);
lean_ctor_set(x_295, 1, x_294);
lean_ctor_set(x_10, 1, x_295);
lean_ctor_set(x_10, 0, x_245);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_296; lean_object* x_297; 
x_296 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
lean_ctor_set(x_2, 0, x_296);
x_297 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_297, 0, x_2);
x_3 = x_297;
goto block_9;
}
else
{
lean_object* x_298; lean_object* x_299; lean_object* x_300; lean_object* x_301; 
x_298 = lean_ctor_get(x_15, 0);
lean_inc(x_298);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_299 = x_15;
} else {
 lean_dec_ref(x_15);
 x_299 = lean_box(0);
}
if (lean_is_scalar(x_299)) {
 x_300 = lean_alloc_ctor(1, 1, 0);
} else {
 x_300 = x_299;
}
lean_ctor_set(x_300, 0, x_298);
lean_ctor_set(x_2, 0, x_300);
x_301 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_301, 0, x_2);
x_3 = x_301;
goto block_9;
}
}
}
else
{
lean_object* x_302; lean_object* x_303; lean_object* x_304; 
x_302 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_302, 0, x_235);
x_303 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_303, 0, x_234);
lean_ctor_set(x_303, 1, x_302);
lean_ctor_set(x_10, 1, x_303);
lean_ctor_set(x_10, 0, x_245);
x_304 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_304, 0, x_2);
x_3 = x_304;
goto block_9;
}
}
case 1:
{
uint32_t x_305; uint8_t x_306; 
x_305 = 39;
x_306 = lean_uint32_dec_eq(x_243, x_305);
if (x_306 == 0)
{
lean_object* x_307; 
x_307 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_307, 0, x_234);
lean_ctor_set(x_307, 1, x_235);
lean_ctor_set(x_10, 1, x_307);
lean_ctor_set(x_10, 0, x_245);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_308; lean_object* x_309; lean_object* x_310; lean_object* x_311; 
x_308 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_309 = lean_string_push(x_308, x_243);
x_310 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_310, 0, x_309);
lean_ctor_set(x_2, 0, x_310);
x_311 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_311, 0, x_2);
x_3 = x_311;
goto block_9;
}
else
{
lean_object* x_312; lean_object* x_313; lean_object* x_314; lean_object* x_315; lean_object* x_316; 
x_312 = lean_ctor_get(x_15, 0);
lean_inc(x_312);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_313 = x_15;
} else {
 lean_dec_ref(x_15);
 x_313 = lean_box(0);
}
x_314 = lean_string_push(x_312, x_243);
if (lean_is_scalar(x_313)) {
 x_315 = lean_alloc_ctor(1, 1, 0);
} else {
 x_315 = x_313;
}
lean_ctor_set(x_315, 0, x_314);
lean_ctor_set(x_2, 0, x_315);
x_316 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_316, 0, x_2);
x_3 = x_316;
goto block_9;
}
}
else
{
lean_object* x_317; lean_object* x_318; lean_object* x_319; 
x_317 = lean_box(0);
x_318 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_318, 0, x_234);
lean_ctor_set(x_318, 1, x_317);
lean_ctor_set(x_10, 1, x_318);
lean_ctor_set(x_10, 0, x_245);
x_319 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_319, 0, x_2);
x_3 = x_319;
goto block_9;
}
}
case 2:
{
uint32_t x_320; uint8_t x_321; 
x_320 = 34;
x_321 = lean_uint32_dec_eq(x_243, x_320);
if (x_321 == 0)
{
uint32_t x_322; uint8_t x_323; 
x_322 = 92;
x_323 = lean_uint32_dec_eq(x_243, x_322);
if (x_323 == 0)
{
lean_object* x_324; 
x_324 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_324, 0, x_234);
lean_ctor_set(x_324, 1, x_235);
lean_ctor_set(x_10, 1, x_324);
lean_ctor_set(x_10, 0, x_245);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_325; lean_object* x_326; lean_object* x_327; lean_object* x_328; 
x_325 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_326 = lean_string_push(x_325, x_243);
x_327 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_327, 0, x_326);
lean_ctor_set(x_2, 0, x_327);
x_328 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_328, 0, x_2);
x_3 = x_328;
goto block_9;
}
else
{
lean_object* x_329; lean_object* x_330; lean_object* x_331; lean_object* x_332; lean_object* x_333; 
x_329 = lean_ctor_get(x_15, 0);
lean_inc(x_329);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_330 = x_15;
} else {
 lean_dec_ref(x_15);
 x_330 = lean_box(0);
}
x_331 = lean_string_push(x_329, x_243);
if (lean_is_scalar(x_330)) {
 x_332 = lean_alloc_ctor(1, 1, 0);
} else {
 x_332 = x_330;
}
lean_ctor_set(x_332, 0, x_331);
lean_ctor_set(x_2, 0, x_332);
x_333 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_333, 0, x_2);
x_3 = x_333;
goto block_9;
}
}
else
{
lean_object* x_334; lean_object* x_335; lean_object* x_336; 
x_334 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_334, 0, x_235);
x_335 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_335, 0, x_234);
lean_ctor_set(x_335, 1, x_334);
lean_ctor_set(x_10, 1, x_335);
lean_ctor_set(x_10, 0, x_245);
x_336 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_336, 0, x_2);
x_3 = x_336;
goto block_9;
}
}
else
{
lean_object* x_337; lean_object* x_338; lean_object* x_339; 
x_337 = lean_box(0);
x_338 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_338, 0, x_234);
lean_ctor_set(x_338, 1, x_337);
lean_ctor_set(x_10, 1, x_338);
lean_ctor_set(x_10, 0, x_245);
x_339 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_339, 0, x_2);
x_3 = x_339;
goto block_9;
}
}
default: 
{
lean_object* x_340; lean_object* x_341; lean_object* x_342; 
x_340 = lean_ctor_get(x_235, 0);
lean_inc(x_340);
if (lean_is_exclusive(x_235)) {
 lean_ctor_release(x_235, 0);
 x_341 = x_235;
} else {
 lean_dec_ref(x_235);
 x_341 = lean_box(0);
}
x_342 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_342, 0, x_234);
lean_ctor_set(x_342, 1, x_340);
lean_ctor_set(x_10, 1, x_342);
lean_ctor_set(x_10, 0, x_245);
if (lean_obj_tag(x_15) == 0)
{
lean_object* x_343; lean_object* x_344; lean_object* x_345; lean_object* x_346; 
x_343 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_344 = lean_string_push(x_343, x_243);
if (lean_is_scalar(x_341)) {
 x_345 = lean_alloc_ctor(1, 1, 0);
} else {
 x_345 = x_341;
 lean_ctor_set_tag(x_345, 1);
}
lean_ctor_set(x_345, 0, x_344);
lean_ctor_set(x_2, 0, x_345);
x_346 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_346, 0, x_2);
x_3 = x_346;
goto block_9;
}
else
{
lean_object* x_347; lean_object* x_348; lean_object* x_349; lean_object* x_350; lean_object* x_351; 
x_347 = lean_ctor_get(x_15, 0);
lean_inc(x_347);
if (lean_is_exclusive(x_15)) {
 lean_ctor_release(x_15, 0);
 x_348 = x_15;
} else {
 lean_dec_ref(x_15);
 x_348 = lean_box(0);
}
x_349 = lean_string_push(x_347, x_243);
if (lean_is_scalar(x_348)) {
 x_350 = lean_alloc_ctor(1, 1, 0);
} else {
 x_350 = x_348;
}
lean_ctor_set(x_350, 0, x_349);
lean_ctor_set(x_2, 0, x_350);
if (lean_is_scalar(x_341)) {
 x_351 = lean_alloc_ctor(1, 1, 0);
} else {
 x_351 = x_341;
 lean_ctor_set_tag(x_351, 1);
}
lean_ctor_set(x_351, 0, x_2);
x_3 = x_351;
goto block_9;
}
}
}
}
}
}
else
{
lean_object* x_352; lean_object* x_353; lean_object* x_354; lean_object* x_355; lean_object* x_356; lean_object* x_357; lean_object* x_358; lean_object* x_359; lean_object* x_360; uint8_t x_361; 
x_352 = lean_ctor_get(x_10, 1);
x_353 = lean_ctor_get(x_10, 0);
x_354 = lean_ctor_get(x_2, 0);
lean_inc(x_354);
lean_dec(x_2);
x_355 = lean_ctor_get(x_352, 0);
lean_inc(x_355);
x_356 = lean_ctor_get(x_352, 1);
lean_inc(x_356);
if (lean_is_exclusive(x_352)) {
 lean_ctor_release(x_352, 0);
 lean_ctor_release(x_352, 1);
 x_357 = x_352;
} else {
 lean_dec_ref(x_352);
 x_357 = lean_box(0);
}
x_358 = lean_ctor_get(x_353, 0);
lean_inc(x_358);
x_359 = lean_ctor_get(x_353, 1);
lean_inc(x_359);
x_360 = lean_string_utf8_byte_size(x_358);
x_361 = lean_nat_dec_lt(x_359, x_360);
lean_dec(x_360);
if (x_361 == 0)
{
lean_object* x_362; lean_object* x_363; lean_object* x_364; 
lean_dec(x_359);
lean_dec(x_358);
if (lean_is_scalar(x_357)) {
 x_362 = lean_alloc_ctor(0, 2, 0);
} else {
 x_362 = x_357;
}
lean_ctor_set(x_362, 0, x_355);
lean_ctor_set(x_362, 1, x_356);
lean_ctor_set(x_10, 1, x_362);
x_363 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_363, 0, x_354);
lean_ctor_set(x_363, 1, x_10);
x_364 = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(x_364, 0, x_363);
x_3 = x_364;
goto block_9;
}
else
{
lean_object* x_365; uint32_t x_366; lean_object* x_367; lean_object* x_368; 
if (lean_is_exclusive(x_353)) {
 lean_ctor_release(x_353, 0);
 lean_ctor_release(x_353, 1);
 x_365 = x_353;
} else {
 lean_dec_ref(x_353);
 x_365 = lean_box(0);
}
x_366 = lean_string_utf8_get_fast(x_358, x_359);
x_367 = lean_string_utf8_next_fast(x_358, x_359);
lean_dec(x_359);
if (lean_is_scalar(x_365)) {
 x_368 = lean_alloc_ctor(0, 2, 0);
} else {
 x_368 = x_365;
}
lean_ctor_set(x_368, 0, x_358);
lean_ctor_set(x_368, 1, x_367);
switch (lean_obj_tag(x_356)) {
case 0:
{
uint32_t x_369; uint8_t x_370; 
x_369 = 92;
x_370 = lean_uint32_dec_eq(x_366, x_369);
if (x_370 == 0)
{
uint32_t x_371; uint8_t x_372; 
x_371 = 39;
x_372 = lean_uint32_dec_eq(x_366, x_371);
if (x_372 == 0)
{
uint32_t x_373; uint8_t x_374; 
x_373 = 34;
x_374 = lean_uint32_dec_eq(x_366, x_373);
if (x_374 == 0)
{
uint32_t x_375; uint8_t x_376; 
x_375 = 32;
x_376 = lean_uint32_dec_eq(x_366, x_375);
if (x_376 == 0)
{
uint32_t x_377; uint8_t x_378; 
x_377 = 9;
x_378 = lean_uint32_dec_eq(x_366, x_377);
if (x_378 == 0)
{
uint32_t x_379; uint8_t x_380; 
x_379 = 10;
x_380 = lean_uint32_dec_eq(x_366, x_379);
if (x_380 == 0)
{
lean_object* x_381; 
if (lean_is_scalar(x_357)) {
 x_381 = lean_alloc_ctor(0, 2, 0);
} else {
 x_381 = x_357;
}
lean_ctor_set(x_381, 0, x_355);
lean_ctor_set(x_381, 1, x_356);
lean_ctor_set(x_10, 1, x_381);
lean_ctor_set(x_10, 0, x_368);
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_382; lean_object* x_383; lean_object* x_384; lean_object* x_385; lean_object* x_386; 
x_382 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_383 = lean_string_push(x_382, x_366);
x_384 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_384, 0, x_383);
x_385 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_385, 0, x_384);
lean_ctor_set(x_385, 1, x_10);
x_386 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_386, 0, x_385);
x_3 = x_386;
goto block_9;
}
else
{
lean_object* x_387; lean_object* x_388; lean_object* x_389; lean_object* x_390; lean_object* x_391; lean_object* x_392; 
x_387 = lean_ctor_get(x_354, 0);
lean_inc(x_387);
if (lean_is_exclusive(x_354)) {
 lean_ctor_release(x_354, 0);
 x_388 = x_354;
} else {
 lean_dec_ref(x_354);
 x_388 = lean_box(0);
}
x_389 = lean_string_push(x_387, x_366);
if (lean_is_scalar(x_388)) {
 x_390 = lean_alloc_ctor(1, 1, 0);
} else {
 x_390 = x_388;
}
lean_ctor_set(x_390, 0, x_389);
x_391 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_391, 0, x_390);
lean_ctor_set(x_391, 1, x_10);
x_392 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_392, 0, x_391);
x_3 = x_392;
goto block_9;
}
}
else
{
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_393; lean_object* x_394; lean_object* x_395; 
if (lean_is_scalar(x_357)) {
 x_393 = lean_alloc_ctor(0, 2, 0);
} else {
 x_393 = x_357;
}
lean_ctor_set(x_393, 0, x_355);
lean_ctor_set(x_393, 1, x_356);
lean_ctor_set(x_10, 1, x_393);
lean_ctor_set(x_10, 0, x_368);
x_394 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_394, 0, x_354);
lean_ctor_set(x_394, 1, x_10);
x_395 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_395, 0, x_394);
x_3 = x_395;
goto block_9;
}
else
{
lean_object* x_396; lean_object* x_397; lean_object* x_398; lean_object* x_399; lean_object* x_400; 
x_396 = lean_ctor_get(x_354, 0);
lean_inc(x_396);
lean_dec(x_354);
x_397 = lean_array_push(x_355, x_396);
if (lean_is_scalar(x_357)) {
 x_398 = lean_alloc_ctor(0, 2, 0);
} else {
 x_398 = x_357;
}
lean_ctor_set(x_398, 0, x_397);
lean_ctor_set(x_398, 1, x_356);
lean_ctor_set(x_10, 1, x_398);
lean_ctor_set(x_10, 0, x_368);
lean_inc(x_1);
x_399 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_399, 0, x_1);
lean_ctor_set(x_399, 1, x_10);
x_400 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_400, 0, x_399);
x_3 = x_400;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_401; lean_object* x_402; lean_object* x_403; 
if (lean_is_scalar(x_357)) {
 x_401 = lean_alloc_ctor(0, 2, 0);
} else {
 x_401 = x_357;
}
lean_ctor_set(x_401, 0, x_355);
lean_ctor_set(x_401, 1, x_356);
lean_ctor_set(x_10, 1, x_401);
lean_ctor_set(x_10, 0, x_368);
x_402 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_402, 0, x_354);
lean_ctor_set(x_402, 1, x_10);
x_403 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_403, 0, x_402);
x_3 = x_403;
goto block_9;
}
else
{
lean_object* x_404; lean_object* x_405; lean_object* x_406; lean_object* x_407; lean_object* x_408; 
x_404 = lean_ctor_get(x_354, 0);
lean_inc(x_404);
lean_dec(x_354);
x_405 = lean_array_push(x_355, x_404);
if (lean_is_scalar(x_357)) {
 x_406 = lean_alloc_ctor(0, 2, 0);
} else {
 x_406 = x_357;
}
lean_ctor_set(x_406, 0, x_405);
lean_ctor_set(x_406, 1, x_356);
lean_ctor_set(x_10, 1, x_406);
lean_ctor_set(x_10, 0, x_368);
lean_inc(x_1);
x_407 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_407, 0, x_1);
lean_ctor_set(x_407, 1, x_10);
x_408 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_408, 0, x_407);
x_3 = x_408;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_409; lean_object* x_410; lean_object* x_411; 
if (lean_is_scalar(x_357)) {
 x_409 = lean_alloc_ctor(0, 2, 0);
} else {
 x_409 = x_357;
}
lean_ctor_set(x_409, 0, x_355);
lean_ctor_set(x_409, 1, x_356);
lean_ctor_set(x_10, 1, x_409);
lean_ctor_set(x_10, 0, x_368);
x_410 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_410, 0, x_354);
lean_ctor_set(x_410, 1, x_10);
x_411 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_411, 0, x_410);
x_3 = x_411;
goto block_9;
}
else
{
lean_object* x_412; lean_object* x_413; lean_object* x_414; lean_object* x_415; lean_object* x_416; 
x_412 = lean_ctor_get(x_354, 0);
lean_inc(x_412);
lean_dec(x_354);
x_413 = lean_array_push(x_355, x_412);
if (lean_is_scalar(x_357)) {
 x_414 = lean_alloc_ctor(0, 2, 0);
} else {
 x_414 = x_357;
}
lean_ctor_set(x_414, 0, x_413);
lean_ctor_set(x_414, 1, x_356);
lean_ctor_set(x_10, 1, x_414);
lean_ctor_set(x_10, 0, x_368);
lean_inc(x_1);
x_415 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_415, 0, x_1);
lean_ctor_set(x_415, 1, x_10);
x_416 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_416, 0, x_415);
x_3 = x_416;
goto block_9;
}
}
}
else
{
lean_object* x_417; lean_object* x_418; 
x_417 = lean_box(2);
if (lean_is_scalar(x_357)) {
 x_418 = lean_alloc_ctor(0, 2, 0);
} else {
 x_418 = x_357;
}
lean_ctor_set(x_418, 0, x_355);
lean_ctor_set(x_418, 1, x_417);
lean_ctor_set(x_10, 1, x_418);
lean_ctor_set(x_10, 0, x_368);
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_419; lean_object* x_420; lean_object* x_421; 
x_419 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
x_420 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_420, 0, x_419);
lean_ctor_set(x_420, 1, x_10);
x_421 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_421, 0, x_420);
x_3 = x_421;
goto block_9;
}
else
{
lean_object* x_422; lean_object* x_423; lean_object* x_424; lean_object* x_425; lean_object* x_426; 
x_422 = lean_ctor_get(x_354, 0);
lean_inc(x_422);
if (lean_is_exclusive(x_354)) {
 lean_ctor_release(x_354, 0);
 x_423 = x_354;
} else {
 lean_dec_ref(x_354);
 x_423 = lean_box(0);
}
if (lean_is_scalar(x_423)) {
 x_424 = lean_alloc_ctor(1, 1, 0);
} else {
 x_424 = x_423;
}
lean_ctor_set(x_424, 0, x_422);
x_425 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_425, 0, x_424);
lean_ctor_set(x_425, 1, x_10);
x_426 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_426, 0, x_425);
x_3 = x_426;
goto block_9;
}
}
}
else
{
lean_object* x_427; lean_object* x_428; 
x_427 = lean_box(1);
if (lean_is_scalar(x_357)) {
 x_428 = lean_alloc_ctor(0, 2, 0);
} else {
 x_428 = x_357;
}
lean_ctor_set(x_428, 0, x_355);
lean_ctor_set(x_428, 1, x_427);
lean_ctor_set(x_10, 1, x_428);
lean_ctor_set(x_10, 0, x_368);
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_429; lean_object* x_430; lean_object* x_431; 
x_429 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
x_430 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_430, 0, x_429);
lean_ctor_set(x_430, 1, x_10);
x_431 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_431, 0, x_430);
x_3 = x_431;
goto block_9;
}
else
{
lean_object* x_432; lean_object* x_433; lean_object* x_434; lean_object* x_435; lean_object* x_436; 
x_432 = lean_ctor_get(x_354, 0);
lean_inc(x_432);
if (lean_is_exclusive(x_354)) {
 lean_ctor_release(x_354, 0);
 x_433 = x_354;
} else {
 lean_dec_ref(x_354);
 x_433 = lean_box(0);
}
if (lean_is_scalar(x_433)) {
 x_434 = lean_alloc_ctor(1, 1, 0);
} else {
 x_434 = x_433;
}
lean_ctor_set(x_434, 0, x_432);
x_435 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_435, 0, x_434);
lean_ctor_set(x_435, 1, x_10);
x_436 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_436, 0, x_435);
x_3 = x_436;
goto block_9;
}
}
}
else
{
lean_object* x_437; lean_object* x_438; lean_object* x_439; lean_object* x_440; 
x_437 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_437, 0, x_356);
if (lean_is_scalar(x_357)) {
 x_438 = lean_alloc_ctor(0, 2, 0);
} else {
 x_438 = x_357;
}
lean_ctor_set(x_438, 0, x_355);
lean_ctor_set(x_438, 1, x_437);
lean_ctor_set(x_10, 1, x_438);
lean_ctor_set(x_10, 0, x_368);
x_439 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_439, 0, x_354);
lean_ctor_set(x_439, 1, x_10);
x_440 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_440, 0, x_439);
x_3 = x_440;
goto block_9;
}
}
case 1:
{
uint32_t x_441; uint8_t x_442; 
x_441 = 39;
x_442 = lean_uint32_dec_eq(x_366, x_441);
if (x_442 == 0)
{
lean_object* x_443; 
if (lean_is_scalar(x_357)) {
 x_443 = lean_alloc_ctor(0, 2, 0);
} else {
 x_443 = x_357;
}
lean_ctor_set(x_443, 0, x_355);
lean_ctor_set(x_443, 1, x_356);
lean_ctor_set(x_10, 1, x_443);
lean_ctor_set(x_10, 0, x_368);
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_444; lean_object* x_445; lean_object* x_446; lean_object* x_447; lean_object* x_448; 
x_444 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_445 = lean_string_push(x_444, x_366);
x_446 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_446, 0, x_445);
x_447 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_447, 0, x_446);
lean_ctor_set(x_447, 1, x_10);
x_448 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_448, 0, x_447);
x_3 = x_448;
goto block_9;
}
else
{
lean_object* x_449; lean_object* x_450; lean_object* x_451; lean_object* x_452; lean_object* x_453; lean_object* x_454; 
x_449 = lean_ctor_get(x_354, 0);
lean_inc(x_449);
if (lean_is_exclusive(x_354)) {
 lean_ctor_release(x_354, 0);
 x_450 = x_354;
} else {
 lean_dec_ref(x_354);
 x_450 = lean_box(0);
}
x_451 = lean_string_push(x_449, x_366);
if (lean_is_scalar(x_450)) {
 x_452 = lean_alloc_ctor(1, 1, 0);
} else {
 x_452 = x_450;
}
lean_ctor_set(x_452, 0, x_451);
x_453 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_453, 0, x_452);
lean_ctor_set(x_453, 1, x_10);
x_454 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_454, 0, x_453);
x_3 = x_454;
goto block_9;
}
}
else
{
lean_object* x_455; lean_object* x_456; lean_object* x_457; lean_object* x_458; 
x_455 = lean_box(0);
if (lean_is_scalar(x_357)) {
 x_456 = lean_alloc_ctor(0, 2, 0);
} else {
 x_456 = x_357;
}
lean_ctor_set(x_456, 0, x_355);
lean_ctor_set(x_456, 1, x_455);
lean_ctor_set(x_10, 1, x_456);
lean_ctor_set(x_10, 0, x_368);
x_457 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_457, 0, x_354);
lean_ctor_set(x_457, 1, x_10);
x_458 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_458, 0, x_457);
x_3 = x_458;
goto block_9;
}
}
case 2:
{
uint32_t x_459; uint8_t x_460; 
x_459 = 34;
x_460 = lean_uint32_dec_eq(x_366, x_459);
if (x_460 == 0)
{
uint32_t x_461; uint8_t x_462; 
x_461 = 92;
x_462 = lean_uint32_dec_eq(x_366, x_461);
if (x_462 == 0)
{
lean_object* x_463; 
if (lean_is_scalar(x_357)) {
 x_463 = lean_alloc_ctor(0, 2, 0);
} else {
 x_463 = x_357;
}
lean_ctor_set(x_463, 0, x_355);
lean_ctor_set(x_463, 1, x_356);
lean_ctor_set(x_10, 1, x_463);
lean_ctor_set(x_10, 0, x_368);
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_464; lean_object* x_465; lean_object* x_466; lean_object* x_467; lean_object* x_468; 
x_464 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_465 = lean_string_push(x_464, x_366);
x_466 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_466, 0, x_465);
x_467 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_467, 0, x_466);
lean_ctor_set(x_467, 1, x_10);
x_468 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_468, 0, x_467);
x_3 = x_468;
goto block_9;
}
else
{
lean_object* x_469; lean_object* x_470; lean_object* x_471; lean_object* x_472; lean_object* x_473; lean_object* x_474; 
x_469 = lean_ctor_get(x_354, 0);
lean_inc(x_469);
if (lean_is_exclusive(x_354)) {
 lean_ctor_release(x_354, 0);
 x_470 = x_354;
} else {
 lean_dec_ref(x_354);
 x_470 = lean_box(0);
}
x_471 = lean_string_push(x_469, x_366);
if (lean_is_scalar(x_470)) {
 x_472 = lean_alloc_ctor(1, 1, 0);
} else {
 x_472 = x_470;
}
lean_ctor_set(x_472, 0, x_471);
x_473 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_473, 0, x_472);
lean_ctor_set(x_473, 1, x_10);
x_474 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_474, 0, x_473);
x_3 = x_474;
goto block_9;
}
}
else
{
lean_object* x_475; lean_object* x_476; lean_object* x_477; lean_object* x_478; 
x_475 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_475, 0, x_356);
if (lean_is_scalar(x_357)) {
 x_476 = lean_alloc_ctor(0, 2, 0);
} else {
 x_476 = x_357;
}
lean_ctor_set(x_476, 0, x_355);
lean_ctor_set(x_476, 1, x_475);
lean_ctor_set(x_10, 1, x_476);
lean_ctor_set(x_10, 0, x_368);
x_477 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_477, 0, x_354);
lean_ctor_set(x_477, 1, x_10);
x_478 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_478, 0, x_477);
x_3 = x_478;
goto block_9;
}
}
else
{
lean_object* x_479; lean_object* x_480; lean_object* x_481; lean_object* x_482; 
x_479 = lean_box(0);
if (lean_is_scalar(x_357)) {
 x_480 = lean_alloc_ctor(0, 2, 0);
} else {
 x_480 = x_357;
}
lean_ctor_set(x_480, 0, x_355);
lean_ctor_set(x_480, 1, x_479);
lean_ctor_set(x_10, 1, x_480);
lean_ctor_set(x_10, 0, x_368);
x_481 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_481, 0, x_354);
lean_ctor_set(x_481, 1, x_10);
x_482 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_482, 0, x_481);
x_3 = x_482;
goto block_9;
}
}
default: 
{
lean_object* x_483; lean_object* x_484; lean_object* x_485; 
x_483 = lean_ctor_get(x_356, 0);
lean_inc(x_483);
if (lean_is_exclusive(x_356)) {
 lean_ctor_release(x_356, 0);
 x_484 = x_356;
} else {
 lean_dec_ref(x_356);
 x_484 = lean_box(0);
}
if (lean_is_scalar(x_357)) {
 x_485 = lean_alloc_ctor(0, 2, 0);
} else {
 x_485 = x_357;
}
lean_ctor_set(x_485, 0, x_355);
lean_ctor_set(x_485, 1, x_483);
lean_ctor_set(x_10, 1, x_485);
lean_ctor_set(x_10, 0, x_368);
if (lean_obj_tag(x_354) == 0)
{
lean_object* x_486; lean_object* x_487; lean_object* x_488; lean_object* x_489; lean_object* x_490; 
x_486 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_487 = lean_string_push(x_486, x_366);
if (lean_is_scalar(x_484)) {
 x_488 = lean_alloc_ctor(1, 1, 0);
} else {
 x_488 = x_484;
 lean_ctor_set_tag(x_488, 1);
}
lean_ctor_set(x_488, 0, x_487);
x_489 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_489, 0, x_488);
lean_ctor_set(x_489, 1, x_10);
x_490 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_490, 0, x_489);
x_3 = x_490;
goto block_9;
}
else
{
lean_object* x_491; lean_object* x_492; lean_object* x_493; lean_object* x_494; lean_object* x_495; lean_object* x_496; 
x_491 = lean_ctor_get(x_354, 0);
lean_inc(x_491);
if (lean_is_exclusive(x_354)) {
 lean_ctor_release(x_354, 0);
 x_492 = x_354;
} else {
 lean_dec_ref(x_354);
 x_492 = lean_box(0);
}
x_493 = lean_string_push(x_491, x_366);
if (lean_is_scalar(x_492)) {
 x_494 = lean_alloc_ctor(1, 1, 0);
} else {
 x_494 = x_492;
}
lean_ctor_set(x_494, 0, x_493);
x_495 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_495, 0, x_494);
lean_ctor_set(x_495, 1, x_10);
if (lean_is_scalar(x_484)) {
 x_496 = lean_alloc_ctor(1, 1, 0);
} else {
 x_496 = x_484;
 lean_ctor_set_tag(x_496, 1);
}
lean_ctor_set(x_496, 0, x_495);
x_3 = x_496;
goto block_9;
}
}
}
}
}
}
else
{
lean_object* x_497; lean_object* x_498; lean_object* x_499; lean_object* x_500; lean_object* x_501; lean_object* x_502; lean_object* x_503; lean_object* x_504; lean_object* x_505; lean_object* x_506; uint8_t x_507; 
x_497 = lean_ctor_get(x_10, 1);
x_498 = lean_ctor_get(x_10, 0);
lean_inc(x_497);
lean_inc(x_498);
lean_dec(x_10);
x_499 = lean_ctor_get(x_2, 0);
lean_inc(x_499);
if (lean_is_exclusive(x_2)) {
 lean_ctor_release(x_2, 0);
 lean_ctor_release(x_2, 1);
 x_500 = x_2;
} else {
 lean_dec_ref(x_2);
 x_500 = lean_box(0);
}
x_501 = lean_ctor_get(x_497, 0);
lean_inc(x_501);
x_502 = lean_ctor_get(x_497, 1);
lean_inc(x_502);
if (lean_is_exclusive(x_497)) {
 lean_ctor_release(x_497, 0);
 lean_ctor_release(x_497, 1);
 x_503 = x_497;
} else {
 lean_dec_ref(x_497);
 x_503 = lean_box(0);
}
x_504 = lean_ctor_get(x_498, 0);
lean_inc(x_504);
x_505 = lean_ctor_get(x_498, 1);
lean_inc(x_505);
x_506 = lean_string_utf8_byte_size(x_504);
x_507 = lean_nat_dec_lt(x_505, x_506);
lean_dec(x_506);
if (x_507 == 0)
{
lean_object* x_508; lean_object* x_509; lean_object* x_510; lean_object* x_511; 
lean_dec(x_505);
lean_dec(x_504);
if (lean_is_scalar(x_503)) {
 x_508 = lean_alloc_ctor(0, 2, 0);
} else {
 x_508 = x_503;
}
lean_ctor_set(x_508, 0, x_501);
lean_ctor_set(x_508, 1, x_502);
x_509 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_509, 0, x_498);
lean_ctor_set(x_509, 1, x_508);
if (lean_is_scalar(x_500)) {
 x_510 = lean_alloc_ctor(0, 2, 0);
} else {
 x_510 = x_500;
}
lean_ctor_set(x_510, 0, x_499);
lean_ctor_set(x_510, 1, x_509);
x_511 = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(x_511, 0, x_510);
x_3 = x_511;
goto block_9;
}
else
{
lean_object* x_512; uint32_t x_513; lean_object* x_514; lean_object* x_515; 
if (lean_is_exclusive(x_498)) {
 lean_ctor_release(x_498, 0);
 lean_ctor_release(x_498, 1);
 x_512 = x_498;
} else {
 lean_dec_ref(x_498);
 x_512 = lean_box(0);
}
x_513 = lean_string_utf8_get_fast(x_504, x_505);
x_514 = lean_string_utf8_next_fast(x_504, x_505);
lean_dec(x_505);
if (lean_is_scalar(x_512)) {
 x_515 = lean_alloc_ctor(0, 2, 0);
} else {
 x_515 = x_512;
}
lean_ctor_set(x_515, 0, x_504);
lean_ctor_set(x_515, 1, x_514);
switch (lean_obj_tag(x_502)) {
case 0:
{
uint32_t x_516; uint8_t x_517; 
x_516 = 92;
x_517 = lean_uint32_dec_eq(x_513, x_516);
if (x_517 == 0)
{
uint32_t x_518; uint8_t x_519; 
x_518 = 39;
x_519 = lean_uint32_dec_eq(x_513, x_518);
if (x_519 == 0)
{
uint32_t x_520; uint8_t x_521; 
x_520 = 34;
x_521 = lean_uint32_dec_eq(x_513, x_520);
if (x_521 == 0)
{
uint32_t x_522; uint8_t x_523; 
x_522 = 32;
x_523 = lean_uint32_dec_eq(x_513, x_522);
if (x_523 == 0)
{
uint32_t x_524; uint8_t x_525; 
x_524 = 9;
x_525 = lean_uint32_dec_eq(x_513, x_524);
if (x_525 == 0)
{
uint32_t x_526; uint8_t x_527; 
x_526 = 10;
x_527 = lean_uint32_dec_eq(x_513, x_526);
if (x_527 == 0)
{
lean_object* x_528; lean_object* x_529; 
if (lean_is_scalar(x_503)) {
 x_528 = lean_alloc_ctor(0, 2, 0);
} else {
 x_528 = x_503;
}
lean_ctor_set(x_528, 0, x_501);
lean_ctor_set(x_528, 1, x_502);
x_529 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_529, 0, x_515);
lean_ctor_set(x_529, 1, x_528);
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_530; lean_object* x_531; lean_object* x_532; lean_object* x_533; lean_object* x_534; 
x_530 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_531 = lean_string_push(x_530, x_513);
x_532 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_532, 0, x_531);
if (lean_is_scalar(x_500)) {
 x_533 = lean_alloc_ctor(0, 2, 0);
} else {
 x_533 = x_500;
}
lean_ctor_set(x_533, 0, x_532);
lean_ctor_set(x_533, 1, x_529);
x_534 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_534, 0, x_533);
x_3 = x_534;
goto block_9;
}
else
{
lean_object* x_535; lean_object* x_536; lean_object* x_537; lean_object* x_538; lean_object* x_539; lean_object* x_540; 
x_535 = lean_ctor_get(x_499, 0);
lean_inc(x_535);
if (lean_is_exclusive(x_499)) {
 lean_ctor_release(x_499, 0);
 x_536 = x_499;
} else {
 lean_dec_ref(x_499);
 x_536 = lean_box(0);
}
x_537 = lean_string_push(x_535, x_513);
if (lean_is_scalar(x_536)) {
 x_538 = lean_alloc_ctor(1, 1, 0);
} else {
 x_538 = x_536;
}
lean_ctor_set(x_538, 0, x_537);
if (lean_is_scalar(x_500)) {
 x_539 = lean_alloc_ctor(0, 2, 0);
} else {
 x_539 = x_500;
}
lean_ctor_set(x_539, 0, x_538);
lean_ctor_set(x_539, 1, x_529);
x_540 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_540, 0, x_539);
x_3 = x_540;
goto block_9;
}
}
else
{
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_541; lean_object* x_542; lean_object* x_543; lean_object* x_544; 
if (lean_is_scalar(x_503)) {
 x_541 = lean_alloc_ctor(0, 2, 0);
} else {
 x_541 = x_503;
}
lean_ctor_set(x_541, 0, x_501);
lean_ctor_set(x_541, 1, x_502);
x_542 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_542, 0, x_515);
lean_ctor_set(x_542, 1, x_541);
if (lean_is_scalar(x_500)) {
 x_543 = lean_alloc_ctor(0, 2, 0);
} else {
 x_543 = x_500;
}
lean_ctor_set(x_543, 0, x_499);
lean_ctor_set(x_543, 1, x_542);
x_544 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_544, 0, x_543);
x_3 = x_544;
goto block_9;
}
else
{
lean_object* x_545; lean_object* x_546; lean_object* x_547; lean_object* x_548; lean_object* x_549; lean_object* x_550; 
x_545 = lean_ctor_get(x_499, 0);
lean_inc(x_545);
lean_dec(x_499);
x_546 = lean_array_push(x_501, x_545);
if (lean_is_scalar(x_503)) {
 x_547 = lean_alloc_ctor(0, 2, 0);
} else {
 x_547 = x_503;
}
lean_ctor_set(x_547, 0, x_546);
lean_ctor_set(x_547, 1, x_502);
x_548 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_548, 0, x_515);
lean_ctor_set(x_548, 1, x_547);
lean_inc(x_1);
if (lean_is_scalar(x_500)) {
 x_549 = lean_alloc_ctor(0, 2, 0);
} else {
 x_549 = x_500;
}
lean_ctor_set(x_549, 0, x_1);
lean_ctor_set(x_549, 1, x_548);
x_550 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_550, 0, x_549);
x_3 = x_550;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_551; lean_object* x_552; lean_object* x_553; lean_object* x_554; 
if (lean_is_scalar(x_503)) {
 x_551 = lean_alloc_ctor(0, 2, 0);
} else {
 x_551 = x_503;
}
lean_ctor_set(x_551, 0, x_501);
lean_ctor_set(x_551, 1, x_502);
x_552 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_552, 0, x_515);
lean_ctor_set(x_552, 1, x_551);
if (lean_is_scalar(x_500)) {
 x_553 = lean_alloc_ctor(0, 2, 0);
} else {
 x_553 = x_500;
}
lean_ctor_set(x_553, 0, x_499);
lean_ctor_set(x_553, 1, x_552);
x_554 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_554, 0, x_553);
x_3 = x_554;
goto block_9;
}
else
{
lean_object* x_555; lean_object* x_556; lean_object* x_557; lean_object* x_558; lean_object* x_559; lean_object* x_560; 
x_555 = lean_ctor_get(x_499, 0);
lean_inc(x_555);
lean_dec(x_499);
x_556 = lean_array_push(x_501, x_555);
if (lean_is_scalar(x_503)) {
 x_557 = lean_alloc_ctor(0, 2, 0);
} else {
 x_557 = x_503;
}
lean_ctor_set(x_557, 0, x_556);
lean_ctor_set(x_557, 1, x_502);
x_558 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_558, 0, x_515);
lean_ctor_set(x_558, 1, x_557);
lean_inc(x_1);
if (lean_is_scalar(x_500)) {
 x_559 = lean_alloc_ctor(0, 2, 0);
} else {
 x_559 = x_500;
}
lean_ctor_set(x_559, 0, x_1);
lean_ctor_set(x_559, 1, x_558);
x_560 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_560, 0, x_559);
x_3 = x_560;
goto block_9;
}
}
}
else
{
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_561; lean_object* x_562; lean_object* x_563; lean_object* x_564; 
if (lean_is_scalar(x_503)) {
 x_561 = lean_alloc_ctor(0, 2, 0);
} else {
 x_561 = x_503;
}
lean_ctor_set(x_561, 0, x_501);
lean_ctor_set(x_561, 1, x_502);
x_562 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_562, 0, x_515);
lean_ctor_set(x_562, 1, x_561);
if (lean_is_scalar(x_500)) {
 x_563 = lean_alloc_ctor(0, 2, 0);
} else {
 x_563 = x_500;
}
lean_ctor_set(x_563, 0, x_499);
lean_ctor_set(x_563, 1, x_562);
x_564 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_564, 0, x_563);
x_3 = x_564;
goto block_9;
}
else
{
lean_object* x_565; lean_object* x_566; lean_object* x_567; lean_object* x_568; lean_object* x_569; lean_object* x_570; 
x_565 = lean_ctor_get(x_499, 0);
lean_inc(x_565);
lean_dec(x_499);
x_566 = lean_array_push(x_501, x_565);
if (lean_is_scalar(x_503)) {
 x_567 = lean_alloc_ctor(0, 2, 0);
} else {
 x_567 = x_503;
}
lean_ctor_set(x_567, 0, x_566);
lean_ctor_set(x_567, 1, x_502);
x_568 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_568, 0, x_515);
lean_ctor_set(x_568, 1, x_567);
lean_inc(x_1);
if (lean_is_scalar(x_500)) {
 x_569 = lean_alloc_ctor(0, 2, 0);
} else {
 x_569 = x_500;
}
lean_ctor_set(x_569, 0, x_1);
lean_ctor_set(x_569, 1, x_568);
x_570 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_570, 0, x_569);
x_3 = x_570;
goto block_9;
}
}
}
else
{
lean_object* x_571; lean_object* x_572; lean_object* x_573; 
x_571 = lean_box(2);
if (lean_is_scalar(x_503)) {
 x_572 = lean_alloc_ctor(0, 2, 0);
} else {
 x_572 = x_503;
}
lean_ctor_set(x_572, 0, x_501);
lean_ctor_set(x_572, 1, x_571);
x_573 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_573, 0, x_515);
lean_ctor_set(x_573, 1, x_572);
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_574; lean_object* x_575; lean_object* x_576; 
x_574 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
if (lean_is_scalar(x_500)) {
 x_575 = lean_alloc_ctor(0, 2, 0);
} else {
 x_575 = x_500;
}
lean_ctor_set(x_575, 0, x_574);
lean_ctor_set(x_575, 1, x_573);
x_576 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_576, 0, x_575);
x_3 = x_576;
goto block_9;
}
else
{
lean_object* x_577; lean_object* x_578; lean_object* x_579; lean_object* x_580; lean_object* x_581; 
x_577 = lean_ctor_get(x_499, 0);
lean_inc(x_577);
if (lean_is_exclusive(x_499)) {
 lean_ctor_release(x_499, 0);
 x_578 = x_499;
} else {
 lean_dec_ref(x_499);
 x_578 = lean_box(0);
}
if (lean_is_scalar(x_578)) {
 x_579 = lean_alloc_ctor(1, 1, 0);
} else {
 x_579 = x_578;
}
lean_ctor_set(x_579, 0, x_577);
if (lean_is_scalar(x_500)) {
 x_580 = lean_alloc_ctor(0, 2, 0);
} else {
 x_580 = x_500;
}
lean_ctor_set(x_580, 0, x_579);
lean_ctor_set(x_580, 1, x_573);
x_581 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_581, 0, x_580);
x_3 = x_581;
goto block_9;
}
}
}
else
{
lean_object* x_582; lean_object* x_583; lean_object* x_584; 
x_582 = lean_box(1);
if (lean_is_scalar(x_503)) {
 x_583 = lean_alloc_ctor(0, 2, 0);
} else {
 x_583 = x_503;
}
lean_ctor_set(x_583, 0, x_501);
lean_ctor_set(x_583, 1, x_582);
x_584 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_584, 0, x_515);
lean_ctor_set(x_584, 1, x_583);
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_585; lean_object* x_586; lean_object* x_587; 
x_585 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2;
if (lean_is_scalar(x_500)) {
 x_586 = lean_alloc_ctor(0, 2, 0);
} else {
 x_586 = x_500;
}
lean_ctor_set(x_586, 0, x_585);
lean_ctor_set(x_586, 1, x_584);
x_587 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_587, 0, x_586);
x_3 = x_587;
goto block_9;
}
else
{
lean_object* x_588; lean_object* x_589; lean_object* x_590; lean_object* x_591; lean_object* x_592; 
x_588 = lean_ctor_get(x_499, 0);
lean_inc(x_588);
if (lean_is_exclusive(x_499)) {
 lean_ctor_release(x_499, 0);
 x_589 = x_499;
} else {
 lean_dec_ref(x_499);
 x_589 = lean_box(0);
}
if (lean_is_scalar(x_589)) {
 x_590 = lean_alloc_ctor(1, 1, 0);
} else {
 x_590 = x_589;
}
lean_ctor_set(x_590, 0, x_588);
if (lean_is_scalar(x_500)) {
 x_591 = lean_alloc_ctor(0, 2, 0);
} else {
 x_591 = x_500;
}
lean_ctor_set(x_591, 0, x_590);
lean_ctor_set(x_591, 1, x_584);
x_592 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_592, 0, x_591);
x_3 = x_592;
goto block_9;
}
}
}
else
{
lean_object* x_593; lean_object* x_594; lean_object* x_595; lean_object* x_596; lean_object* x_597; 
x_593 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_593, 0, x_502);
if (lean_is_scalar(x_503)) {
 x_594 = lean_alloc_ctor(0, 2, 0);
} else {
 x_594 = x_503;
}
lean_ctor_set(x_594, 0, x_501);
lean_ctor_set(x_594, 1, x_593);
x_595 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_595, 0, x_515);
lean_ctor_set(x_595, 1, x_594);
if (lean_is_scalar(x_500)) {
 x_596 = lean_alloc_ctor(0, 2, 0);
} else {
 x_596 = x_500;
}
lean_ctor_set(x_596, 0, x_499);
lean_ctor_set(x_596, 1, x_595);
x_597 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_597, 0, x_596);
x_3 = x_597;
goto block_9;
}
}
case 1:
{
uint32_t x_598; uint8_t x_599; 
x_598 = 39;
x_599 = lean_uint32_dec_eq(x_513, x_598);
if (x_599 == 0)
{
lean_object* x_600; lean_object* x_601; 
if (lean_is_scalar(x_503)) {
 x_600 = lean_alloc_ctor(0, 2, 0);
} else {
 x_600 = x_503;
}
lean_ctor_set(x_600, 0, x_501);
lean_ctor_set(x_600, 1, x_502);
x_601 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_601, 0, x_515);
lean_ctor_set(x_601, 1, x_600);
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_602; lean_object* x_603; lean_object* x_604; lean_object* x_605; lean_object* x_606; 
x_602 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_603 = lean_string_push(x_602, x_513);
x_604 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_604, 0, x_603);
if (lean_is_scalar(x_500)) {
 x_605 = lean_alloc_ctor(0, 2, 0);
} else {
 x_605 = x_500;
}
lean_ctor_set(x_605, 0, x_604);
lean_ctor_set(x_605, 1, x_601);
x_606 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_606, 0, x_605);
x_3 = x_606;
goto block_9;
}
else
{
lean_object* x_607; lean_object* x_608; lean_object* x_609; lean_object* x_610; lean_object* x_611; lean_object* x_612; 
x_607 = lean_ctor_get(x_499, 0);
lean_inc(x_607);
if (lean_is_exclusive(x_499)) {
 lean_ctor_release(x_499, 0);
 x_608 = x_499;
} else {
 lean_dec_ref(x_499);
 x_608 = lean_box(0);
}
x_609 = lean_string_push(x_607, x_513);
if (lean_is_scalar(x_608)) {
 x_610 = lean_alloc_ctor(1, 1, 0);
} else {
 x_610 = x_608;
}
lean_ctor_set(x_610, 0, x_609);
if (lean_is_scalar(x_500)) {
 x_611 = lean_alloc_ctor(0, 2, 0);
} else {
 x_611 = x_500;
}
lean_ctor_set(x_611, 0, x_610);
lean_ctor_set(x_611, 1, x_601);
x_612 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_612, 0, x_611);
x_3 = x_612;
goto block_9;
}
}
else
{
lean_object* x_613; lean_object* x_614; lean_object* x_615; lean_object* x_616; lean_object* x_617; 
x_613 = lean_box(0);
if (lean_is_scalar(x_503)) {
 x_614 = lean_alloc_ctor(0, 2, 0);
} else {
 x_614 = x_503;
}
lean_ctor_set(x_614, 0, x_501);
lean_ctor_set(x_614, 1, x_613);
x_615 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_615, 0, x_515);
lean_ctor_set(x_615, 1, x_614);
if (lean_is_scalar(x_500)) {
 x_616 = lean_alloc_ctor(0, 2, 0);
} else {
 x_616 = x_500;
}
lean_ctor_set(x_616, 0, x_499);
lean_ctor_set(x_616, 1, x_615);
x_617 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_617, 0, x_616);
x_3 = x_617;
goto block_9;
}
}
case 2:
{
uint32_t x_618; uint8_t x_619; 
x_618 = 34;
x_619 = lean_uint32_dec_eq(x_513, x_618);
if (x_619 == 0)
{
uint32_t x_620; uint8_t x_621; 
x_620 = 92;
x_621 = lean_uint32_dec_eq(x_513, x_620);
if (x_621 == 0)
{
lean_object* x_622; lean_object* x_623; 
if (lean_is_scalar(x_503)) {
 x_622 = lean_alloc_ctor(0, 2, 0);
} else {
 x_622 = x_503;
}
lean_ctor_set(x_622, 0, x_501);
lean_ctor_set(x_622, 1, x_502);
x_623 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_623, 0, x_515);
lean_ctor_set(x_623, 1, x_622);
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_624; lean_object* x_625; lean_object* x_626; lean_object* x_627; lean_object* x_628; 
x_624 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_625 = lean_string_push(x_624, x_513);
x_626 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_626, 0, x_625);
if (lean_is_scalar(x_500)) {
 x_627 = lean_alloc_ctor(0, 2, 0);
} else {
 x_627 = x_500;
}
lean_ctor_set(x_627, 0, x_626);
lean_ctor_set(x_627, 1, x_623);
x_628 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_628, 0, x_627);
x_3 = x_628;
goto block_9;
}
else
{
lean_object* x_629; lean_object* x_630; lean_object* x_631; lean_object* x_632; lean_object* x_633; lean_object* x_634; 
x_629 = lean_ctor_get(x_499, 0);
lean_inc(x_629);
if (lean_is_exclusive(x_499)) {
 lean_ctor_release(x_499, 0);
 x_630 = x_499;
} else {
 lean_dec_ref(x_499);
 x_630 = lean_box(0);
}
x_631 = lean_string_push(x_629, x_513);
if (lean_is_scalar(x_630)) {
 x_632 = lean_alloc_ctor(1, 1, 0);
} else {
 x_632 = x_630;
}
lean_ctor_set(x_632, 0, x_631);
if (lean_is_scalar(x_500)) {
 x_633 = lean_alloc_ctor(0, 2, 0);
} else {
 x_633 = x_500;
}
lean_ctor_set(x_633, 0, x_632);
lean_ctor_set(x_633, 1, x_623);
x_634 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_634, 0, x_633);
x_3 = x_634;
goto block_9;
}
}
else
{
lean_object* x_635; lean_object* x_636; lean_object* x_637; lean_object* x_638; lean_object* x_639; 
x_635 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_635, 0, x_502);
if (lean_is_scalar(x_503)) {
 x_636 = lean_alloc_ctor(0, 2, 0);
} else {
 x_636 = x_503;
}
lean_ctor_set(x_636, 0, x_501);
lean_ctor_set(x_636, 1, x_635);
x_637 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_637, 0, x_515);
lean_ctor_set(x_637, 1, x_636);
if (lean_is_scalar(x_500)) {
 x_638 = lean_alloc_ctor(0, 2, 0);
} else {
 x_638 = x_500;
}
lean_ctor_set(x_638, 0, x_499);
lean_ctor_set(x_638, 1, x_637);
x_639 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_639, 0, x_638);
x_3 = x_639;
goto block_9;
}
}
else
{
lean_object* x_640; lean_object* x_641; lean_object* x_642; lean_object* x_643; lean_object* x_644; 
x_640 = lean_box(0);
if (lean_is_scalar(x_503)) {
 x_641 = lean_alloc_ctor(0, 2, 0);
} else {
 x_641 = x_503;
}
lean_ctor_set(x_641, 0, x_501);
lean_ctor_set(x_641, 1, x_640);
x_642 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_642, 0, x_515);
lean_ctor_set(x_642, 1, x_641);
if (lean_is_scalar(x_500)) {
 x_643 = lean_alloc_ctor(0, 2, 0);
} else {
 x_643 = x_500;
}
lean_ctor_set(x_643, 0, x_499);
lean_ctor_set(x_643, 1, x_642);
x_644 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_644, 0, x_643);
x_3 = x_644;
goto block_9;
}
}
default: 
{
lean_object* x_645; lean_object* x_646; lean_object* x_647; lean_object* x_648; 
x_645 = lean_ctor_get(x_502, 0);
lean_inc(x_645);
if (lean_is_exclusive(x_502)) {
 lean_ctor_release(x_502, 0);
 x_646 = x_502;
} else {
 lean_dec_ref(x_502);
 x_646 = lean_box(0);
}
if (lean_is_scalar(x_503)) {
 x_647 = lean_alloc_ctor(0, 2, 0);
} else {
 x_647 = x_503;
}
lean_ctor_set(x_647, 0, x_501);
lean_ctor_set(x_647, 1, x_645);
x_648 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_648, 0, x_515);
lean_ctor_set(x_648, 1, x_647);
if (lean_obj_tag(x_499) == 0)
{
lean_object* x_649; lean_object* x_650; lean_object* x_651; lean_object* x_652; lean_object* x_653; 
x_649 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1;
x_650 = lean_string_push(x_649, x_513);
if (lean_is_scalar(x_646)) {
 x_651 = lean_alloc_ctor(1, 1, 0);
} else {
 x_651 = x_646;
 lean_ctor_set_tag(x_651, 1);
}
lean_ctor_set(x_651, 0, x_650);
if (lean_is_scalar(x_500)) {
 x_652 = lean_alloc_ctor(0, 2, 0);
} else {
 x_652 = x_500;
}
lean_ctor_set(x_652, 0, x_651);
lean_ctor_set(x_652, 1, x_648);
x_653 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_653, 0, x_652);
x_3 = x_653;
goto block_9;
}
else
{
lean_object* x_654; lean_object* x_655; lean_object* x_656; lean_object* x_657; lean_object* x_658; lean_object* x_659; 
x_654 = lean_ctor_get(x_499, 0);
lean_inc(x_654);
if (lean_is_exclusive(x_499)) {
 lean_ctor_release(x_499, 0);
 x_655 = x_499;
} else {
 lean_dec_ref(x_499);
 x_655 = lean_box(0);
}
x_656 = lean_string_push(x_654, x_513);
if (lean_is_scalar(x_655)) {
 x_657 = lean_alloc_ctor(1, 1, 0);
} else {
 x_657 = x_655;
}
lean_ctor_set(x_657, 0, x_656);
if (lean_is_scalar(x_500)) {
 x_658 = lean_alloc_ctor(0, 2, 0);
} else {
 x_658 = x_500;
}
lean_ctor_set(x_658, 0, x_657);
lean_ctor_set(x_658, 1, x_648);
if (lean_is_scalar(x_646)) {
 x_659 = lean_alloc_ctor(1, 1, 0);
} else {
 x_659 = x_646;
 lean_ctor_set_tag(x_659, 1);
}
lean_ctor_set(x_659, 0, x_658);
x_3 = x_659;
goto block_9;
}
}
}
}
}
block_9:
{
if (lean_obj_tag(x_3) == 0)
{
uint8_t x_4; 
lean_dec(x_1);
x_4 = !lean_is_exclusive(x_3);
if (x_4 == 0)
{
lean_ctor_set_tag(x_3, 1);
return x_3;
}
else
{
lean_object* x_5; lean_object* x_6; 
x_5 = lean_ctor_get(x_3, 0);
lean_inc(x_5);
lean_dec(x_3);
x_6 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_6, 0, x_5);
return x_6;
}
}
else
{
lean_object* x_7; 
x_7 = lean_ctor_get(x_3, 0);
lean_inc(x_7);
lean_dec(x_3);
x_2 = x_7;
goto _start;
}
}
}
}
LEAN_EXPORT lean_object* l_FPLeanZh_Commands_Shell_shlex___lambda__1(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_3, 0, x_1);
return x_3;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__1() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = lean_box(0);
x_2 = lean_array_mk(x_1);
return x_2;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__2() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_FPLeanZh_Commands_Shell_shlex___closed__1;
x_2 = lean_box(0);
x_3 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_3, 0, x_1);
lean_ctor_set(x_3, 1, x_2);
return x_3;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__3() {
_start:
{
lean_object* x_1; 
x_1 = lean_alloc_closure((void*)(l_FPLeanZh_Commands_Shell_shlex___lambda__1___boxed), 2, 0);
return x_1;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__4() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("Unclosed single quote", 21, 21);
return x_1;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__5() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_FPLeanZh_Commands_Shell_shlex___closed__4;
x_2 = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__6() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("Unclosed double quote", 21, 21);
return x_1;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__7() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_FPLeanZh_Commands_Shell_shlex___closed__6;
x_2 = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__8() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("Unterminated escape", 19, 19);
return x_1;
}
}
static lean_object* _init_l_FPLeanZh_Commands_Shell_shlex___closed__9() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_FPLeanZh_Commands_Shell_shlex___closed__8;
x_2 = lean_alloc_ctor(0, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_FPLeanZh_Commands_Shell_shlex(lean_object* x_1) {
_start:
{
lean_object* x_2; lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; 
x_2 = lean_unsigned_to_nat(0u);
x_3 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_3, 0, x_1);
lean_ctor_set(x_3, 1, x_2);
x_4 = lean_box(0);
x_5 = l_FPLeanZh_Commands_Shell_shlex___closed__2;
x_6 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_6, 0, x_3);
lean_ctor_set(x_6, 1, x_5);
x_7 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_7, 0, x_4);
lean_ctor_set(x_7, 1, x_6);
x_8 = l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1(x_4, x_7);
x_9 = lean_ctor_get(x_8, 0);
lean_inc(x_9);
lean_dec(x_8);
x_10 = lean_ctor_get(x_9, 1);
lean_inc(x_10);
x_11 = lean_ctor_get(x_10, 1);
lean_inc(x_11);
lean_dec(x_10);
x_12 = lean_ctor_get(x_11, 1);
lean_inc(x_12);
switch (lean_obj_tag(x_12)) {
case 0:
{
lean_object* x_13; lean_object* x_14; lean_object* x_15; 
x_13 = lean_ctor_get(x_9, 0);
lean_inc(x_13);
lean_dec(x_9);
x_14 = lean_ctor_get(x_11, 0);
lean_inc(x_14);
lean_dec(x_11);
x_15 = l_FPLeanZh_Commands_Shell_shlex___closed__3;
if (lean_obj_tag(x_13) == 0)
{
lean_object* x_16; lean_object* x_17; 
x_16 = lean_box(0);
x_17 = lean_apply_2(x_15, x_14, x_16);
return x_17;
}
else
{
lean_object* x_18; lean_object* x_19; lean_object* x_20; lean_object* x_21; 
x_18 = lean_ctor_get(x_13, 0);
lean_inc(x_18);
lean_dec(x_13);
x_19 = lean_array_push(x_14, x_18);
x_20 = lean_box(0);
x_21 = lean_apply_2(x_15, x_19, x_20);
return x_21;
}
}
case 1:
{
lean_object* x_22; 
lean_dec(x_11);
lean_dec(x_9);
x_22 = l_FPLeanZh_Commands_Shell_shlex___closed__5;
return x_22;
}
case 2:
{
lean_object* x_23; 
lean_dec(x_11);
lean_dec(x_9);
x_23 = l_FPLeanZh_Commands_Shell_shlex___closed__7;
return x_23;
}
default: 
{
lean_object* x_24; 
lean_dec(x_12);
lean_dec(x_11);
lean_dec(x_9);
x_24 = l_FPLeanZh_Commands_Shell_shlex___closed__9;
return x_24;
}
}
}
}
LEAN_EXPORT lean_object* l_FPLeanZh_Commands_Shell_shlex___lambda__1___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_FPLeanZh_Commands_Shell_shlex___lambda__1(x_1, x_2);
lean_dec(x_2);
return x_3;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_FPLeanZh_Examples_Commands_ShLex(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1 = _init_l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1();
lean_mark_persistent(l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__1);
l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2 = _init_l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2();
lean_mark_persistent(l_Lean_Loop_forIn_loop___at_FPLeanZh_Commands_Shell_shlex___spec__1___closed__2);
l_FPLeanZh_Commands_Shell_shlex___closed__1 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__1();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__1);
l_FPLeanZh_Commands_Shell_shlex___closed__2 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__2();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__2);
l_FPLeanZh_Commands_Shell_shlex___closed__3 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__3();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__3);
l_FPLeanZh_Commands_Shell_shlex___closed__4 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__4();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__4);
l_FPLeanZh_Commands_Shell_shlex___closed__5 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__5();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__5);
l_FPLeanZh_Commands_Shell_shlex___closed__6 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__6();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__6);
l_FPLeanZh_Commands_Shell_shlex___closed__7 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__7();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__7);
l_FPLeanZh_Commands_Shell_shlex___closed__8 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__8();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__8);
l_FPLeanZh_Commands_Shell_shlex___closed__9 = _init_l_FPLeanZh_Commands_Shell_shlex___closed__9();
lean_mark_persistent(l_FPLeanZh_Commands_Shell_shlex___closed__9);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
