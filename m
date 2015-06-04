From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] tools, add tools/testing/selftests/timers/.gitignore
Date: Thu,  4 Jun 2015 13:53:12 -0400
Message-ID: <1433440392-31274-1-git-send-email-prarit@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

After building the tests in the timers directory each executable shows up
in 'git-status' as a new file.  This patch adds a .gitignore file to the
directory.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 tools/testing/selftests/timers/.gitignore |    3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/timers/.gitignore

diff --git a/tools/testing/selftests/timers/.gitignore b/tools/testing/selftests/timers/.gitignore
new file mode 100644
index 0000000..afe9743
--- /dev/null
+++ b/tools/testing/selftests/timers/.gitignore
@@ -0,0 +1,3 @@
+*
+!*.c
+!.gitignore
-- 
1.7.9.3
