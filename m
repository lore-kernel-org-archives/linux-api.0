From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 02/26] cgroup: Don't open code tasklist_empty()
Date: Tue,  6 Jun 2017 14:03:14 -0500
Message-ID: <20170606190338.28347-2-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c3c9a0e1b3c9..4b7d66cf8914 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4440,7 +4440,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
 	 * need to invoke fork callbacks here. */
-	BUG_ON(!list_empty(&init_task.tasks));
+	BUG_ON(!tasklist_empty());
 
 	BUG_ON(online_css(css));
 
-- 
2.10.1
