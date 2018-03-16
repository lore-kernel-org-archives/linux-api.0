From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH ghak32 V2 10/13] audit: add containerid support for
	seccomp and anom_abend records
Date: Fri, 16 Mar 2018 05:00:37 -0400
Message-ID: <11174597083f89352f1d6491ec94e27f882625d9.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1521179281.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1521179281.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1521179281.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, madzcar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add container ID auxiliary records to secure computing and abnormal end
standalone records.

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/auditsc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7103d23..2f02ed9 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2571,6 +2571,7 @@ static void audit_log_task(struct audit_buffer *ab)
 void audit_core_dumps(long signr)
 {
 	struct audit_buffer *ab;
+	struct audit_context *context = audit_alloc_local();
 
 	if (!audit_enabled)
 		return;
@@ -2578,19 +2579,22 @@ void audit_core_dumps(long signr)
 	if (signr == SIGQUIT)	/* don't care for those */
 		return;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	if (unlikely(!ab))
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld res=1", signr);
 	audit_log_end(ab);
+	audit_log_container_info(context, "abend", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 void __audit_seccomp(unsigned long syscall, long signr, int code)
 {
 	struct audit_buffer *ab;
+	struct audit_context *context = audit_alloc_local();
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SECCOMP);
 	if (unlikely(!ab))
 		return;
 	audit_log_task(ab);
@@ -2598,6 +2602,8 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 			 signr, syscall_get_arch(), syscall,
 			 in_compat_syscall(), KSTK_EIP(current), code);
 	audit_log_end(ab);
+	audit_log_container_info(context, "seccomp", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 struct list_head *audit_killed_trees(void)
-- 
1.8.3.1
