From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 7/8] fcntl: Don't use ambiguous SIG_POLL si_codes
Date: Fri, 30 Jun 2017 07:39:05 -0500
Message-ID: <20170630123906.8865-7-ebiederm@xmission.com>
References: <87efu22set.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87efu22set.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

We have a weird and problematic intersection of features that when
they all come together result in ambiguous siginfo values, that
we can not support properly.

- Supporting fcntl(F_SETSIG,...) with arbitrary valid signals.

- Using positive values for POLL_IN, POLL_OUT, POLL_MSG, ..., etc
  that imply they are signal specific si_codes and using the
  aforementioned arbitrary signal to deliver them.

- Supporting injection of arbitrary siginfo values for debugging and
  checkpoint/restore.

The result is that just looking at siginfo si_codes of 1 to 6 are
ambigious.  It could either be a signal specific si_code or it could
be a generic si_code.

For most of the kernel this is a non-issue but for sending signals
with siginfo it is impossible to play back the kernel signals and
get the same result.

Strictly speaking when the si_code was changed from SI_SIGIO to
POLL_IN and friends between 2.2 and 2.4 this functionality was not
ambiguous, as only real time signals were supported.  Before 2.4 was
released the kernel began supporting siginfo with non realtime signals
so they could give details of why the signal was sent.

The result is that if F_SETSIG is set to one of the signals with signal
specific si_codes then user space can not know why the signal was sent.

I grepped through a bunch of userspace programs using debian code
search to get a feel for how often people choose a signal that results
in an ambiguous si_code.  I only found one program doing so and it was
using SIGCHLD to test the F_SETSIG functionality, and did not appear
to be a real world usage.

Therefore the ambiguity does not appears to be a real world problem in
practice.  Remove the ambiguity while introducing the smallest chance
of breakage by changing the si_code to SI_SIGIO when signals with
signal specific si_codes are targeted.

Fixes: v2.3.40 -- Added support for queueing non-rt signals
Fixes: v2.3.21 -- Changed the si_code from SI_SIGIO
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/fcntl.c                         | 11 +++++++++++
 include/linux/signal.h             |  8 ++++++++
 include/uapi/asm-generic/siginfo.h |  2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index f4e7267d117f..3c4e17b0082a 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -629,6 +629,17 @@ static void send_sigio_to_task(struct task_struct *p,
 			si.si_signo = signum;
 			si.si_errno = 0;
 		        si.si_code  = reason;
+			/*
+			 * Posix definies POLL_IN and friends to be signal
+			 * specific si_codes for SIG_POLL.  Linux extended
+			 * these si_codes to other signals in a way that is
+			 * ambiguous if other signals also have signal
+			 * specific si_codes.  In that case use SI_SIGIO instead
+			 * to remove the ambiguity.
+			 */
+			if (sig_specific_sicodes(signum))
+				si.si_code = SI_SIGIO;
+
 			/* Make sure we are called with one of the POLL_*
 			   reasons, otherwise we could leak kernel stack into
 			   userspace.  */
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 1f5a16620693..76aff5b861d2 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -385,10 +385,18 @@ int unhandled_signal(struct task_struct *tsk, int sig);
         rt_sigmask(SIGCONT)   |  rt_sigmask(SIGCHLD)   | \
 	rt_sigmask(SIGWINCH)  |  rt_sigmask(SIGURG)    )
 
+#define SIG_SPECIFIC_SICODES_MASK (\
+	rt_sigmask(SIGILL)    |  rt_sigmask(SIGFPE)    | \
+	rt_sigmask(SIGSEGV)   |  rt_sigmask(SIGBUS)    | \
+	rt_sigmask(SIGTRAP)   |  rt_sigmask(SIGCHLD)   | \
+	rt_sigmask(SIGPOLL)   |  rt_sigmask(SIGSYS)    | \
+	SIGEMT_MASK                                    )
+
 #define sig_kernel_only(sig)		siginmask(sig, SIG_KERNEL_ONLY_MASK)
 #define sig_kernel_coredump(sig)	siginmask(sig, SIG_KERNEL_COREDUMP_MASK)
 #define sig_kernel_ignore(sig)		siginmask(sig, SIG_KERNEL_IGNORE_MASK)
 #define sig_kernel_stop(sig)		siginmask(sig, SIG_KERNEL_STOP_MASK)
+#define sig_specific_sicodes(sig)	siginmask(sig, SIG_SPECIFIC_SICODES_MASK)
 
 #define sig_fatal(t, signr) \
 	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 1abaf62c86fc..e1081a6d842b 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -248,7 +248,7 @@ typedef struct siginfo {
 #define NSIGCHLD	6
 
 /*
- * SIGPOLL si_codes
+ * SIGPOLL (or any other signal without signal specific si_codes) si_codes
  */
 #define POLL_IN		(__SI_POLL|1)	/* data input available */
 #define POLL_OUT	(__SI_POLL|2)	/* output buffers available */
-- 
2.10.1
