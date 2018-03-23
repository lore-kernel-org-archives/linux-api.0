From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 05/11] shm: Move struct shmid_kernel into ipc/shm.c
Date: Fri, 23 Mar 2018 14:16:08 -0500
Message-ID: <20180323191614.32489-5-ebiederm@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vadmobdw.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

All of the users are now in ipc/shm.c so make the definition local to
that file to make code maintenance easier.  AKA to prevent rebuilding
the entire kernel when struct shmid_kernel changes.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/shm.h | 23 -----------------------
 ipc/shm.c           | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/include/linux/shm.h b/include/linux/shm.h
index 2bbafacfbfc9..c7cb18405ad7 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -3,32 +3,9 @@
 #define _LINUX_SHM_H_
 
 #include <linux/list.h>
-#include <asm/page.h>
 #include <uapi/linux/shm.h>
 #include <asm/shmparam.h>
 
-struct shmid_kernel /* private to the kernel */
-{	
-	struct kern_ipc_perm	shm_perm;
-	struct file		*shm_file;
-	unsigned long		shm_nattch;
-	unsigned long		shm_segsz;
-	time64_t		shm_atim;
-	time64_t		shm_dtim;
-	time64_t		shm_ctim;
-	pid_t			shm_cprid;
-	pid_t			shm_lprid;
-	struct user_struct	*mlock_user;
-
-	/* The task created the shm object.  NULL if the task is dead. */
-	struct task_struct	*shm_creator;
-	struct list_head	shm_clist;	/* list by creator */
-} __randomize_layout;
-
-/* shm_mode upper byte flags */
-#define	SHM_DEST	01000	/* segment will be destroyed on last detach */
-#define SHM_LOCKED      02000   /* segment will not be swapped */
-
 #ifdef CONFIG_SYSVIPC
 struct sysv_shm {
 	struct list_head shm_clist;
diff --git a/ipc/shm.c b/ipc/shm.c
index 387a786e7be1..0565669ebe5c 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -48,6 +48,28 @@
 
 #include "util.h"
 
+struct shmid_kernel /* private to the kernel */
+{
+	struct kern_ipc_perm	shm_perm;
+	struct file		*shm_file;
+	unsigned long		shm_nattch;
+	unsigned long		shm_segsz;
+	time64_t		shm_atim;
+	time64_t		shm_dtim;
+	time64_t		shm_ctim;
+	pid_t			shm_cprid;
+	pid_t			shm_lprid;
+	struct user_struct	*mlock_user;
+
+	/* The task created the shm object.  NULL if the task is dead. */
+	struct task_struct	*shm_creator;
+	struct list_head	shm_clist;	/* list by creator */
+} __randomize_layout;
+
+/* shm_mode upper byte flags */
+#define SHM_DEST	01000	/* segment will be destroyed on last detach */
+#define SHM_LOCKED	02000   /* segment will not be swapped */
+
 struct shm_file_data {
 	int id;
 	struct ipc_namespace *ns;
-- 
2.14.1
