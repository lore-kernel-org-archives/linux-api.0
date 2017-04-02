From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH v2 3/5] clone: Disallown CLONE_THREAD with a shared sighand_struct
Date: Sun, 02 Apr 2017 17:52:58 -0500
Message-ID: <87k2728lrp.fsf_-_@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com>
        <874ly6a0h1.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <874ly6a0h1.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Sun, 02 Apr 2017 17:50:02 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Old threading libraries used CLONE_SIGHAND without clone thread.
Modern threadding libraries always use CLONE_SIGHAND | CLONE_THREAD.

Therefore let's simplify our lives and stop supporting a case no one cares about.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/fork.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index fe6f1bf32bb9..0632ac1180be 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1515,6 +1515,13 @@ static __latent_entropy struct task_struct *copy_process(
 	if ((clone_flags & CLONE_THREAD) && !(clone_flags & CLONE_SIGHAND))
 		return ERR_PTR(-EINVAL);
 
+	/* Disallow CLONE_THREAD with a shared SIGHAND structure.  No
+	 * one cares and supporting it leads to unnecessarily complex
+	 * code.
+	 */
+	if ((clone_flags & CLONE_THREAD) && (atomic_read(&current->sighand->count) > 1))
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * Shared signal handlers imply shared VM. By way of the above,
 	 * thread groups also imply shared VM. Blocking this case allows
-- 
2.10.1
