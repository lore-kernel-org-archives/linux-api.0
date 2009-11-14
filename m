From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: [PATCH v2] fcntl: Use consistent values for F_[GS]ETOWN_EX
Date: Sat, 14 Nov 2009 20:45:06 +1100
Message-ID: <20091114204506.12d3a3c8.sfr@canb.auug.org.au>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
	<20091030161320.17d07dc9.sfr@canb.auug.org.au>
	<20091030162906.fbc1c40b.sfr@canb.auug.org.au>
	<20091113103257.1f4f6e12.sfr@canb.auug.org.au>
	<20091114180131.da95d2a1.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091114180131.da95d2a1.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <onestero-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephane Eranian <eranian-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

These values were only introduced during this release cycle, so it is
still early enough to get them right.

alpha uses the same values that are in asm-generic/fcntl.h, so just
remove them.

parisc uses the values interchanged for no apparent reason, so remove them
to give us consistency across all architectures.

Signed-off-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
---
 arch/alpha/include/asm/fcntl.h  |    2 --
 arch/parisc/include/asm/fcntl.h |    2 --
 include/asm-generic/fcntl.h     |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

Ulrich pointed out that using F_LINUX_SPECIFIC_BASE for these make code
less efficient when these values are used in switch statements.

diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
index 73126e4..25da001 100644
--- a/arch/alpha/include/asm/fcntl.h
+++ b/arch/alpha/include/asm/fcntl.h
@@ -26,8 +26,6 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
-#define F_SETOWN_EX	15
-#define F_GETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1
diff --git a/arch/parisc/include/asm/fcntl.h b/arch/parisc/include/asm/fcntl.h
index 5f39d55..1e1c824 100644
--- a/arch/parisc/include/asm/fcntl.h
+++ b/arch/parisc/include/asm/fcntl.h
@@ -28,8 +28,6 @@
 #define F_SETOWN	12	/*  for sockets. */
 #define F_SETSIG	13	/*  for sockets. */
 #define F_GETSIG	14	/*  for sockets. */
-#define F_GETOWN_EX	15
-#define F_SETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		01
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index cd2d789..c6f3926 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -82,10 +82,8 @@
 #endif
 #endif
 
-#ifndef F_SETOWN_EX
 #define F_SETOWN_EX	15
 #define F_GETOWN_EX	16
-#endif
 
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/
