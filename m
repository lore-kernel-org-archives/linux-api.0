From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH 1/2] selftests/mlock2: Add missing #define _GNU_SOURCE
Date: Mon,  9 Nov 2015 11:14:28 +0100
Message-ID: <1447064069-21469-2-git-send-email-geert@linux-m68k.org>
References: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447064069-21469-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On glibc 2.3.6:

    mlock2-tests.c: In function 'seek_to_smaps_entry':
    mlock2-tests.c:158: warning: implicit declaration of function 'getline'

According to the manpage of getline(), it needs _GNU_SOURCE before glibc
2.10.

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
 tools/testing/selftests/vm/mlock2-tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vm/mlock2-tests.c b/tools/testing/selftests/vm/mlock2-tests.c
index 4431994aade2ef6f..cb247219f1f72889 100644
--- a/tools/testing/selftests/vm/mlock2-tests.c
+++ b/tools/testing/selftests/vm/mlock2-tests.c
@@ -1,3 +1,4 @@
+#define _GNU_SOURCE
 #include <sys/mman.h>
 #include <stdint.h>
 #include <stdio.h>
-- 
1.9.1
