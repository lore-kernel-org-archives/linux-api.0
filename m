From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 09/38] selftests/timers: fix write return value handlng
Date: Mon, 21 Sep 2015 15:33:41 +0200
Message-ID: <1442842450-29769-10-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The function can return negative value.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 tools/testing/selftests/timers/clocksource-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/timers/clocksource-switch.c b/tools/testing/selftests/timers/clocksource-switch.c
index 627ec74..fd88e30 100644
--- a/tools/testing/selftests/timers/clocksource-switch.c
+++ b/tools/testing/selftests/timers/clocksource-switch.c
@@ -97,7 +97,7 @@ int get_cur_clocksource(char *buf, size_t size)
 int change_clocksource(char *clocksource)
 {
 	int fd;
-	size_t size;
+	ssize_t size;
 
 	fd = open("/sys/devices/system/clocksource/clocksource0/current_clocksource", O_WRONLY);
 
-- 
1.9.1
