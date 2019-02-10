From: Christian Brauner <christian@brauner.io>
Subject: [RFC PATCH v4 3/3] sysctl: return -EINVAL if val violates minmax
Date: Sun, 10 Feb 2019 21:39:43 +0100
Message-ID: <20190210203943.8227-4-christian@brauner.io>
References: <20190210203943.8227-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190210203943.8227-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, mcgrof@kernel.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Currently when userspace gives us a values that overflow e.g. file-max and
other callers of __do_proc_doulongvec_minmax() we simply
ignore the new value and leave the current value untouched. This can be
problematic as it gives the illusion that the limit has indeed be bumped
when in fact it failed.
This commit makes sure to return EINVAL when an overflow is detected.
Please note that this is a userspace facing change.

Signed-off-by: Christian Brauner <christian@brauner.io>
---
/* Changelog */
v4:
- patch introduced

v1-v3:
- patch not present
---
 kernel/sysctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c4a44b7ccb8a..516bc8a2812d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2846,8 +2846,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 			if (neg)
 				continue;
 			val = convmul * val / convdiv;
-			if ((min && val < *min) || (max && val > *max))
-				continue;
+			if ((min && val < *min) || (max && val > *max)) {
+				err = -EINVAL;
+				break;
+			}
 			*i = val;
 		} else {
 			val = convdiv * (*i) / convmul;
-- 
2.20.1
