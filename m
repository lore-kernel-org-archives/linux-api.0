From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 06/24] fs: add is_userns_visible() helper
Date: Tue, 11 Feb 2020 17:57:35 +0100
Message-ID: <20200211165753.356508-7-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: owner-linux-security-module@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Introduce a helper which makes it possible to detect fileystems whose
superblock is visible in multiple user namespace. This currently only
means proc and sys. Such filesystems usually have special semantics so their
behavior will not be changed with the introduction of fsid mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 include/linux/fs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 98e0349adb52..1449cd363fb6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3627,4 +3627,9 @@ static inline int inode_drain_writes(struct inode *inode)
 	return filemap_write_and_wait(inode->i_mapping);
 }
 
+static inline bool is_userns_visible(unsigned long iflags)
+{
+	return (iflags & SB_I_USERNS_VISIBLE);
+}
+
 #endif /* _LINUX_FS_H */
-- 
2.25.0
