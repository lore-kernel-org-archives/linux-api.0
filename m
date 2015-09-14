From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 08/13] Move MAX_SHARED_LIBS to fs/binfmt_flat.c
Date: Mon, 14 Sep 2015 15:50:42 -0700
Message-ID: <1442271047-4908-9-git-send-email-palmer__18858.3704912618$1442271237$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

I'm not sure what this is, but it doesn't feel like something that
should be exposed to userspace here.  I'm assuming this file was
exposed for the structure in it, which doesn't depend on
MAX_SHARED_LIBS.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 fs/binfmt_flat.c          | 6 ++++++
 include/uapi/linux/flat.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index f723cd3a455c..e89fb43c2a10 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -72,6 +72,12 @@
 #define RELOC_FAILED 0xff00ff01		/* Relocation incorrect somewhere */
 #define UNLOADED_LIB 0x7ff000ff		/* Placeholder for unused library */
 
+#ifdef CONFIG_BINFMT_SHARED_FLAT
+#define	MAX_SHARED_LIBS			(4)
+#else
+#define	MAX_SHARED_LIBS			(1)
+#endif
+
 struct lib_info {
 	struct {
 		unsigned long start_code;		/* Start of text segment */
diff --git a/include/uapi/linux/flat.h b/include/uapi/linux/flat.h
index 88cd6baba8f3..1b177c7637c4 100644
--- a/include/uapi/linux/flat.h
+++ b/include/uapi/linux/flat.h
@@ -13,12 +13,6 @@
 
 #define	FLAT_VERSION			0x00000004L
 
-#ifdef CONFIG_BINFMT_SHARED_FLAT
-#define	MAX_SHARED_LIBS			(4)
-#else
-#define	MAX_SHARED_LIBS			(1)
-#endif
-
 /*
  * To make everything easier to port and manage cross platform
  * development,  all fields are in network byte order.
-- 
2.4.6
