From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [REVIEW][PATCH 04/11] sem: Move struct sem and struct sem_array into
	ipc/sem.c
Date: Fri, 23 Mar 2018 14:16:07 -0500
Message-ID: <20180323191614.32489-4-ebiederm@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87vadmobdw.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

All of the users are now in ipc/sem.c so make the definitions
local to that file to make code maintenance easier.  AKA
to prevent rebuilding the entire kernel when one of these
files is changed.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 include/linux/sem.h | 40 +---------------------------------------
 ipc/sem.c           | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 9badd322dcee..5608a500c43e 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -2,48 +2,10 @@
 #ifndef _LINUX_SEM_H
 #define _LINUX_SEM_H
 
-#include <linux/atomic.h>
-#include <linux/rcupdate.h>
-#include <linux/cache.h>
-#include <linux/time64.h>
 #include <uapi/linux/sem.h>
 
 struct task_struct;
-
-/* One semaphore structure for each semaphore in the system. */
-struct sem {
-	int	semval;		/* current value */
-	/*
-	 * PID of the process that last modified the semaphore. For
-	 * Linux, specifically these are:
-	 *  - semop
-	 *  - semctl, via SETVAL and SETALL.
-	 *  - at task exit when performing undo adjustments (see exit_sem).
-	 */
-	int	sempid;
-	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
-	struct list_head pending_alter; /* pending single-sop operations */
-					/* that alter the semaphore */
-	struct list_head pending_const; /* pending single-sop operations */
-					/* that do not alter the semaphore*/
-	time_t	sem_otime;	/* candidate for sem_otime */
-} ____cacheline_aligned_in_smp;
-
-/* One sem_array data structure for each set of semaphores in the system. */
-struct sem_array {
-	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
-	time64_t		sem_ctime;	/* create/last semctl() time */
-	struct list_head	pending_alter;	/* pending operations */
-						/* that alter the array */
-	struct list_head	pending_const;	/* pending complex operations */
-						/* that do not alter semvals */
-	struct list_head	list_id;	/* undo requests on this array */
-	int			sem_nsems;	/* no. of semaphores in array */
-	int			complex_count;	/* pending complex operations */
-	unsigned int		use_global_lock;/* >0: global lock required */
-
-	struct sem		sems[];
-} __randomize_layout;
+struct sem_undo_list;
 
 #ifdef CONFIG_SYSVIPC
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 01f5c63670ae..d661c491b0a5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -88,6 +88,40 @@
 #include <linux/uaccess.h>
 #include "util.h"
 
+/* One semaphore structure for each semaphore in the system. */
+struct sem {
+	int	semval;		/* current value */
+	/*
+	 * PID of the process that last modified the semaphore. For
+	 * Linux, specifically these are:
+	 *  - semop
+	 *  - semctl, via SETVAL and SETALL.
+	 *  - at task exit when performing undo adjustments (see exit_sem).
+	 */
+	int	sempid;
+	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
+	struct list_head pending_alter; /* pending single-sop operations */
+					/* that alter the semaphore */
+	struct list_head pending_const; /* pending single-sop operations */
+					/* that do not alter the semaphore*/
+	time_t	sem_otime;	/* candidate for sem_otime */
+} ____cacheline_aligned_in_smp;
+
+/* One sem_array data structure for each set of semaphores in the system. */
+struct sem_array {
+	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
+	time64_t		sem_ctime;	/* create/last semctl() time */
+	struct list_head	pending_alter;	/* pending operations */
+						/* that alter the array */
+	struct list_head	pending_const;	/* pending complex operations */
+						/* that do not alter semvals */
+	struct list_head	list_id;	/* undo requests on this array */
+	int			sem_nsems;	/* no. of semaphores in array */
+	int			complex_count;	/* pending complex operations */
+	unsigned int		use_global_lock;/* >0: global lock required */
+
+	struct sem		sems[];
+} __randomize_layout;
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
-- 
2.14.1
