From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 17/24] sys: __sys_setfsgid(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:46 +0100
Message-ID: <20200211165753.356508-18-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch setfsgid() to lookup fsids in the fsid mappings. If no fsid mappings are
setup the behavior is unchanged, i.e. fsids are looked up in the id mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/sys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index ae376d32c1e3..b89334ad0908 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -847,9 +847,9 @@ long __sys_setfsgid(gid_t gid)
 	kgid_t kgid;
 
 	old = current_cred();
-	old_fsgid = from_kgid_munged(old->user_ns, old->fsgid);
+	old_fsgid = from_kfsgid_munged(old->user_ns, old->fsgid);
 
-	kgid = make_kgid(old->user_ns, gid);
+	kgid = make_kfsgid(old->user_ns, gid);
 	if (!gid_valid(kgid))
 		return old_fsgid;
 
-- 
2.25.0
