From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH] Add renameat2 function [BZ #17662]
Date: Mon, 2 Jul 2018 11:46:22 +0300
Message-ID: <20180702084622.GA15274@yury-thinkpad>
References: <20180630121447.E4C8643994575@oldenburg.str.redhat.com>
 <20180701214901.GA32498@yury-thinkpad>
 <60505ccf-a399-6320-74f5-e2e17965d25c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-93898-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <60505ccf-a399-6320-74f5-e2e17965d25c@redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: libc-alpha@sourceware.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+ Alexander Viro <viro@zeniv.linux.org.uk>, kernel maillists. 

On Mon, Jul 02, 2018 at 08:48:36AM +0200, Florian Weimer wrote:
> On 07/01/2018 11:49 PM, Yury Norov wrote:
> 
> > > +#ifdef __USE_GNU
> > > +/* Flags for renameat.  */
> > 
> > Flags for renameat2, right?
> 
> Thanks, fixed.
> 
> > > +# define RENAME_NOREPLACE (1 << 0)
> > > +# define RENAME_EXCHANGE (1 << 1)
> > > +# define RENAME_WHITEOUT (1 << 2)
> > 
> > I really don't understand how it works. Could you / somebody explain me?
> > 
> > include/uapi/linux/fs.h in kernel sources already defines this flags,
> > and this file is usually available in Linux distribution. So I don't
> > understand what for it is duplicated here. If you keep in mind
> > old linux headers or non-linux systems, I think it should be protected
> > with #ifndef guards.
> 
> <linux/fs.h> undefines and defines macros not mentioned in the standards
> (and it even contains a few unrelated structs), so we cannot include it
> without _GNU_SOURCE.
> 
> It might be possible to include it only for _GNU_SOURCE, but there are a
> lot of things in <linux/fs.h>, so that does not seem to be particularly
> advisable.
> 
> We still support building glibc with 3.2 kernel headers, and if the
> definitions you quoted above are not available, building the test case
> would fail.

Is my understanding correct that glibc community finds <linux/fs.h>
inappropriate for their use, and prefer to re-introduce (duplicate)
its functionality locally? I think it's wrong. The right way to go
is to make kernel headers comfortable for users instead of ignoring
it.

Are you OK to switch to kernel RENAME_* definitions if they will be
located in separated small file? Like in the patch below.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 include/uapi/linux/fs.h     |  4 +---
 include/uapi/linux/rename.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/rename.h

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index c27576d471c2..46c03ea31a76 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -44,9 +44,7 @@
 #define SEEK_HOLE	4	/* seek to the next hole */
 #define SEEK_MAX	SEEK_HOLE
 
-#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
-#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
-#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#include <linux/rename.h>
 
 struct file_clone_range {
 	__s64 src_fd;
diff --git a/include/uapi/linux/rename.h b/include/uapi/linux/rename.h
new file mode 100644
index 000000000000..7178f0565657
--- /dev/null
+++ b/include/uapi/linux/rename.h
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
-- 
2.17.1
