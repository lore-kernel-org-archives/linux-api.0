From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/4] docs: procfs -- Document timerfd output
Date: Mon, 23 Jun 2014 22:54:33 +0400
Message-ID: <20140623190345.423719714@openvz.org>
References: <20140623185431.396309193@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=timerfd-doc-fdinfo
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Andrey Vagin <avagin@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
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
