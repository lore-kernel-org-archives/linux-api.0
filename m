From: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests: add .gitignore for efivarfs
Date: Tue, 29 Sep 2015 10:03:59 +0800
Message-ID: <1443492239-5231-1-git-send-email-sunyuan3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/efivarfs/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore

diff --git a/tools/testing/selftests/efivarfs/.gitignore b/tools/testing/selftests/efivarfs/.gitignore
new file mode 100644
index 0000000..3361849
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/.gitignore
@@ -0,0 +1,2 @@
+create-read
+open-unlink
-- 
1.9.1
