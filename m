From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 1/3] clone.2: Fix typos
Date: Sat, 16 Nov 2019 12:41:12 +0100
Message-ID: <20191116114114.7066-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: adrian@lisas.de, akpm@linux-foundation.org, arnd@arndb.de, avagin@gmail.com, christian.brauner@ubuntu.com, dhowells@redhat.com, fweimer@redhat.com, jannh@google.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu, oleg@redhat.com, xemul@virtuozzo.com
List-Id: linux-api@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Fix two spelling mistakes in manpage describing the clone{2,3}()
syscalls/syscall wrappers.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 man2/clone.2 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man2/clone.2 b/man2/clone.2
index f67a60067..57a9eaba7 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -70,12 +70,12 @@ create a new ("child") process, in a manner similar to
 .PP
 By contrast with
 .BR fork (2),
-these system cals provide more precise control over what pieces of execution
+these system calls provide more precise control over what pieces of execution
 context are shared between the calling process and the child process.
 For example, using these system calls, the caller can control whether
 or not the two processes share the virtual address space,
 the table of file descriptors, and the table of signal handlers.
-These system calls also allow the new child process to placed
+These system calls also allow the new child process to be placed
 in separate
 .BR namespaces (7).
 .PP

base-commit: 91243dad42a7a62df73e3b1dfbb810adc1b8b654
-- 
2.24.0
