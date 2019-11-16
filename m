From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 3/3] clone.2: Use pid_t for clone3() {child,parent}_tid
Date: Sat, 16 Nov 2019 12:41:14 +0100
Message-ID: <20191116114114.7066-3-christian@brauner.io>
References: <20191116114114.7066-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191116114114.7066-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: adrian@lisas.de, akpm@linux-foundation.org, arnd@arndb.de, avagin@gmail.com, christian.brauner@ubuntu.com, dhowells@redhat.com, fweimer@redhat.com, jannh@google.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu, oleg@redhat.com, xemul@virtuozzo.com
List-Id: linux-api@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Advertise to userspace that they should use proper pid_t types for
arguments returning a pid.
The kernel-internal struct kernel_clone_args currently uses int as type
and since POSIX mandates that pid_t is a signed integer type and glibc
and friends use int this is not an issue. After the merge window for
v5.5 closes we can switch struct kernel_clone_args over to using pid_t
as well without any danger in regressing current userspace.
Also note, that the new set tid feature which will be merged for v5.5
uses pid_t types as well.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 man2/clone.2 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man2/clone.2 b/man2/clone.2
index faff2ada6..bf2d7c731 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -183,9 +183,9 @@ is a structure of the following form:
 struct clone_args {
     u64 flags;        /* Flags bit mask */
     u64 pidfd;        /* Where to store PID file descriptor
-                         (\fIint *\fP) */
+                         (\fIpid_t *\fP) */
     u64 child_tid;    /* Where to store child TID,
-                         in child's memory (\fIint *\fP) */
+                         in child's memory (\fIpid_t *\fP) */
     u64 parent_tid;   /* Where to store child TID,
                          in parent's memory (\fIint *\fP) */
     u64 exit_signal;  /* Signal to deliver to parent on
-- 
2.24.0
