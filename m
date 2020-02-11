From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 19/24] sys:__sys_setgid(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:48 +0100
Message-ID: <20200211165753.356508-20-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch setgid() to lookup fsids in the fsid mappings. If no fsid mappings are
setup the behavior is unchanged, i.e. fsids are looked up in the id mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/sys.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index afaec8d46bc5..11f41e0a4974 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -416,24 +416,31 @@ long __sys_setgid(gid_t gid)
 	const struct cred *old;
 	struct cred *new;
 	int retval;
-	kgid_t kgid;
+	kgid_t kgid, kfsgid;
 
 	kgid = make_kgid(ns, gid);
 	if (!gid_valid(kgid))
 		return -EINVAL;
 
+	kfsgid = make_kfsgid(ns, gid);
+	if (!gid_valid(kfsgid))
+		return -EINVAL;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
 	old = current_cred();
 
 	retval = -EPERM;
-	if (ns_capable(old->user_ns, CAP_SETGID))
-		new->gid = new->egid = new->sgid = new->fsgid = kgid;
-	else if (gid_eq(kgid, old->gid) || gid_eq(kgid, old->sgid))
-		new->egid = new->fsgid = kgid;
-	else
+	if (ns_capable(old->user_ns, CAP_SETGID)) {
+		new->gid = new->egid = new->sgid = kgid;
+		new->fsgid = kfsgid;
+	} else if (gid_eq(kgid, old->gid) || gid_eq(kgid, old->sgid)) {
+		new->egid = kgid;
+		new->fsgid = kfsgid;
+	} else {
 		goto error;
+	}
 
 	return commit_creds(new);
 
-- 
2.25.0
