From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 21/24] sys:__sys_setregid(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:50 +0100
Message-ID: <20200211165753.356508-22-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Switch setregid() to lookup fsids in the fsid mappings. If no fsid mappings are
setup the behavior is unchanged, i.e. fsids are looked up in the id mappings.

During setregid() the kfsgid is set to the kegid corresponding the egid that is
requested by userspace. If the requested egid is -1 the kfsgid is reset to the
current kegid. For the latter case this means we need to lookup the
corresponding userspace egid corresponding to the current kegid in the id
mappings and translate this egid into the corresponding kfsgid in the fsid
mappings.

Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 kernel/sys.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index ef1104c9df56..41551c01c3eb 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -354,15 +354,18 @@ long __sys_setregid(gid_t rgid, gid_t egid)
 	const struct cred *old;
 	struct cred *new;
 	int retval;
-	kgid_t krgid, kegid;
+	kgid_t krgid, kegid, kfsgid;
 
 	krgid = make_kgid(ns, rgid);
 	kegid = make_kgid(ns, egid);
+	kfsgid = make_kfsgid(ns, egid);
 
 	if ((rgid != (gid_t) -1) && !gid_valid(krgid))
 		return -EINVAL;
 	if ((egid != (gid_t) -1) && !gid_valid(kegid))
 		return -EINVAL;
+	if ((egid != (gid_t) -1) && !gid_valid(kfsgid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -386,12 +389,15 @@ long __sys_setregid(gid_t rgid, gid_t egid)
 			new->egid = kegid;
 		else
 			goto error;
+	} else {
+		gid_t fsgid = from_kgid_munged(new->user_ns, new->egid);
+		kfsgid = make_kfsgid(ns, fsgid);
 	}
 
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && !gid_eq(kegid, old->gid)))
 		new->sgid = new->egid;
-	new->fsgid = new->egid;
+	new->fsgid = kfsgid;
 
 	return commit_creds(new);
 
-- 
2.25.0
