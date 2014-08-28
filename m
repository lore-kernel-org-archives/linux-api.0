From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH] MAINTAINERS: Add entry for Kernel Selftest Framework
Date: Thu, 28 Aug 2014 09:19:49 -0600
Message-ID: <1409239189-22878-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, m.chehab@samsung.com, davem@davemloft.net, crope@iki.fi
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add entry for Kernel Selftest Framework. Individual tests
continue to be maintained by the maintainers for those areas.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ff06de..5aaaeab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5209,6 +5209,13 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 F:	include/uapi/linux/sunrpc/
 
+KERNEL SELFTEST FRAMEWORK
+M:	Shuah Khan <shuahkh@osg.samsung.com>
+L:	linux-api@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/shuah/linux-kselftest
+S:	Maintained
+F:	tools/testing/selftests
+
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Gleb Natapov <gleb@kernel.org>
 M:	Paolo Bonzini <pbonzini@redhat.com>
-- 
1.9.1
