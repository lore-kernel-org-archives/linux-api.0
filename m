From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: [PATCH v4 2/9] kbuild: Don't pass LDFLAGS to selftest Makefile
Date: Wed, 11 Mar 2015 15:05:58 +1100
Message-ID: <1426046765-19289-2-git-send-email-mpe@ellerman.id.au>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426046765-19289-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The makefile in arch/x86/Makefile.um sets LDFLAGS and exports it, which
is then propagated to the selftest Makefiles and leads to build errors
there. The build errors occur because we are passing LDFLAGS to CC, but
the option set in Makefile.um (-m elf_x86_64) is not understood by CC.
We could fix that by using -Wl, but that might break the UM build if
it's actually passing that option to LD directly.

We don't actually want the LDFLAGS from kbuild in the selftest Makefile,
so the simplest fix seems to be to clear LDFLAGS before invoking the
selftest Makefile.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0836e9d628f0..5cef1d4c2ea0 100644
--- a/Makefile
+++ b/Makefile
@@ -1085,7 +1085,7 @@ headers_check: headers_install
 
 PHONY += kselftest
 kselftest:
-	$(Q)$(MAKE) -C tools/testing/selftests MAKEFLAGS="$(filter-out rR,$(MAKEFLAGS))" run_tests
+	$(Q)$(MAKE) LDFLAGS= -C tools/testing/selftests MAKEFLAGS="$(filter-out rR,$(MAKEFLAGS))" run_tests
 
 # ---------------------------------------------------------------------------
 # Modules
-- 
2.1.0
