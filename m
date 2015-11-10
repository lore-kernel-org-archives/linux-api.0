From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 04/14] Always expose MAP_UNINITIALIZED to userspace
Date: Mon,  9 Nov 2015 17:31:01 -0800
Message-ID: <1447119071-19392-5-git-send-email-palmer__10549.4714844555$1447119472$gmane$org@dabbelt.com>
References: <1446579994-9937-1-git-send-email-palmer@dabbelt.com>
 <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Sender: linux-arch-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com, peterz@infradead.org
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

This used to be hidden behind CONFIG_MMAP_ALLOW_UNINITIALIZED, so
userspace wouldn't actually ever see it be non-zero.  While I had
originally hoped to avoid hiding it, it looks like this conflicts with
MAP_HUGE_SHIFT so I think it's safer to just keep this 0.

Architectures that want to define this can still override it.  In
fact, the Xtensa port already overrides it in a very similar manner to
the previously broken one (but due to lots of conflicting opinions on
how to solve this correctly, I'm just taking the easy way out and
letting their arch maintainers deal with it -- sorry).

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 include/uapi/asm-generic/mman-common.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index a74dd84..25ca92c 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -19,9 +19,7 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
-#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
-# define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be uninitialized */
-#else
+#ifndef MAP_UNINITIALIZED
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
 
-- 
2.4.10
