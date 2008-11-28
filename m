From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH] ABI Documentation for /proc/timer_list
Date: Fri, 28 Nov 2008 16:37:02 -0500
Message-ID: <cfd18e0f0811281337j57166b4cv54e05296a779252e@mail.gmail.com>
References: <20081121221113.GA13566@tsunami.ccur.com>
	 <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com>
	 <20081125185740.GA21806@tsunami.ccur.com>
	 <20081126164845.GA17394@tsunami.ccur.com>
	 <20081126170715.GA28422@kroah.com>
	 <20081126173410.GA17879@tsunami.ccur.com>
	 <20081126173931.GA1636@kroah.com>
	 <20081126210613.GA20529@tsunami.ccur.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081126210613.GA20529-jPwT5PJblzyhckIl5yWhCw@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Joe,

Some comments and suggestions below.

On Wed, Nov 26, 2008 at 4:06 PM, Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org> wrote:
> Document /proc/timer_list ABI.
>
> This documents all of /timer_list, including the extension
> adding jiffie timers, as proposed in the patch:
>
>   [PATCH] Display active jiffie timers in /proc/timer_list, v2
>
> Signed-off-by: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
>
> Index: 2.6.28-rc6/Documentation/ABI/stable/procfs-timer_list
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ 2.6.28-rc6/Documentation/ABI/stable/procfs-timer_list       2008-11-26 15:55:04.000000000 -0500
> @@ -0,0 +1,96 @@
> +What:          /proc/timer_list
> +Date:          November 2008
> +Contact:       Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
> +               Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> +               Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
> +Revision-Rate: Moderate
> +At-Revision:   0.5
> +Description:
> +               /proc/timer_list displays most everything about every kind
> +               of timer, and some things about time too.
> +
> +               The contents of this file should be expected to change,
> +               as the data displayed corresponds directly to various
> +               kernel-internal data structures.  For this reason, the first
> +               line contains the file revision.  It is the responsibility
> +               of this file's maintainers to bump the revision each time a
> +               kernel is released having incompatible changes in this file.

So, on my 2.6.25 system, I see v0.3.  And I see that by 2.6.28-rc, we
have v0.4.  It would be nice to have some explanation here of what the
x.y version number means in this context.

And where are the differences between versions (e.g., 0.3 and 0.4) documented?

> +               Section Overview
> +               ----------------
> +               The file contains several somewhat independent sections.
> +
> +               The first section contains a few lines of global info.
> +               Examples: file version id, #clock types in the kernel,

IMO, it really helps readers when documentation is written in
something like natural language.  "#clock types" may save you a few
moments of time, but "number of clock types" will probably be clearer
to yout (hopefully many) readers.

But: what does "clock types" refer to?  The HRTIMER_MAX_CLOCK_BASES
line?  If so, that's not obvious from this description.

> +               #nsecs since boot.

See previous comment.

> +
> +               The second section is organized per-cpu.  Each cpu subsection

1,$s/cpu/CPU/g

> +               in turn contains several sub-subsections which are, in order
> +               of appearance:
> +
> +                  The contents of the data structures associated with each
> +                  clock (CLOCK_REALTIME, CLOCK_MONOTONIC, etc) on this cpu.

(How) can I work out whether clock 0 is CLOCK_REALTIME, etc?

> +                  Examples: base, index, resolution, get_timer, offset.

Ahh -- base looks like one of the changes between v0.3 and v0.4...
Would be nice to let the reader know this, perhaps?

Also, how about adding a line on what each of these fields represents.

> +                  Under each of these clocks is, in turn, a display of all
> +                  the active high resolution timers queued to that clock.
> +                  Example: all lines beginning with '#'.
> +
> +                  The contents of per-cpu timer data fields not associated
> +                  with a particular clock type (ie, shared by both clocks or
> +                  not associated with any clock). Examples: expires_next,
> +                  hres_active, nr_event, nohz_mode, all things idle_*,
> +                  tick_stopped, last_jiffies, next_jiffies.

How about adding a line on what each of these fields represents.

> +
> +                  A display of low resolution (ie, jiffie) timer wheel
> +                  data.  Examples: base, running_timer, timer_jiffies.

At the risk of sounding repetitive... How about adding a line on what
each of these fields represents.

> +                  Also under this section is a display, one per line, of
> +                  each active jiffie timer queued to this cpu.  Examples:
> +                  All lines under an 'active jiffie timers' section that
> +                  begin with a number.
> +
> +               The third and final section describes each 'tick device'
> +               known to the kernel.  A tick device is a piece of hardware
> +               capable of generating periodic and/or one shot interrupts

s/one shot/one-shot/

> +               under software control, and thus is capable of generating
> +               the interrupts needed to expire the various active timers at
> +               their given expiration times.  Examples: hpet, pit, lapic.
> +
> +               Hires Timer Layout
> +               ------------------
> +               High resolution timers are displayed on lines that begin

s/High resolution/High-resolution/

> +               with a '#' and always appear under one of the many sections
> +               labeled 'active timers'.  There is an 'active timers'
> +               section for every cpu and every clock.
> +
> +               The fields of a hrtimer, spread out over two lines, are:
> +
> +               line 1 fields:
> +                 1 - unique hrtimer index (#0, #1, #2, etc)
> +                 2 - kernel address of the hrtimer data structure
> +                     in question
> +                 3 - function to be called when timer expires
> +                 4 - timer state (eg, S:01), avail states, OR-able:
> +                     0 - inactive
> +                     1 - enqueued
> +                     2 - callback
> +                     4 - pending
> +                     8 - migrate
> +                 5 - function which created the timer
> +                 6 - process name & pid which created the timer
> +
> +               line 2 fields:
> +                 1 - absolute expiration time, range format (start - end)
> +                 2 - relative expiration time, range format (start - end)
> +
> +               Lowres Timer Layout
> +               -------------------
> +               Low resolution timers are displayed one-per-line under

s/Low resolution/Low-resolution/

> +               sections labeled 'active jiffie timers'.  There is one such
> +               section per cpu.  A lowres timer has the following fields:
> +
> +                 1 - #jiffies remaining until timer expires
> +                 2 - function to be called on expiration
> +                 3 - data value to be given to the above function on
> +                     expiration
> +                 4 - function which created this timer
> +                 5 - name & pid of the process that created this timer

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
