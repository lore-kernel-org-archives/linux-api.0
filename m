From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [patch 2/4] docs: procfs -- Document timerfd output
Date: Wed, 16 Jul 2014 01:54:53 +0400
Message-ID: <20140715215703.199905126@openvz.org>
References: <20140715215451.499191426@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=timerfd-doc-fdinfo
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 Documentation/filesystems/proc.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -1743,6 +1743,25 @@ pair provide additional information part
 	While the first three lines are mandatory and always printed, the rest is
 	optional and may be omitted if no marks created yet.
 
+	Timerfd files
+	~~~~~~~~~~~~~
+
+	pos:	0
+	flags:	02
+	mnt_id:	9
+	clockid: 0
+	ticks: 0
+	settime flags: 01
+	it_value: (0, 49406829)
+	it_interval: (1, 0)
+
+	where 'clockid' is the clock type and 'ticks' is the number of the timer expirations
+	that have occurred [see timerfd_create(2) for details]. 'settime flags' are
+	flags in octal form been used to setup the timer [see timerfd_settime(2) for
+	details]. 'it_value' is remaining time until the timer exiration.
+	'it_interval' is the interval for the timer. Note the timer might be set up
+	with TIMER_ABSTIME option which will be shown in 'settime flags', but 'it_value'
+	still exhibits timer's remaining time.
 
 ------------------------------------------------------------------------------
 Configuring procfs
