From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
Date: Sun, 04 Oct 2009 23:30:22 +0200
Message-ID: <1254691822.21044.9.camel@laptop>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758080AbZJDVbK@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Oleg Nesterov <onestero@redhat.com>, Stephane Eranian <eranian@googlemail.com>, Michael Kerrisk <mtk.manpages@googlemail.com>, Roland McGrath <roland@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
List-Id: linux-api@vger.kernel.org

On Sun, 2009-10-04 at 12:35 +0000, Joseph S. Myers wrote:
> In asm-generic/fcntl.h, F_SETOWN_EX and F_GETLK64 both have value 12, and 
> F_GETOWN_EX and F_SETLK64 both have value 13.  I don't see how this is 
> going to work correctly.  See 
> <http://sourceware.org/ml/libc-ports/2009-10/msg00013.html>.


Ugh,.. yeah, non obvious collision that.

How about something like:

---
 arch/alpha/include/asm/fcntl.h |    4 ++--
 include/asm-generic/fcntl.h    |   19 +++++++++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
index e42823e..73126e4 100644
--- a/arch/alpha/include/asm/fcntl.h
+++ b/arch/alpha/include/asm/fcntl.h
@@ -26,8 +26,8 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
-#define F_SETOWN_EX	12
-#define F_GETOWN_EX	13
+#define F_SETOWN_EX	15
+#define F_GETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 0c3dd86..cd2d789 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -73,9 +73,18 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+
+#ifndef CONFIG_64BIT
+#ifndef F_GETLK64
+#define F_GETLK64	12	/*  using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+#endif
+#endif
+
 #ifndef F_SETOWN_EX
-#define F_SETOWN_EX	12
-#define F_GETOWN_EX	13
+#define F_SETOWN_EX	15
+#define F_GETOWN_EX	16
 #endif
 
 #define F_OWNER_TID	0
@@ -139,12 +148,6 @@ struct flock {
 
 #ifndef CONFIG_64BIT
 
-#ifndef F_GETLK64
-#define F_GETLK64	12	/*  using 'struct flock64' */
-#define F_SETLK64	13
-#define F_SETLKW64	14
-#endif
-
 #ifndef HAVE_ARCH_STRUCT_FLOCK64
 #ifndef __ARCH_FLOCK64_PAD
 #define __ARCH_FLOCK64_PAD
