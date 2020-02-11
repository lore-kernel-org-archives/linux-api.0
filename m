From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/24] commoncap:cap_bprm_set_creds(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:44 +0100
Message-ID: <20200211165753.356508-16-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

During exec the kfsids are currently reset to the effective kids. To retain the
same semantics with the introduction of fsid mappings, we lookup the userspace
effective id in the id mappings and translate the effective id into the
corresponding kfsid in the fsidmapping. This means, the behavior is unchanged
when no fsid mappings are setup and the semantics stay the same even when fsid
mappings are setup.

Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 security/commoncap.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index ecfa0d0c250e..8d1a81e98610 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -811,7 +811,10 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 	struct cred *new = bprm->cred;
 	bool effective = false, has_fcap = false, is_setid;
 	int ret;
-	kuid_t root_uid;
+	kuid_t root_uid, kfsuid;
+	kgid_t kfsgid;
+	uid_t fsuid;
+	gid_t fsgid;
 
 	if (WARN_ON(!cap_ambient_invariant_ok(old)))
 		return -EPERM;
@@ -848,8 +851,15 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 						   old->cap_permitted);
 	}
 
-	new->suid = new->fsuid = new->euid;
-	new->sgid = new->fsgid = new->egid;
+	fsuid = from_kuid_munged(new->user_ns, new->euid);
+	kfsuid = make_kfsuid(new->user_ns, fsuid);
+	new->suid = new->euid;
+	new->fsuid = kfsuid;
+
+	fsgid = from_kgid_munged(new->user_ns, new->egid);
+	kfsgid = make_kfsgid(new->user_ns, fsgid);
+	new->sgid = new->egid;
+	new->fsgid = kfsgid;
 
 	/* File caps or setid cancels ambient. */
 	if (has_fcap || is_setid)
-- 
2.25.0
