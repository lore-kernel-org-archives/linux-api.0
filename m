From: Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org>
Subject: Re: [RFC v2 23/24] m68k/mac: Fix PRAM accessors
Date: Tue, 16 Jun 2015 13:10:29 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1506152213340.12762@nippy.intranet>
References: <20150614074607.242676098@telegraphics.com.au> <20150614074613.054681242@telegraphics.com.au> <CAMuHMdWzKvWjAE3u54E4xewEDX+zJqEDEvRmO2twpeD2vmBzog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdWzKvWjAE3u54E4xewEDX+zJqEDEvRmO2twpeD2vmBzog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux/m68k <linux-m68k-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


On Mon, 15 Jun 2015, Geert Uytterhoeven wrote:

> Hi Finn,
> 
> On Sun, Jun 14, 2015 at 9:46 AM, Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org> wrote:
> > --- linux.orig/arch/m68k/mac/misc.c     2015-06-14 17:46:02.000000000 +1000
> > +++ linux/arch/m68k/mac/misc.c  2015-06-14 17:46:03.000000000 +1000
> > @@ -284,11 +287,31 @@ static void via_pram_command(int command
> >
> >  static unsigned char via_pram_read_byte(int offset)
> >  {
> > -       return 0;
> > +       unsigned char temp;
> > +       int addr = ((offset & 0xE0) << 3) | ((offset & 0x1F) << 2);
> 
> Can you please add #defines for the magic values?

This is just marshalling the offset argument. I don't know how to rewrite 
that code more clearly. I'm open to suggestions. I don't know of any 
documentation that gives names or meanings to the different bit ranges. I 
infered the format from the MESS source code, 
https://github.com/mamedev/mame/blob/master/src/mess/machine/macrtc.c

What I found in the MESS source code looks like the result of reverse 
engineering. Hence the RTC code in this patch also looks like a reverse 
engineered driver.

> 
> > +
> > +       /* Use RTC command 0x38 for XPRAM access, as per MESS source code */
> > +       via_pram_command(addr | 0x3800 | 0x8001, &temp);
> 
> It seems 0x38 is already documented in <linux/pmu.h> (see below), or not 
> (it's shifted left by 8 bits?)?

No, this is a RTC command not a PMU command. This RTC device is an Apple 
custom IC that is publicly undocumented. OTOH, the PMU device is well 
documented, since Apple publicly released PMU driver source code in 
MkLinux and later in XNU. That's why I've been able to provide #defines 
for the PMU commands but not the RTC commands.

> 
> > +
> > +       return temp;
> >  }
> >
> >  static void via_pram_write_byte(unsigned char data, int offset)
> >  {
> > +       unsigned char temp;
> > +       int addr = ((offset & 0xE0) << 3) | ((offset & 0x1F) << 2);
> > +
> > +       /* Clear the write protect bit */
> > +       temp = 0x55;
> > +       via_pram_command(0x34 | 0x01, &temp);
> > +
> > +       /* Write the byte to XPRAM */
> > +       temp = data;
> > +       via_pram_command(0x3800 | 0x0001 | addr, &temp);
> > +
> > +       /* Set the write protect bit */
> > +       temp = 0xD5;
> > +       via_pram_command(0x34 | 0x01, &temp);
> 
> More magic values...

When I have reliable documentation I always define macros. So I agree that 
"command" bytes like 0x34 and 0x3800 should have names but what are the 
correct names? Are we constructing an opcode containing RTC register file 
addresses or are we issuing read/write accesses to chip registers?

In my experience with undocumented 68k Mac hardware and its Linux port, 
codified guesswork is worse than no documentation at all. The only useful 
RTC documentation I've ever come across is this: 
http://mac.linux-m68k.org/devel/plushw.php

It tells us that the two least significant bits bits must equal 0b01. What 
would you call that macro? It also tells us that the most significant bit, 
0x80, means "read access" but it only mentions early RTC chips and so it 
does not cover two byte opcodes. Should I have used 0x8080 here?

Whatever your opinion of reverse engineered drivers, the changes in this 
patch are consistent with the rest of the file. E.g. via_read_time() and 
via_write_time(). If/when we have the chip data needed to correctly define 
macros for 0x01, 0x0001, 0x80, 0x8000 or 0x8080, I think they should be 
applied across the entire file, and in a different patch. Inconsistent use 
of such macros would be undesirable IMHO.

> 
> >  }
> >
> >  /*
> > Index: linux/include/uapi/linux/pmu.h
> > ===================================================================
> > --- linux.orig/include/uapi/linux/pmu.h 2015-06-14 17:45:34.000000000 +1000
> > +++ linux/include/uapi/linux/pmu.h      2015-06-14 17:46:03.000000000 +1000
> > @@ -18,7 +18,9 @@
> >  #define PMU_POWER_CTRL         0x11    /* control power of some devices */
> >  #define PMU_ADB_CMD            0x20    /* send ADB packet */
> >  #define PMU_ADB_POLL_OFF       0x21    /* disable ADB auto-poll */
> > +#define PMU_WRITE_XPRAM                0x32    /* write eXtended Parameter RAM */
> >  #define PMU_WRITE_NVRAM                0x33    /* write non-volatile RAM */
> > +#define PMU_READ_XPRAM         0x3a    /* read eXtended Parameter RAM */
> >  #define PMU_READ_NVRAM         0x3b    /* read non-volatile RAM */
> >  #define PMU_SET_RTC            0x30    /* set real-time clock */
> >  #define PMU_READ_RTC           0x38    /* read real-time clock */
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 

-- 
