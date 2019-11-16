From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 2/3] clone.2: Check for MAP_FAILED not NULL on mmap()
Date: Sat, 16 Nov 2019 12:41:13 +0100
Message-ID: <20191116114114.7066-2-christian@brauner.io>
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

If mmap() fails it will return MAP_FAILED which according to the manpage
is (void *)-1 not NULL.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 man2/clone.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man2/clone.2 b/man2/clone.2
index 57a9eaba7..faff2ada6 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -1628,7 +1628,7 @@ main(int argc, char *argv[])
 
     stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE,
                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, \-1, 0);
-    if (stack == NULL)
+    if (stack == MAP_FAILED)
         errExit("mmap");
 
     stackTop = stack + STACK_SIZE;  /* Assume stack grows downward */
-- 
2.24.0
