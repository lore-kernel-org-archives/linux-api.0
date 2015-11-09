From: Wei Jiangang <weijg.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] tools:testing/selftests: fix typo in futex/README
Date: Mon, 9 Nov 2015 14:26:39 +0800
Message-ID: <1447050399-24404-1-git-send-email-weijg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, weijg.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Correct typo in tools/testing/selftests/futex/README.

Signed-off-by: Wei Jiangang <weijg.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 tools/testing/selftests/futex/README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/README b/tools/testing/selftests/futex/README
index 3224a049b196..0558bb9ce0a6 100644
--- a/tools/testing/selftests/futex/README
+++ b/tools/testing/selftests/futex/README
@@ -27,7 +27,7 @@ o The build system shall remain as simple as possible, avoiding any archive or
 o Where possible, any helper functions or other package-wide code shall be
   implemented in header files, avoiding the need to compile intermediate object
   files.
-o External dependendencies shall remain as minimal as possible. Currently gcc
+o External dependencies shall remain as minimal as possible. Currently gcc
   and glibc are the only dependencies.
 o Tests return 0 for success and < 0 for failure.
 
-- 
1.9.3
