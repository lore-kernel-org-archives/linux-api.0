From: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Subject: [PATCH] ABI Documentation for /proc/timer_list, v2
Date: Mon, 1 Dec 2008 13:11:06 -0500
Message-ID: <20081201181106.GA18320@tsunami.ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <20081126164845.GA17394@tsunami.ccur.com> <20081126170715.GA28422@kroah.com> <20081126173410.GA17879@tsunami.ccur.com> <20081126173931.GA1636@kroah.com> <20081126210613.GA20529@tsunami.ccur.com> <cfd18e0f0811281337j57166b4cv54e05296a779252e@mail.gmail.com>
Reply-To: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811281337j57166b4cv54e05296a779252e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Document /proc/timer_list ABI, version 2.

This partially documents /timer_list, including the
proposed 'Version 0.5' extensions that add a jiffie timer
display.

v2 exists to address some of the concerns Michael Kerrisk
brought up.  What was left out: I did not document old
versions of /timer_list, I did not document the meaning
of the x.y version numbering system (which only Ingo
can answer anyway), and I did not document fields of
secondary importance that already had adequate 'DocBook'
documentation in the kernel sources.

Signed-off-by: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>

Index: 2.6.28-rc6/Documentation/ABI/stable/procfs-timer_list
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.28-rc6/Documentation/ABI/stable/procfs-timer_list	2008-12-01 13:07:15.000000000 -0500
@@ -0,0 +1,129 @@
+What:		/proc/timer_list
+Date:		November 2008
+Contact:	Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
+		Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
+		Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
+Revision-Rate:	Moderate
+At-Revision:	0.5
+Description:
+		/proc/timer_list displays most everything about every kind
+		of timer, and some things about time too.
+
+		The contents of this file should be expected to change,
+		as the data displayed corresponds directly to various
+		kernel-internal data structures.  For this reason, the first
+		line contains the file revision.  It is the responsibility
+		of this file's maintainers to bump the revision each time a
+		kernel is released having incompatible changes in this file.
+
+		This document covers only the version of /proc/timer_list
+		located in the kernel sources to which it is attached.
+		Documentation for previous (and later) versions of
+		/proc/timer_list is to be found (if they exist) in the
+		kernel sources of those earlier (or later) kernels.
+
+		Section Overview
+		----------------
+		The file contains several somewhat independent sections.
+
+		The first section contains a few lines of global info:
+		   1 - Timer List Version: File revision.
+		   2 - HRTIMER_MAX_CLOCK_BASES: number of clock types that
+		       support high resolution timers.
+		   3 - now at x nsecs: number of nsecs since boot.
+
+		The second section is organized per-CPU.  Each CPU subsection
+		in turn contains several sub-subsections which are, in order
+		of appearance:
+
+		   The contents of the data structures associated with each
+		   clock on this CPU:
+		    1 - clock ID: 0 == CLOCK_REALTIME, 1 == CLOCK_MONOTONIC
+		    2 - base: kernel address of this clock's
+		        hrtimer_clock_base structure.
+		    3 - resolution: resolution of this clock.
+		    4 - get_time: name of kernel function used to fetch
+		        time from this clock.
+		    5 - offset: difference, in nsecs, between this clock
+		        and the reference clock for this clock.
+		   Under each of these clocks is, in turn, a display of all
+		   the active high resolution timers queued to that clock.
+		   These are the lines beginning with '#' and are described
+		   in detail later in this document.
+
+		   The contents of per-CPU hrtimer data fields not
+		   associated with a particular cpu clock (ie, shared by
+		   both clocks or not associated with any clock).  These
+		   are: expires_next, hres_active, nr_event, nohz_mode, all
+		   things idle_*, tick_stopped, last_jiffies, next_jiffies.
+		   The above are field names from 'struct tick_sched' and
+		   'struct hrtimer_cpu_base', documentation for these may
+		   be found in the kernel DocBook.
+
+		   A display of low resolution (ie, jiffie) timer wheel
+		   data.  These are prefixed by the lines:
+		    1 - base: kernel virtual address of the timer wheel
+		        data structure (struct tvec_base) for this cpu.
+		    2 - running timer: kernel virtual address of the
+		        expired timer being processed, NULL if none.
+		    3 - timer_jiffies: what this wheel considers to
+		        be the current time, will be == jiffies or
+			will lag it by a tick or two if it has not
+			caught up with the current time.
+		   Also under this section is a display, one per line, of
+		   each active jiffie timer queued to this CPU.  These are
+		   the lines under an 'active jiffie timers' section that
+		   begin with a number.
+
+		The third and final section describes each 'tick device'
+		known to the kernel.  A tick device is a piece of hardware
+		capable of generating periodic and/or one-shot interrupts
+		under software control, and thus is capable of generating
+		the interrupts needed to expire the various active timers
+		at their given expiration times.  Examples of tick devices:
+		hpet, pit, lapic.  All but the first two lines display
+		fields corresponding to structure elements from 'struct
+		clock_event_device', documentation for which can be found
+		in the kernel Docbook. The first two lines are:
+		  1 - mode: 0 == periodic timer, 1 == one-shot timer
+		  2 - is 'Per CPU device' or is 'Broadcast device'
+
+		Hires Timer Layout
+		------------------
+		High-resolution timers are displayed on lines that begin
+		with a '#' and always appear under one of the many sections
+		labeled 'active timers'.  There is an 'active timers'
+		section for every CPU and every clock.
+
+		The fields of a hrtimer, spread out over two lines, are:
+
+		line 1 fields:
+		  1 - unique hrtimer index (#0, #1, #2, etc)
+		  2 - kernel address of the hrtimer data structure
+		      in question
+		  3 - function to be called when timer expires
+		  4 - timer state (eg, S:01), avail states, OR-able:
+		      0 - inactive
+		      1 - enqueued
+		      2 - callback
+		      4 - pending
+		      8 - migrate
+		  5 - function which created the timer
+		  6 - process name & pid which created the timer
+
+		line 2 fields:
+		  1 - absolute expiration time, range format (start - end)
+		  2 - relative expiration time, range format (start - end)
+
+		Lowres Timer Layout
+		-------------------
+		Low-resolution timers are displayed one-per-line under
+		sections labeled 'active jiffie timers'.  There is one such
+		section per CPU.  A lowres timer has the following fields:
+
+		  1 - number of jiffies remaining until timer expires
+		  2 - function to be called on expiration
+		  3 - data value to be given to the above function on
+		      expiration
+		  4 - function which created this timer
+		  5 - name & pid of the process that created this timer
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
