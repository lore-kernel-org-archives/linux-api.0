From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] prctl.2: describe PR_SET_OPENAT_BENEATH/PR_GET_OPENAT_BENEATH
Date: Fri, 25 Jul 2014 14:47:13 +0100
Message-ID: <1406296033-32693-18-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

---
 man2/prctl.2 | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/man2/prctl.2 b/man2/prctl.2
index 119989183ed3..f5f71af249f2 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -295,6 +295,41 @@ A value of 1 indicates
 .BR execve (2)
 will operate in the privilege-restricting mode described above.
 .TP
+.BR PR_SET_OPENAT_BENEATH " (since Linux 3.??)"
+Set the calling process's
+.I openat_beneath
+bit to the value in
+.IR arg2 .
+With
+.I openat_beneath
+set to 1, all
+.BR openat (2)
+and
+.BR open (2)
+operations act as though the
+.B O_BENEATH
+flag is set.
+Once set, this bit cannot be unset.
+The setting of this bit is inherited by children created by
+.BR fork (2)
+and
+.BR clone (2),
+and preserved across
+.BR execve (2).
+.TP
+.BR PR_GET_OPENAT_BENEATH " (since Linux 3.??)"
+Return (as the function result) the value of the
+.I openat_beneath
+bit for the current process.
+A value of 0 indicates the regular behavior.
+A value of 1 indicates that
+.BR openat (2)
+and
+.BR open (2)
+will operate in the implicit
+.B O_BENEATH
+mode described above.
+.TP
 .BR PR_SET_PDEATHSIG " (since Linux 2.1.57)"
 Set the parent process death signal
 of the calling process to \fIarg2\fP (either a signal value
-- 
2.0.0.526.g5318336
