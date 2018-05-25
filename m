From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 4/6 v1 resend] statfs: add ST_SHARED
Date: Fri, 25 May 2018 14:48:23 +0200
Message-ID: <20180525124825.23875-5-christian@brauner.io>
References: <20180525124825.23875-1-christian@brauner.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180525124825.23875-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org, ebiederm@xmission.com, seth.forshee@canonical.com, viro@zeniv.linux.org.uk, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Currently userspace can only determine whether a mountpoint is shared
by parsing /proc/<pid>/mountinfo. It would be convenient to simply retrieve
this property with a statvfs() call.
This let's userspace avoid costly parsing, supports cases where /proc is
not mounted, and supports usecases where file descriptors to mountpoints
are passed between processes that are inspected via fstatvfs().
This is especially helpful in all cases where userspace is not interested
in specific propagation properties but rather just wants to either turn on
or turn off propagation for specific mountpoints.

Signed-off-by: Christian Brauner <christian@brauner.io>
---
v0->v1:
* non-functional changes: extend commit message
---
 fs/statfs.c            | 2 ++
 include/linux/statfs.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/statfs.c b/fs/statfs.c
index 61b3063d3921..2fc6f9c3793c 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -31,6 +31,8 @@ static int flags_by_mnt(int mnt_flags)
 		flags |= ST_RELATIME;
 	if (mnt_flags & MNT_UNBINDABLE)
 		flags |= ST_UNBINDABLE;
+	if (mnt_flags & MNT_SHARED)
+		flags |= ST_SHARED;
 	return flags;
 }
 
diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index e1b84d0388c1..5416b2936dd9 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -41,5 +41,6 @@ struct kstatfs {
 #define ST_NODIRATIME	(1<<11) /* do not update directory access times */
 #define ST_RELATIME	(1<<12) /* update atime relative to mtime/ctime */
 #define ST_UNBINDABLE	(1<<17)	/* change to unbindable */
+#define ST_SHARED	(1<<20)	/* change to shared */
 
 #endif
-- 
2.17.0
