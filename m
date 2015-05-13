From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH] Documentation/arch: Add Documentation/arch-TODO
Date: Wed, 13 May 2015 10:34:41 +0200
Message-ID: <20150513083441.GA17336@gmail.com>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512144910.0b49c9a7a13336773449db33-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> On Tue, 12 May 2015 23:38:43 +0200 Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > > with the expectation that other architectures will follow along, 
> > > but this doesn't happen.  The arch maintainers simply didn't 
> > > know about it or nobody nags them.  Nothing happens and 
> > > inconsistencies hang around for years.  eg, 
> > > http://lkml.iu.edu/hypermail/linux/kernel/1504.2/04993.html
> > > 
> > > I'm thinking we should find a way to do this better.  One way 
> > > might be to maintain a Documentation/arch-todo which identifies 
> > > each item, has a little list of what-to-do instructions and 
> > > perhaps a list of the not-yet-done architectures.  Basically a 
> > > way for everyone to communicate at the arch maintainers.
> > 
> > If only there was a linux-arch list to which arch maintainers 
> > should subscribe... oh wait :-)
> 
> It was I who got linux-arch established, so I'm fairly familiar with 
> it.  (12 years ago, gad).
> 
> I don't think it's been very successful, particularly for this 
> purpose. A whole pile of randomly cc'ed lkml overflow which we're 
> relying on each individual maintainer to sift through and pluck out 
> particular action items then later remember to implement them.  It's 
> disorganized and has too many cracks for things to fall through.

Yes, a mailing list is indeed not a very good TODO list.

We need a persistent post-it, and Documentation/arch-TODO (note the 
capital letters, we might as well shout?) sounds like a good place.

I'd suggest making it tabular, as per the patch below.

If it gets too large we can split it into multiple tables.

I'd like people to have a good look whether I messed up any entry, and 
I'd be happy to add new items as well.

Thanks,

	Ingo

=======================>
>From 33a487046b16971564d323079f66fb63aa870f4d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 13 May 2015 10:30:11 +0200
Subject: [PATCH] Documentation/arch: Add Documentation/arch-TODO

Add a TODO list for missing/incomplete architecture support
for generic kernel features.

Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/arch-TODO | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/arch-TODO b/Documentation/arch-TODO
new file mode 100644
index 000000000000..bfa289639b1c
--- /dev/null
+++ b/Documentation/arch-TODO
@@ -0,0 +1,47 @@
+
+For generic kernel features that need architecture support, this is
+the feature support matrix, for all upstream Linux architectures:
+
+          ELF-ASLR:----------------------------------------------------------.
+       clockevents:---------------------------------------------------.      |
+modern-timekeeping:--------------------------------------------.      |      |
+              kgdb:-------------------------------------.      |      |      |
+  context-tracking:------------------------------.      |      |      |      |
+    seccomp-filter:-----------------------.      |      |      |      |      |
+       jump-labels:----------------.      |      |      |      |      |      |
+    stackprotector:---------.      |      |      |      |      |      |      |
+           lockdep:--.      |      |      |      |      |      |      |      |
+                     |      |      |      |      |      |      |      |      |
+----------------------------------------------------------------------------------
+  alpha           | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  arc             |  ok  | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  arm             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  | TODO |  ok  |  ok  |
+  arm64           |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  avr32           |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  blackfin        |  ok  | TODO | TODO | TODO | TODO |  ok  | TODO |  ok  | TODO |
+  c6x             | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
+  frv             | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |
+  hexagon         |  ok  | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  ia64            | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |
+  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
+  metag           |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  microblaze      |  ok  | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  mips            |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  mn10300         | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  nios2           | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  openrisc        | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  parisc          | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |
+  powerpc         |  ok  | TODO |  ok  | TODO | TODO |  ok  |  ok  |  ok  |  ok  |
+  s390            |  ok  | TODO |  ok  |  ok  | TODO | TODO |  ok  |  ok  |  ok  |
+  score           |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  sh              |  ok  |  ok  | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  sparc           |  ok  | TODO |  ok  | TODO |  ok  |  ok  |  ok  |  ok  | TODO |
+  tile            |  ok  | TODO | TODO | TODO |  ok  |  ok  |  ok  |  ok  | TODO |
+  um              |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  unicore32       |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  xtensa          |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+----------------------------------------------------------------------------------
+
