--------------------------------------------------------------------------------
-- Resistor arrays calculations
--------------------------------------------------------------------------------
-- Copyright (C) 2013-2018 Metrostroi Team & FoxWorks Aerospace s.r.o.
-- Contains proprietary code. See license.txt for additional information.
--------------------------------------------------------------------------------
--[[
Rxx   S     P     T     P1    P2    S1     S2   S(XT) P(T)  M(X)
R01 = 3.851 0.000 3.851 0.000 0.000 0.188 0.188 1.000 1.000 0.000
R02 = 3.091 0.000 3.851 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R03 = 2.211 0.000 2.971 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R04 = 1.770 0.000 2.530 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R05 = 1.329 0.000 2.089 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R06 = 1.066 0.000 1.826 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R07 = 0.816 0.000 1.576 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R08 = 0.608 0.000 1.368 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R09 = 0.387 0.000 1.147 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R10 = 0.190 0.000 0.950 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R11 = 0.000 0.000 0.760 0.000 0.000 0.188 0.188 0.000 1.000 0.000
R12 = 0.000 0.000 0.760 0.000 0.000 0.188 0.188 1.000 1.000 0.000
R13 = 0.000 0.000 0.760 0.000 0.000 0.019 0.019 1.000 0.000 0.000

R14 = 0.000 2.211 0.597 1.102 1.109 0.019 0.019 0.000 0.000 0.000
R15 = 0.000 1.329 0.543 0.661 0.668 0.188 0.188 0.000 0.000 0.000
R16 = 0.000 0.816 0.491 0.411 0.405 0.188 0.188 0.000 0.000 0.000
R17 = 0.000 0.387 0.424 0.190 0.197 0.188 0.188 0.000 0.000 0.000
R18 = 0.000 0.000 0.326 0.000 0.000 0.188 0.188 0.000 0.000 0.000
R19 = 0.000 0.000 0.326 0.000 0.000 0.188 0.188 1.000 0.000 0.000
R20 = 0.000 0.000 0.326 0.000 0.000 0.019 0.019 1.000 0.000 0.000
]]--

--------------------------------------------------------------------------------
-- Resistor arrays calculations - auto-generated by gen.lua
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("Gen_Res_702o")

local R = {}

local P14_1
local P1_2
local P2_3
local P3_4
local P4_11
local P13_11
local P12_11
local P9_10
local P8_9
local P7_8
local P6_7
local P10_13

local P20_21
local P21_22
local P23_24
local P24_25

function TRAIN_SYSTEM.InitializeResistances_81_702(Train)
    P14_1 = Train.KF_6A["P14-P1"]
    P1_2 = Train.KF_6A["P1-P2"]
    P2_3 = Train.KF_6A["P2-P3"]
    P3_4 = Train.KF_6A["P3-P4"]
    P4_11 = Train.KF_6A["P4-P11"]
    P13_11 = Train.KF_6A["P13-P11"]
    P10_13 = Train.KF_6A["P10-P13"]
    P12_11 = Train.KF_6A["P12-P11"]
    P9_10 = Train.KF_6A["P9-P10"]
    P8_9 = Train.KF_6A["P8-P9"]
    P7_8 = Train.KF_6A["P7-P8"]
    P6_7 = Train.KF_6A["P6-P7"]

    P20_21 = Train.KF_7A["P20-P21"]
    P21_22 = Train.KF_7A["P21-P22"]
    P23_24 = Train.KF_7A["P23-P24"]
    P24_25 = Train.KF_7A["P24-P25"]
end


function TRAIN_SYSTEM.R1(Train)
	local RK = Train.RheostatController
	local T = Train.PositionSwitch
	local Poff = 1e-9+1e9*(1-RK.P1)
	local Moff = 1e-9+1e9*(1-Train.M.Value)
	local Pon = 1e-9+1e9*(RK.P1)
	local Sh = 1e-9+1e9*(1-Train.SH1.Value)

	R[1] = ((RK[2])^-1 + (P1_2)^-1)^-1
	R[2] = ((RK[4])^-1 + (P2_3+R[1])^-1)^-1
	R[3] = ((RK[6])^-1 + (P3_4+R[2])^-1)^-1
	R[4] = ((RK[10]+Pon+Moff)^-1 + (RK[8])^-1)^-1
	R[5] = ((P13_11)^-1 + (RK[11]+T[12])^-1)^-1
	R[6] = ((RK[13])^-1 + (P10_13)^-1)^-1
	R[7] = ((P4_11+R[3])^-1 + (R[4])^-1)^-1
	R[8] = ((RK[7])^-1 + (RK[9]+Pon+Moff)^-1)^-1
	R[9] = ((RK[1])^-1 + (P6_7)^-1)^-1
	R[10] = ((R[9]+P7_8)^-1 + (RK[3])^-1)^-1
	R[11] = ((P8_9+R[10])^-1 + (RK[5])^-1)^-1
	R[12] = ((R[8])^-1 + (P9_10+R[11])^-1)^-1
	R[13] = ((Pon)*(Poff+T[10]+P14_1)+(Pon)*(R[7])+(Poff+T[10]+P14_1)*(R[7]))/(Pon)
	R[14] = ((Pon)*(Poff+T[10]+P14_1)+(Pon)*(R[7])+(Poff+T[10]+P14_1)*(R[7]))/(Poff+T[10]+P14_1)
	R[15] = ((Pon)*(Poff+T[10]+P14_1)+(Pon)*(R[7])+(Poff+T[10]+P14_1)*(R[7]))/(R[7])
	R[16] = ((Poff)^-1 + (R[14])^-1)^-1
	R[17] = ((R[5]+R[6])*(Poff)+(R[5]+R[6])*(R[12])+(Poff)*(R[12]))/(R[5]+R[6])
	R[18] = ((R[5]+R[6])*(Poff)+(R[5]+R[6])*(R[12])+(Poff)*(R[12]))/(Poff)
	R[19] = ((R[5]+R[6])*(Poff)+(R[5]+R[6])*(R[12])+(Poff)*(R[12]))/(R[12])
	R[20] = ((R[17])^-1 + (Pon)^-1)^-1
	R[21] = ((R[13])^-1 + (R[18])^-1)^-1
	R[22] = ((R[15])*(R[20])+(R[15])*(R[21])+(R[20])*(R[21]))/(R[15])
	R[23] = ((R[15])*(R[20])+(R[15])*(R[21])+(R[20])*(R[21]))/(R[20])
	R[24] = ((R[15])*(R[20])+(R[15])*(R[21])+(R[20])*(R[21]))/(R[21])
	R[25] = ((R[23])^-1 + (R[16])^-1)^-1
	R[26] = ((R[19])^-1 + (R[22])^-1)^-1
	R[27] = ((R[25])*(R[26])+(R[25])*(Moff)+(R[26])*(Moff))/(R[25])
	R[28] = ((R[25])*(R[26])+(R[25])*(Moff)+(R[26])*(Moff))/(R[26])
	R[29] = ((R[25])*(R[26])+(R[25])*(Moff)+(R[26])*(Moff))/(Moff)
	R[30] = ((R[24])^-1 + (R[29])^-1)^-1
	R[31] = ((R[30])^-1 + (R[28]+R[27])^-1)^-1
	return R[31]
end

function TRAIN_SYSTEM.R2C1(Train)
	local RK = Train.RheostatController
	local T = Train.PositionSwitch
	local Poff = 1e-9+1e9*(1-RK.P1)
	local Moff = 1e-9+1e9*(1-Train.M.Value)
	local Pon = 1e-9+1e9*(RK.P1)
	local Sh = 1e-9+1e9*(1-Train.SH1.Value)

	R[1] = ((RK[2])^-1 + (P1_2)^-1)^-1
	R[2] = ((RK[4])^-1 + (P2_3+R[1])^-1)^-1
	R[3] = ((RK[6])^-1 + (P3_4+R[2])^-1)^-1
	R[4] = ((RK[10]+Pon+Moff)^-1 + (RK[8])^-1)^-1
	R[5] = ((P13_11)^-1 + (RK[11]+T[12])^-1)^-1
	R[6] = ((RK[13])^-1 + (P10_13)^-1)^-1
	R[7] = ((Poff+Pon)^-1 + (R[4])^-1)^-1
	R[8] = ((RK[7])^-1 + (Pon+Poff)^-1)^-1
	R[9] = ((R[8])^-1 + (RK[9]+Pon+Moff)^-1)^-1
	R[10] = ((RK[1])^-1 + (P6_7)^-1)^-1
	R[11] = ((R[10]+P7_8)^-1 + (RK[3])^-1)^-1
	R[12] = ((R[11]+P8_9)^-1 + (RK[5])^-1)^-1
	R[13] = ((R[9])^-1 + (R[12]+P9_10)^-1)^-1
	R[14] = ((R[7])^-1 + (P4_11+R[3])^-1)^-1
	R[15] = ((Moff)*(R[5])+(Moff)*(R[14])+(R[5])*(R[14]))/(Moff)
	R[16] = ((Moff)*(R[5])+(Moff)*(R[14])+(R[5])*(R[14]))/(R[5])
	R[17] = ((Moff)*(R[5])+(Moff)*(R[14])+(R[5])*(R[14]))/(R[14])
	R[18] = ((R[15])^-1 + (R[16]+R[17])^-1)^-1
	R[19] = ((R[18])^-1 + (Poff+T[10]+P14_1+R[13]+R[6])^-1)^-1
	return R[19]
end

function TRAIN_SYSTEM.R2C2(Train)
	local RK = Train.RheostatController
	local T = Train.PositionSwitch
	local Poff = 1e-9+1e9*(1-RK.P1)
	local Moff = 1e-9+1e9*(1-Train.M.Value)
	local Pon = 1e-9+1e9*(RK.P1)
	local Sh = 1e-9+1e9*(1-Train.SH1.Value)

	R[1] = ((RK[2])^-1 + (P1_2)^-1)^-1
	R[2] = ((RK[4])^-1 + (P2_3+R[1])^-1)^-1
	R[3] = ((RK[6])^-1 + (P3_4+R[2])^-1)^-1
	R[4] = ((RK[10]+Pon+Moff)^-1 + (RK[8])^-1)^-1
	R[5] = ((P13_11)^-1 + (RK[11]+T[12])^-1)^-1
	R[6] = ((RK[13])^-1 + (P10_13)^-1)^-1
	R[7] = ((Poff+Pon)^-1 + (R[4])^-1)^-1
	R[8] = ((RK[7])^-1 + (Pon+Poff)^-1)^-1
	R[9] = ((R[8])^-1 + (RK[9]+Pon+Moff)^-1)^-1
	R[10] = ((R[7])^-1 + (P4_11+R[3])^-1)^-1
	R[11] = ((RK[1])^-1 + (P6_7)^-1)^-1
	R[12] = ((R[11]+P7_8)^-1 + (RK[3])^-1)^-1
	R[13] = ((R[12]+P8_9)^-1 + (RK[5])^-1)^-1
	R[14] = ((R[9])^-1 + (R[13]+P9_10)^-1)^-1
	R[15] = ((Moff)*(Poff+T[10]+P14_1+R[10])+(Moff)*(R[5]+R[6])+(Poff+T[10]+P14_1+R[10])*(R[5]+R[6]))/(Moff)
	R[16] = ((Moff)*(Poff+T[10]+P14_1+R[10])+(Moff)*(R[5]+R[6])+(Poff+T[10]+P14_1+R[10])*(R[5]+R[6]))/(Poff+T[10]+P14_1+R[10])
	R[17] = ((Moff)*(Poff+T[10]+P14_1+R[10])+(Moff)*(R[5]+R[6])+(Poff+T[10]+P14_1+R[10])*(R[5]+R[6]))/(R[5]+R[6])
	R[18] = ((R[15])^-1 + (R[16]+R[17])^-1)^-1
	R[19] = ((R[18])^-1 + (R[14])^-1)^-1
	return R[19]
end

function TRAIN_SYSTEM.S1(Train)
	local RK = Train.RheostatController
	local T = Train.PositionSwitch
	local Poff = 1e-9+1e9*(1-RK.P1)
	local Moff = 1e-9+1e9*(1-Train.M.Value)
	local Pon = 1e-9+1e9*(RK.P1)
	local Sh = 1e-9+1e9*(1-Train.SH1.Value)

	R[1] = ((P21_22)^-1 + (RK[12])^-1)^-1
	return R[1]+Sh+P20_21
end

function TRAIN_SYSTEM.S2(Train)
	local RK = Train.RheostatController
	local T = Train.PositionSwitch
	local Poff = 1e-9+1e9*(1-RK.P1)
	local Moff = 1e-9+1e9*(1-Train.M.Value)
	local Pon = 1e-9+1e9*(RK.P1)
	local Sh = 1e-9+1e9*(1-Train.SH1.Value)

	R[1] = ((P24_25)^-1 + (RK[12])^-1)^-1
	return R[1]+Sh+P23_24
end

