From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] security: Use user_namespace::level to avoid redundant
 iterations in cap_capable()
Date: Tue, 2 May 2017 15:40:33 +0300
Message-ID: <149372879732.11927.12565684278286604561.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

When ns->level is not larger then cred->user_ns->level,
then ns can't be cred->user_ns's descendant, and
there is no a sence to search in parents.

So, breake the cycle earlier and skip needless iterations.

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 security/commoncap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 78b37838a2d3..f6ef78208d2d 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -82,8 +82,11 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
 		if (ns == cred->user_ns)
 			return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
 
-		/* Have we tried all of the parent namespaces? */
-		if (ns == &init_user_ns)
+		/*
+		 * If ns can't be a descendant of cred->user_ns, then it's
+		 * needlessly to go up.
+		 */
+		if (ns->level <= cred->user_ns->level)
 			return -EPERM;
 
 		/* 
