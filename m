From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 16/24] sys: __sys_setfsuid(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:45 +0100
Message-ID: <20200211165753.356508-17-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: owner-linux-security-module@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch setfsuid() to lookup fsids in the fsid mappings. If no fsid mappings are
setup the behavior is unchanged, i.e. fsids are looked up in the id mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/sys.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index a9331f101883..ae376d32c1e3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -59,6 +59,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
+#include <linux/fsuidgid.h>
 #include <linux/cred.h>
 
 #include <linux/nospec.h>
@@ -802,9 +803,9 @@ long __sys_setfsuid(uid_t uid)
 	kuid_t kuid;
 
 	old = current_cred();
-	old_fsuid = from_kuid_munged(old->user_ns, old->fsuid);
+	old_fsuid = from_kfsuid_munged(old->user_ns, old->fsuid);
 
-	kuid = make_kuid(old->user_ns, uid);
+	kuid = make_kfsuid(old->user_ns, uid);
 	if (!uid_valid(kuid))
 		return old_fsuid;
 
-- 
2.25.0
