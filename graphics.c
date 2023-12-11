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
unsigned short* video_memory = (unsigned short*)P2V(0xA0000);  // video memory

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
	

	int i;
	for (i=0; i<sizeof(cons_videobuffer.videobuffer); ++i){
		cons_videobuffer.videobuffer[i]=0;
	}
	memmove(video_memory, &cons_videobuffer.videobuffer[0], sizeof(ushort)*320*200);

	return;

}


int sys_setpixel(void) {

	int uX;
	int uY;
	int testindex = 31999;
	brushinfo.colour = 15;
	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}

	for (int i = 20; i>=0; i--)
	{
		
		
		int index =  320 * uY + uX;
		index /= 2;
		cons_videobuffer.videobuffer[index] = 15;
		cons_videobuffer.videobuffer[ testindex] = 15;
		memmove(video_memory, &cons_videobuffer.videobuffer[0], sizeof(ushort)*320*200);
		// Uses the index variable as an index into the array of memory addresses to set a pixel
		cprintf("%d, %d | ", uX, uY);
		cprintf("%d | ", index);
		cprintf("%d\n", video_memory[index]);
		cprintf("test index:\n");
		cprintf("%d | ", testindex);
		cprintf("%d\n", video_memory[testindex]);
		uX += 10;
		uY += 10;
		testindex -= 10;
	}

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
	brushinfo.colour = 15;

	int uX;
	int uY;

	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}


	while (uX > 0)
	{
		
	}


	if (uX < brushinfo.x){	
			for (int i = uX - brushinfo.x; i<=brushinfo.x; i++) {
				cons_videobuffer.videobuffer[uY * 320 + uX] = brushinfo.colour;
				uX++;
			}
	}	
	else {
		for (int i = uX + brushinfo.x; i>=brushinfo.x; i--) {
				cons_videobuffer.videobuffer[uY * 320 + uX] = brushinfo.colour;
				uX--;
			}
	}
	
	if (uY <= brushinfo.y){	
			for (int i = uY - brushinfo.y; i<=brushinfo.y; i++) {
				cons_videobuffer.videobuffer[uY * 320 + uX] = brushinfo.colour;
				uY++;
			}
	}	
	else {
		for (int i = uY + brushinfo.y; i>=brushinfo.y; i--) {
				cons_videobuffer.videobuffer[uY * 320 + uX] = brushinfo.colour;
				uY--;
			}
	}
	brushinfo.isPressed = 0;

	return 1;

}