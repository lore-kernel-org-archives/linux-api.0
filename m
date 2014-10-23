From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: [PATCH 2/3] selftests/kcmp: Don't include kernel headers
Date: Thu, 23 Oct 2014 16:07:13 +1100
Message-ID: <1414040834-30209-2-git-send-email-mpe@ellerman.id.au>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414040834-30209-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

The kcmp test mucks with the include path to bring in the kernel
headers, and x86 headers too for reasons that are not clear.

Now that kcmp.h is exported none of that should be necessary.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---
 tools/testing/selftests/kcmp/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 8aabd82db9e4..4f00c0524501 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -8,11 +8,7 @@ ifeq ($(ARCH),x86_64)
 	ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
-
-CFLAGS += -I../../../../arch/x86/include/generated/
-CFLAGS += -I../../../../include/
 CFLAGS += -I../../../../usr/include/
-CFLAGS += -I../../../../arch/x86/include/
 
 all:
 ifeq ($(ARCH),x86)
-- 
1.9.1
