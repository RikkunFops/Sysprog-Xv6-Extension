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
    char  videobuffer[320 * 200];
} cons_videobuffer;;
ushort* video_memory = (unsigned short*)P2V(0xA0000);  // video memory

int indexWritten[255]; 	// Track which colour index has been written

int firstTime;
struct HDC {
	int x, y;			// Brush Position
	int colour;			// Brush Colour
	int pid;			// Brush Process ID
};

#define MAX_PROCESSES 64			
struct HDC hdcArray[MAX_PROCESSES];		// Creates an array of hdcs that can be assigned to processes

void clear320x200x256() {

	int i;
	for (i=0; i<320 * 200; ++i){
		cons_videobuffer.videobuffer[i]=0;
	}
	memmove(video_memory, &cons_videobuffer.videobuffer[0], sizeof(ushort)*320*200);
	return;
}


int sys_setpixel(void) {
	int uX;
	int uY;
	int hdcHandle;
	
	if (argint(0, &hdcHandle) < 0 || argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}
		
		struct HDC* hdc = (struct HDC*)hdcHandle;

		int index =  320 * uY + uX;
		
		cons_videobuffer.videobuffer[index] = hdc->colour;

		memmove(video_memory, &cons_videobuffer.videobuffer[0], sizeof(ushort)*320*200);
		
	return 0;
}

int sys_moveto(void) {
	int uX;
	int uY;
	int hdcHandle; 
	if (argint(0, &hdcHandle) < 0 || argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}
	
	struct HDC* hdc = (struct HDC*)hdcHandle;

	hdc->x = uX;
	hdc->y = uY;

	return 0;
}

void VerticalLine(int hdcHandle, int x, int y1, int y2, int direction) {
	// X will always be the same. Higher Y is lower on the screen
	struct HDC* hdc = (struct HDC*)hdcHandle;
	for (int y = y1; y <= y2; y++) {
		int index = 320 * y + x;
        cons_videobuffer.videobuffer[index] = hdc->colour;
	}
	// Decide which coordinate to save to the brushinfo
	if (direction == 1) {
		hdc->y = y1;
	}
	else {
		hdc->y = y2;
	}
	return;
}

void HorizontalLine(int hdcHandle, int x1, int x2, int y, int direction) {
	// Y will always be the same. 
	struct HDC* hdc = (struct HDC*)hdcHandle;
	for (int x = x1; x <= x2; x++) {
		int index = 320 * y + x;
        cons_videobuffer.videobuffer[index] = hdc->colour;
	}
	if (direction == 1) {
		hdc->x = x1;
	}
	else {
		hdc->x = x2;
	}
	return;
}

void BressenhamLine(int x1, int x2, int y1, int y2, int hdcHandle) {
	struct HDC* hdc = (struct HDC*)hdcHandle;
	int dx = x2-x1;
	int dy = y2-y1;
	
	int m_new = 2 * (y2 - y1); 
    int slope_error_new = m_new - (x2 - x1); 
	int y = y1;
	int y_increment = (dy > 0) ? 1 : -1;

	for (int x = x1; x <= x2; x++) {
        int index = 320 * y + x;
        cons_videobuffer.videobuffer[index] = hdc->colour;
        // Add slope to increment angle formed 
        slope_error_new += m_new;
        // if the slope error reached the limit,  
        // increment y and update slope error. 
        if ((slope_error_new >= 0 && dy > 0) || (slope_error_new <= 0 && dy < 0)) {
            y += y_increment;
            slope_error_new -= 2 * dx;
        }
        cprintf("%d x, %d y | %d\n", x , y , cons_videobuffer.videobuffer[index]);
		hdc->x = x;
        hdc->y = y;
    }
	return;
}


int sys_lineto(void) {
	int hdcHandle;
	int uX;   		// Target X coord
	int uY;			// Target Y coord
	if (argint(0, &hdcHandle) < 0 || argint(1, &uX) < 0 || argint(2, &uY) < 0) {
		return -1;
	}
	struct HDC* hdc = (struct HDC*)hdcHandle;
	int sX = hdc->x; 		// Saved X coord
	int sY = hdc->y; 		// Saved Y coord
	if (uX == sX) {
        // Straight vertical line	
        if (uY < sY) {
			VerticalLine(hdcHandle, sX, uY, sY, 1);
		}
		else {
			VerticalLine(hdcHandle, sX, sY, uY, 0);
		}
    } 
	else if (uY == sY) {
        // Straight horizontal line
        if (uX < sX) {
			HorizontalLine(hdcHandle, uX, sX, sY, 1);
		}
		else {
			HorizontalLine(hdcHandle, sX, uX, sY, 0);
		}
    } 
	else {
		// Diagonal line
		BressenhamLine(sX, uX, sY, uY, hdcHandle);
	}
	memmove(video_memory, &cons_videobuffer.videobuffer[0], sizeof(ushort)*320*200);
	return 1;

}

int sys_setpencolour(void) {
	int index; 
	int r; 
	int g; 
	int b;

	if (argint(0, &index) < 0 || argint(1, &r) < 0 || argint(2, &g) < 0 || argint(3, &b) < 0) {
		return -1;
	}
	cprintf("%d index, %d, r, %d g, %d b\n", index, r, g, b);

	if ( index <= 15 || index > 255 ) {
		cprintf("The index cannot be between 0 and 15, and cannot exceed 255. Try again\n");
	}
	else if (r >= 64 || g >= 64 || b >= 64) {
		cprintf("RGB values can not equal or exceed 64. Try a value between 0-63\n");
	}
	else {
		cprintf("Successfully applied colour to index %d.\n Select it be using setpen.\n", index);
		outb(0x3C8, index);
		outb(0x3C9, r);
		outb(0x3C9, g);
		outb(0x3C9, b);
		if (indexWritten[index] == 1) {
			cprintf("Warning: You have reassigned this index\n");
		}

		indexWritten[index] = 1;
	}

	return 1;
}



int sys_selectpen(void) {
	int index;
	int hdcHandle;
	
	int pid = myproc()->pid;
	cprintf("This system call is PID %d\n", pid);


	if (argint(0, &hdcHandle) <0 || argint(1, &index) < 0) {
		return -1;
	}

	
	
	struct HDC* hdc = (struct HDC*)hdcHandle;

	if ( index <= 15 || indexWritten[index] == 1 ) {	
		hdc->colour = index;

		cprintf("Pen colour is now index %d\n", hdc->colour);

	}
	else {
		cprintf("This colour has not been made. Use makepen to set it up.\n");
	}

	return hdcHandle;
}


int sys_fillrect(void) {
	
	struct Rect *r;
	int hdcHandle;

	if (argint(0, &hdcHandle) < 0 || argptr(1, (void*)&r, sizeof(*r)) < 0) {
		return -1;
	}
	
	cprintf("rect print %d, %d, %d, %d\n", r->x1, r->y1, r->x2, r->y2 );
	int x1 = r->x1;
	int x2 = r->x2;
	int y1 = r->y1;
	int y2 = r->y2;
	
	
	
	if ( y1 < y2 ){
		for (int y = y1; y <= y2; y++) {
			cprintf("using hdc %d\n", hdcHandle);
			HorizontalLine(hdcHandle, x1, x2, y, 0);
		}
	}
	else {
		for (int y = y2; y <= y1; y++) {
			HorizontalLine(hdcHandle, x1, x2, y, 0);
		}
	}

	
	memmove(video_memory, &cons_videobuffer.videobuffer[0], sizeof(ushort)*320*200);
	return 1;
}

void initHdcArray() {
	for (int i = 0; i < MAX_PROCESSES; ++i) {
		hdcArray[i].pid = -1;
		hdcArray[i].colour = 15;
		hdcArray[i].x = 0;
		hdcArray[i].y = 0;
	}
	return;
}


struct HDC* allocateHDC(int pid) {
	for (int i = 0; i < MAX_PROCESSES; ++i){
		if (hdcArray[i].pid == -1) {
			hdcArray[i].pid = pid;
			cprintf("Assigned HDC %d\n", hdcArray[i].pid);
			return &hdcArray[i];
		}
	}
	return 0;
}

void releaseHDC(struct HDC* hdc) {
	hdc->pid = -1;
	hdc->colour = 15;
	hdc->x = 0;
	hdc->y = 0;
	cprintf("%d, %d, %d, %d\n", hdc->pid, hdc->colour, hdc->x, hdc->y);
	return;
}

int sys_beginpaint(void) {
	
	if (firstTime != 1) {
		initHdcArray();
		firstTime = 1;
	}

	struct HDC* hdc = allocateHDC(myproc()->pid);
	//while (hdc == hdc) {
	//	return (int)hdc;
	//}

	cprintf("%d, %d, %d, %d\n", hdc->pid, hdc->colour, hdc->x, hdc->y);
	return (int)hdc;
	
}

int sys_endpaint(void) {
	int hdcHandle;

	if (argint(0, &hdcHandle) < 0) {
		return -1;
	}

	struct HDC* hdc = (struct HDC*)hdcHandle;
	releaseHDC(hdc);
	
	return 0;

}