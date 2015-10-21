From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH] TTY, devpts: document pty count limiting
Date: Wed, 21 Oct 2015 13:08:54 +0300
Message-ID: <20151021100854.7888.90252.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Logic was changed in kernel 3.4 by commit e9aba5158a80 ("tty: rework pty
count limiting") but still isn't documented. Better late than never.

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
---
 Documentation/filesystems/devpts.txt |    9 +++++++++
 Documentation/sysctl/kernel.txt      |    7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/filesystems/devpts.txt b/Documentation/filesystems/devpts.txt
index 68dffd87f9b7..30d2fcb32f72 100644
--- a/Documentation/filesystems/devpts.txt
+++ b/Documentation/filesystems/devpts.txt
@@ -51,6 +51,15 @@ where 'ns_exec -cm /bin/bash' calls clone() with CLONE_NEWNS flag and execs
 /bin/bash in the child process.  A pty created by the sshd is not visible in
 the original mount of /dev/pts.
 
+Total count of pty pairs in all instances is limited by sysctls:
+kernel.pty.max = 4096		- global limit
+kernel.pty.reserve = 1024	- reserve for initial instance
+kernel.pty.nr			- current count of ptys
+
+Per-instance limit could be set by adding mount option "max=<count>".
+This feature was added in kernel 3.4 together with sysctl kernel.pty.reserve.
+In kernels older than 3.4 sysctl kernel.pty.max works as per-instance limit.
+
 User-space changes
 ------------------
 
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6fccb69c03e7..01a42021c2e5 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -63,6 +63,7 @@ show up in /proc/sys/kernel:
 - printk_delay
 - printk_ratelimit
 - printk_ratelimit_burst
+- pty/
 - randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
@@ -683,6 +684,12 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+pty/:
+
+See Documentation/filesystems/devpts.txt.
+
+==============================================================
+
 randomize_va_space:
 
 This option can be used to select the type of process address
