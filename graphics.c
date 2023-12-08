#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "fs.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

static struct {
    ushort  videobuffer[320 * 200];
    int     brushposition;
} cons_videobuffer;;
//static ushort *video = (ushort*)P2V(0xA0000);  // video memory

static struct {
	int x, y;			// Brush position
	int colour;			// Brush colour
	int isPressed;      // is Drawing
	
} brushinfo;;

void clear320x200x256() {
	// You need to put code to clear the video buffer here.  Initially, 
	// you might just set each pixel to black in a nested loop, but think
	// about faster ways to do it. 
	//
	// This function is called from videosetmode.

	unsigned short* video_memory = (unsigned short*)0xA0000;

	int i;
	for (i=0; i<sizeof(cons_videobuffer.videobuffer); ++i){
		video_memory[i]=0;
	}

	return;

}


int sys_setpixel(void) {
	int uX;
	int uY;

	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}

	unsigned short *video_memory = (unsigned short*)0xA0000;
	int index = uY * 320 + uX;
	video_memory[index] = brushinfo.colour;


	return 1;
}

int sys_moveto(void) {
	int uX;
	int uY;

	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}
	brushinfo.x = uX;
	brushinfo.y = uY;
	

	return 1;
}

int sys_lineto(void) {
	unsigned short *video_memory = (unsigned short*)0xA0000;
	brushinfo.colour = 15;

	int uX;
	int uY;

	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}
	brushinfo.isPressed = 1;

	if (uX < brushinfo.x){	
			for (int i = uX - brushinfo.x; i<=brushinfo.x; i++) {
				video_memory[uY * 320 + uX] = 15;
				uX++;
			}
	}	
	else {
		for (int i = uX + brushinfo.x; i>=brushinfo.x; i--) {
				video_memory[uY * 320 + uX] = 15;
				uX--;
			}
	}
	
	if (uY <= brushinfo.y){	
			for (int i = uY - brushinfo.y; i<=brushinfo.y; i++) {
				video_memory[uY * 320 + uX] = 15;
				uY++;
			}
	}	
	else {
		for (int i = uY + brushinfo.y; i>=brushinfo.y; i--) {
				video_memory[uY * 320 + uX] = 15;
				uY--;
			}
	}
	brushinfo.isPressed = 0;

	return 1;

}