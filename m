From: Christian Brauner <christian@brauner.io>
Subject: [PATCH] clone.2: Mention that CLONE_PARENT is off-limits for inits
Date: Wed, 20 Nov 2019 11:45:04 +0100
Message-ID: <20191120104504.22411-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: adrian@lisas.de, akpm@linux-foundation.org, arnd@arndb.de, avagin@gmail.com, christian.brauner@ubuntu.com, dhowells@redhat.com, fweimer@redhat.com, jannh@google.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu, oleg@redhat.com, xemul@virtuozzo.com
List-Id: linux-api@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

The CLONE_PARENT flag cannot but used by init processes. Let's mention
this in the manpages to prevent suprises.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 man2/clone.2 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man2/clone.2 b/man2/clone.2
index f0f29d6f1..aa98ab79b 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -646,6 +646,13 @@ if
 .B CLONE_PARENT
 is set, then the parent of the calling process, rather than the
 calling process itself, will be signaled.
+.IP
+The kernel will not allow global init and init processes in pid
+namespaces to use the
+.B CLONE_PARENT
+flag. This is done to prevent the creation of multi-rooted process
+trees. It also avoids unreapable zombies in the initial pid
+namespace.
 .TP
 .BR CLONE_PARENT_SETTID " (since Linux 2.5.49)"
 Store the child thread ID at the location pointed to by
-- 
2.24.0
