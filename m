From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] [man-pages] adjtimex.2: document clock_adjtime
Date: Mon, 20 Nov 2017 23:53:02 +0100
Message-ID: <20171120225302.3379657-1-arnd@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I was experimenting with some possible changes to adjtimex(2) and
clock_adjtime(2) and tried to look up the man page to see what the
documented behavior is when I noticed that clock_adjtime() appears
to be the only system call that is currently undocumented.

Before I do any changes to it, this tries to document what I
understand it currently does.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
This is my first patch to man-pages, I'm just guessing about
what should be in there and how to format it, please reword
or reformat as necessary.
---
 man2/adjtimex.2      | 25 +++++++++++++++++++++++--
 man2/clock_adjtime.2 |  1 +
 2 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100644 man2/clock_adjtime.2

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index fc6892d..b7c0a5f 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -35,6 +35,8 @@ adjtimex, ntp_adjtime \- tune kernel clock
 .PP
 .BI "int adjtimex(struct timex *" "buf" );
 .PP
+.BI "int clock_adjtimex(clockid_t " clk_id, " struct timex *" "buf" );
+.PP
 .BI "int ntp_adjtime(struct timex *" buf );
 .fi
 .SH DESCRIPTION
@@ -344,6 +346,12 @@ Attempts to set read-only
 .I status
 bits are silently ignored.
 .\"
+.SS clock_adjtime ()
+The
+.BR clock_adjtime ()
+system call (added in Linux 2.6.39) behaves like adjtimex() but takes an additional
+.IR clk_id
+argument to specify the particular clock on which to act.
 .SS ntp_adjtime ()
 The
 .BR ntp_adjtime ()
@@ -472,6 +480,11 @@ An attempt was made to set
 to a value other than those listed above.
 .TP
 .B EINVAL
+The
+.I clk_id
+specified is not supported on this system.
+.TP
+.B EINVAL
 An attempt was made to set
 .I buf.tick
 to a value outside the range
@@ -482,6 +495,10 @@ where
 .B HZ
 is the system timer interrupt frequency.
 .TP
+.B EOPNOTSUPP
+.I clk_id
+does not support adjustment
+.TP
 .B EPERM
 .I buf.modes
 is neither 0 nor
@@ -503,10 +520,12 @@ T{
 T}	Thread safety	MT-Safe
 .TE
 .SH CONFORMING TO
-Neither of these interfaces is described in POSIX.1
+None of these interfaces is described in POSIX.1
 .PP
 .BR adjtimex ()
-is Linux-specific and should not be used in programs
+and
+.BR clock_adjtimex ()
+are Linux-specific and should not be used in programs
 intended to be portable.
 .PP
 The preferred API for the NTP daemon is
@@ -533,6 +552,8 @@ is done by the kernel in timer context
 Thus, it will take one tick into the second
 for the leap second to be inserted or deleted.
 .SH SEE ALSO
+.BR clock_gettime (2)
+.BR clock_settime (2)
 .BR settimeofday (2),
 .BR adjtime (3),
 .BR ntp_gettime (3),
diff --git a/man2/clock_adjtime.2 b/man2/clock_adjtime.2
new file mode 100644
index 0000000..b08b9c8
--- /dev/null
+++ b/man2/clock_adjtime.2
@@ -0,0 +1 @@
+.so man2/adjtimex.2
-- 
2.9.0
