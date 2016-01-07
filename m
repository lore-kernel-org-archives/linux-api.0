From: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] update .gitignore in selftests/vm
Date: Thu, 7 Jan 2016 14:53:59 +0800
Message-ID: <1452149642-7597-1-git-send-email-sunyuan3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/vm/.gitignore | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/vm/.gitignore b/tools/testing/selftests/vm/.gitignore
index ff1bb16..a937a9d 100644
--- a/tools/testing/selftests/vm/.gitignore
+++ b/tools/testing/selftests/vm/.gitignore
@@ -2,3 +2,8 @@ hugepage-mmap
 hugepage-shm
 map_hugetlb
 thuge-gen
+compaction_test
+mlock2-tests
+on-fault-limit
+transhuge-stress
+userfaultfd
-- 
1.9.1
