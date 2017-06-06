From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 01/26] alpha: Remove unused TASK_GROUP_LEADER
Date: Tue,  6 Jun 2017 14:03:13 -0500
Message-ID: <20170606190338.28347-1-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877f0pym71.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

This definition is for assembly code and no assembly code uses it.
Remove the definition so that when making future changes we don't
have to worry if alpha assembly code uses task->group_leader.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/alpha/kernel/asm-offsets.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/alpha/kernel/asm-offsets.c b/arch/alpha/kernel/asm-offsets.c
index 6ff8886e7e22..5297a95f491d 100644
--- a/arch/alpha/kernel/asm-offsets.c
+++ b/arch/alpha/kernel/asm-offsets.c
@@ -21,7 +21,6 @@ void foo(void)
         DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
         DEFINE(TASK_CRED, offsetof(struct task_struct, cred));
         DEFINE(TASK_REAL_PARENT, offsetof(struct task_struct, real_parent));
-        DEFINE(TASK_GROUP_LEADER, offsetof(struct task_struct, group_leader));
         DEFINE(TASK_TGID, offsetof(struct task_struct, tgid));
         BLANK();
 
-- 
2.10.1
