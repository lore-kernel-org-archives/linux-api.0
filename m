From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 1/2] userfaultfd: remove kernel header include from uapi header
Date: Tue, 22 Sep 2015 11:45:55 +0100
Message-ID: <1442918756-17892-2-git-send-email-andre.przywara@arm.com>
References: <1442918756-17892-1-git-send-email-andre.przywara@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442918756-17892-1-git-send-email-andre.przywara-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

As include/uapi/linux/userfaultfd.h is a user visible header file,
it should not include kernel-exclusive header files.
So trying to build the userfaultfd test program from the selftests
directory fails, since it contains a reference to linux/compiler.h.
As it turns out, that header is not really needed there, so we can
simply remove it to fix that issue.

Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
---
 include/uapi/linux/userfaultfd.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index df0e09b..9057d7a 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -11,8 +11,6 @@
 
 #include <linux/types.h>
 
-#include <linux/compiler.h>
-
 #define UFFD_API ((__u64)0xAA)
 /*
  * After implementing the respective features it will become:
-- 
2.5.1
