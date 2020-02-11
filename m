From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 23/24] sys:__sys_setresgid(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:52 +0100
Message-ID: <20200211165753.356508-24-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: owner-linux-security-module@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch setresgid() to lookup fsids in the fsid mappings. If no fsid mappings are
setup the behavior is unchanged, i.e. fsids are looked up in the id mappings.

During setresgid() the kfsgid is set to the kegid corresponding the egid that is
requested by userspace. If the requested egid is -1 the kfsgid is reset to the
current kegid. For the latter case this means we need to lookup the
corresponding userspace egid corresponding to the current kegid in the id
mappings and translate this egid into the corresponding kfsgid in the fsid
mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/sys.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 3b98ce84607d..674d0ba4887c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -750,11 +750,12 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	const struct cred *old;
 	struct cred *new;
 	int retval;
-	kgid_t krgid, kegid, ksgid;
+	kgid_t krgid, kegid, ksgid, kfsgid;
 
 	krgid = make_kgid(ns, rgid);
 	kegid = make_kgid(ns, egid);
 	ksgid = make_kgid(ns, sgid);
+	kfsgid = make_kfsgid(ns, egid);
 
 	if ((rgid != (gid_t) -1) && !gid_valid(krgid))
 		return -EINVAL;
@@ -762,6 +763,8 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		return -EINVAL;
 	if ((sgid != (gid_t) -1) && !gid_valid(ksgid))
 		return -EINVAL;
+	if ((egid != (gid_t) -1) && !gid_valid(kfsgid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -783,11 +786,15 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 
 	if (rgid != (gid_t) -1)
 		new->gid = krgid;
-	if (egid != (gid_t) -1)
+	if (egid != (gid_t) -1) {
 		new->egid = kegid;
+	} else {
+		gid_t fsgid = from_kgid_munged(new->user_ns, new->egid);
+		kfsgid = make_kfsgid(ns, fsgid);
+	}
 	if (sgid != (gid_t) -1)
 		new->sgid = ksgid;
-	new->fsgid = new->egid;
+	new->fsgid = kfsgid;
 
 	return commit_creds(new);
 
-- 
2.25.0
