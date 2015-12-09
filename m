From: Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH v2 2/5] test: firmware_class: use kstrndup() where appropriate
Date: Wed,  9 Dec 2015 14:50:26 -0800
Message-ID: <1449701429-121423-2-git-send-email-computersforpeace@gmail.com>
References: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, Brian Norris <computersforpeace@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-api@vger.kernel.org

We're essentially just doing an open-coded kstrndup(). The only
differences are with what happens after the first '\0' character, but
request_firmware() doesn't care about that.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
New in v2

 lib/test_firmware.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 841191061816..690b9c35a274 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -54,10 +54,9 @@ static ssize_t trigger_request_store(struct device *dev,
 	int rc;
 	char *name;
 
-	name = kzalloc(count + 1, GFP_KERNEL);
+	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
 		return -ENOSPC;
-	memcpy(name, buf, count);
 
 	pr_info("loading '%s'\n", name);
 
-- 
2.6.0.rc2.230.g3dd15c0
