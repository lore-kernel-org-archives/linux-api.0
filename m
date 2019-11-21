From: Christian Brauner <christian@brauner.io>
Subject: [PATCH] clone.2: Fix typo
Date: Thu, 21 Nov 2019 12:06:46 +0100
Message-ID: <20191121110646.1398-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: adrian@lisas.de, akpm@linux-foundation.org, arnd@arndb.de, avagin@gmail.com, christian.brauner@ubuntu.com, dhowells@redhat.com, fweimer@redhat.com, jannh@google.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu, oleg@redhat.com, xemul@virtuozzo.com
List-Id: linux-api@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

This surely meant to say clone3() and not clone(3).

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 man2/clone.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man2/clone.2 b/man2/clone.2
index 382f6b791..e5ab2a096 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -252,7 +252,7 @@ argument supplied to
 lb lb lb
 l l l
 li li l.
-clone()	clone(3)	Notes
+clone()	clone3()	Notes
 	\fIcl_args\fP field
 flags & ~0xff	flags	For most flags; details below
 parent_tid	pidfd	See CLONE_PIDFD

base-commit: be479fdf027a3288e88d53dbe05ba76bf202776e
-- 
2.24.0
