From: a22017@motorola.com
Subject: [PATCH] ipc/sem: 64bit union semun definition
Date: Tue,  5 May 2015 11:28:43 -0700
Message-ID: <1430850523-7522-1-git-send-email-a22017@motorola.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ling-Juan Sun <a22017@motorola.com>
List-Id: linux-api@vger.kernel.org

From: Ling-Juan Sun <a22017@motorola.com>

The member of semun semid_ds has new definition
semid64_ds for 64bit architectures.

Signed-off-by: Ling-Juan Sun <a22017@motorola.com>
---
 include/uapi/linux/sem.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
index dd73b90..e9ab2a5 100644
--- a/include/uapi/linux/sem.h
+++ b/include/uapi/linux/sem.h
@@ -50,6 +50,15 @@ union semun {
 	void __user *__pad;
 };
 
+/* arg for semctl 64 bit system calls. */
+union semun64 {
+	int val;			/* value for SETVAL */
+	struct semid64_ds __user *buf;	/* buffer for IPC_STAT & IPC_SET */
+	unsigned short __user *array;	/* array for GETALL & SETALL */
+	struct seminfo __user *__buf;	/* buffer for IPC_INFO */
+	void __user *__pad;
+};
+
 struct  seminfo {
 	int semmap;
 	int semmni;
-- 
2.1.1
