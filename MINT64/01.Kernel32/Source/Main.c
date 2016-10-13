#include "Types.h"

void k_print_string(int ix, int iy, const char *pc_string);

void main(void)
{
	k_print_string(0,3,"C Language Kernel Started~!!");

	while(1);
}

void k_print_string(int ix, int iy, const char *pc_string)
{
	char_acter *pst_screen = (char_acter*) 0xB8000;
	int i;

	pst_screen += ( iy * 80 ) + ix;

	for(i=0; pc_string[i] != 0;i++)
		pst_screen.b_charactor = pc_string[i];

}