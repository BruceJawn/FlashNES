#ifdef FLASH
#include "flash_sdl.h"
#else
#include "sdl.h"
#endif
#include "throttle.h"

static uint64 tfreq;
static uint64 desiredfps;

void RefreshThrottleFPS(void)
{
       desiredfps=FCEUI_GetDesiredFPS()>>8;
       tfreq=10000000;
       tfreq<<=16;    /* Adjustment for fps returned from FCEUI_GetDesiredFPS(). */
}

void SpeedThrottle(void)
{
  // Don't need to throttle in flash, we let the update timer handle this for us
#ifdef FLASH
    return;
#else
	
 static uint64 ttime,ltime=0;
  
 waiter:
 
 ttime=SDL_GetTicks();
 ttime*=10000;

 if( (ttime-ltime) < (tfreq/desiredfps) )
 {
  int64 delay;
  delay=(tfreq/desiredfps)-(ttime-ltime);
  if(delay>0) 
   SDL_Delay(delay/10000);
  //printf("%d\n",(tfreq/desiredfps)-(ttime-ltime));
  //SDL_Delay((tfreq/desiredfps)-(ttime-ltime));
  goto waiter;
 }
 if( (ttime-ltime) >= (tfreq*4/desiredfps))
  ltime=ttime;
 else
  ltime+=tfreq/desiredfps;

#endif

}

