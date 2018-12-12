From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC PATCH v1 2/5] fs: Add a MAY_EXECMOUNT flag to infer the noexec mount propertie
Date: Wed, 12 Dec 2018 09:17:09 +0100
Message-ID: <20181212081712.32347-3-mic@digikod.net>
References: <20181212081712.32347-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-14681-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20181212081712.32347-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

An LSM doesn't get path information related to an access request to open
an inode.  This new (internal) MAY_EXECMOUNT flag enables an LSM to
check if the underlying mount point of an inode is marked as executable.
This is useful to implement a security policy taking advantage of the
noexec mount option.

This flag is set according to path_noexec(), which checks if a mount
point is mounted with MNT_NOEXEC or if the underlying superblock is
SB_I_NOEXEC.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
---
 fs/namei.c         | 2 ++
 include/linux/fs.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 0cab6494978c..de4f33b3f464 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2970,6 +2970,8 @@ static int may_open(const struct path *path, int acc_mode, int flag)
 		break;
 	}
 
+	/* Pass the mount point executability. */
+	acc_mode |= path_noexec(path) ? 0 : MAY_EXECMOUNT;
 	error = inode_permission(inode, MAY_OPEN | acc_mode);
 	if (error)
 		return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 584c9329ad78..083a31b8068e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -96,6 +96,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_NOT_BLOCK		0x00000080
 /* the inode is opened with O_MAYEXEC */
 #define MAY_OPENEXEC		0x00000100
+/* the mount point is marked as executable */
+#define MAY_EXECMOUNT		0x00000200
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.20.0.rc2
