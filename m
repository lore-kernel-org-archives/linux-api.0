From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH v2] UAPI: move RENAME_* definitions to separated file
Date: Wed, 14 Nov 2018 07:13:55 +0000
Message-ID: <20181114071346.31210-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>
Cc: "Norov, Yuri" <Yuri.Norov@cavium.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

Discussion:
https://lore.kernel.org/lkml/20180702084622.GA15274@yury-thinkpad/

Although RENAME_* macros are exposed in kernel headers, they are not
used by glibc. That's because linux/fs.h which hosts RENAME_* is
considered unsuitable by glibc developers:

As Florian Weimer wrote:

> <linux/fs.h> undefines and defines macros not mentioned in the standards
> (and it even contains a few unrelated structs), so we cannot include it
> without _GNU_SOURCE.
>
> It might be possible to include it only for _GNU_SOURCE, but there are a
> lot of things in <linux/fs.h>, so that does not seem to be particularly
> advisable.

In this patch RENAME_* is removed to a separated header file that
conforms the standards and therefore is suitable for inclusion by glibc.

v2:
 - rename dedicated file to 'rename-flags.h', as requested by Florian.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 include/uapi/linux/fs.h           |  4 +---
 include/uapi/linux/rename-flags.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/rename-flags.h

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 73e01918f996..34c308203746 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -39,9 +39,7 @@
 #define SEEK_HOLE	4	/* seek to the next hole */
 #define SEEK_MAX	SEEK_HOLE
=20
-#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
-#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
-#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#include <linux/rename-flags.h>
=20
 struct file_clone_range {
 	__s64 src_fd;
diff --git a/include/uapi/linux/rename-flags.h b/include/uapi/linux/rename-=
flags.h
new file mode 100644
index 000000000000..7178f0565657
--- /dev/null
+++ b/include/uapi/linux/rename-flags.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_RENAME_H
+#define _UAPI_LINUX_RENAME_H
+
+/*
+ * Definitions for rename syscall family.
+ */
+#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
+#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+
+#endif /* _UAPI_LINUX_RENAME_H */
--=20
2.17.1
