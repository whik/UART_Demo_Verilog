/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/FPGA_Study/Xilinx/UART_Demo_Verilog/HDL/uart_tx_demo_tb.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};



static void Initial_11_0(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(12, ng0);

LAB2:    xsi_set_current_line(13, ng0);
    t1 = ((char*)((ng1)));
    t2 = (t0 + 1904);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 1);
    xsi_set_current_line(14, ng0);
    t1 = ((char*)((ng1)));
    t2 = (t0 + 2064);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 1);

LAB1:    return;
}

static void Initial_17_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;

LAB0:    t1 = (t0 + 3232U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(18, ng0);

LAB4:    xsi_set_current_line(19, ng0);
    t2 = (t0 + 3040);
    xsi_process_wait(t2, 625000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(20, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 2064);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    goto LAB1;

}

static void Always_23_2(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;

LAB0:    t1 = (t0 + 3480U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(23, ng0);
    t2 = (t0 + 3800);
    *((int *)t2) = 1;
    t3 = (t0 + 3512);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(24, ng0);
    t4 = (t0 + 3288);
    xsi_process_wait(t4, 31300LL);
    *((char **)t1) = &&LAB5;
    goto LAB1;

LAB5:    xsi_set_current_line(24, ng0);
    t6 = (t0 + 1904);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memset(t5, 0, 8);
    t9 = (t8 + 4);
    t10 = *((unsigned int *)t9);
    t11 = (~(t10));
    t12 = *((unsigned int *)t8);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB9;

LAB7:    if (*((unsigned int *)t9) == 0)
        goto LAB6;

LAB8:    t15 = (t5 + 4);
    *((unsigned int *)t5) = 1;
    *((unsigned int *)t15) = 1;

LAB9:    t16 = (t0 + 1904);
    xsi_vlogvar_wait_assign_value(t16, t5, 0, 0, 1, 0LL);
    goto LAB2;

LAB6:    *((unsigned int *)t5) = 1;
    goto LAB9;

}


extern void work_m_00000000002090166470_4107551163_init()
{
	static char *pe[] = {(void *)Initial_11_0,(void *)Initial_17_1,(void *)Always_23_2};
	xsi_register_didat("work_m_00000000002090166470_4107551163", "isim/uart_tx_demo_tb_isim_beh.exe.sim/work/m_00000000002090166470_4107551163.didat");
	xsi_register_executes(pe);
}
