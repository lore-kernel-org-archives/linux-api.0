From: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] add ptrace/.gitignore
Date: Thu, 7 Jan 2016 14:54:01 +0800
Message-ID: <1452149642-7597-3-git-send-email-sunyuan3@huawei.com>
References: <1452149642-7597-1-git-send-email-sunyuan3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452149642-7597-1-git-send-email-sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/ptrace/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/ptrace/.gitignore

diff --git a/tools/testing/selftests/ptrace/.gitignore b/tools/testing/selftests/ptrace/.gitignore
new file mode 100644
index 0000000..b3e59d4
--- /dev/null
+++ b/tools/testing/selftests/ptrace/.gitignore
@@ -0,0 +1 @@
+peeksiginfo
-- 
1.9.1
