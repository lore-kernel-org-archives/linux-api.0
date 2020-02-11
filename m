From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 18/24] sys:__sys_setuid(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:47 +0100
Message-ID: <20200211165753.356508-19-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch setuid() to lookup fsids in the fsid mappings. If no fsid mappings are
setup the behavior is unchanged, i.e. fsids are looked up in the id mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/sys.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index b89334ad0908..afaec8d46bc5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -574,11 +574,16 @@ long __sys_setuid(uid_t uid)
 	struct cred *new;
 	int retval;
 	kuid_t kuid;
+	kuid_t kfsuid;
 
 	kuid = make_kuid(ns, uid);
 	if (!uid_valid(kuid))
 		return -EINVAL;
 
+	kfsuid = make_kfsuid(ns, uid);
+	if (!uid_valid(kfsuid))
+		return -EINVAL;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
@@ -596,7 +601,8 @@ long __sys_setuid(uid_t uid)
 		goto error;
 	}
 
-	new->fsuid = new->euid = kuid;
+	new->euid = kuid;
+	new->fsuid = kfsuid;
 
 	retval = security_task_fix_setuid(new, old, LSM_SETID_ID);
 	if (retval < 0)
-- 
2.25.0
