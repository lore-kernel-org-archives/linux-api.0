From: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests/mount: Make git ignore all binaries in mount test
 suite
Date: Sat, 28 Mar 2015 09:51:13 +0800
Message-ID: <55160911.8080302@huawei.com>
References: <1427507045-68758-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427507045-68758-1-git-send-email-zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch includes the mount test binaries into the .gitignore
file listing in their respective directories. This will make sure
that git ignores all of these test binaries when displaying status.

Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/mount/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/mount/.gitignore

diff --git a/tools/testing/selftests/mount/.gitignore b/tools/testing/selftests/mount/.gitignore
new file mode 100644
index 0000000..856ad41
--- /dev/null
+++ b/tools/testing/selftests/mount/.gitignore
@@ -0,0 +1 @@
+unprivileged-remount-test
-- 
1.8.5.5


.
