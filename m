From: Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH RFC 7/8] clock device: convert timer_gettime
Date: Thu, 4 Nov 2010 20:30:26 +0100
Message-ID: <b9498f9489d2fa947fcbad3e4828079347f7e283.1288897199.git.richard.cochran@omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran@omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>, John Stultz <johnstul@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

This patch lets the timer_gettime system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/clockdevice.h |    2 ++
 kernel/posix-timers.c       |    9 ++++++++-
 kernel/time/clockdevice.c   |   15 +++++++++++++++
 3 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
index 592bd5e..b56debb 100644
--- a/include/linux/clockdevice.h
+++ b/include/linux/clockdevice.h
@@ -108,5 +108,7 @@ struct clock_device *clockid_to_clock_device(clockid_t id);
  */
 int clock_device_timer_create(struct clock_device *clk, struct k_itimer *kit);
 int clock_device_timer_delete(struct clock_device *clk, struct k_itimer *kit);
+void clock_device_timer_gettime(struct clock_device *clk, struct k_itimer *kit,
+				struct itimerspec *tsp);
 
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 5feb565..d00ff73 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -711,6 +711,7 @@ common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 		struct itimerspec __user *, setting)
 {
+	struct clock_device *clk_dev;
 	struct k_itimer *timr;
 	struct itimerspec cur_setting;
 	unsigned long flags;
@@ -719,7 +720,13 @@ SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 	if (!timr)
 		return -EINVAL;
 
-	CLOCK_DISPATCH(timr->it_clock, timer_get, (timr, &cur_setting));
+	clk_dev = clockid_to_clock_device(timr->it_clock);
+
+	if (clk_dev)
+		clock_device_timer_gettime(clk_dev, timr, &cur_setting);
+	else {
+		CLOCK_DISPATCH(timr->it_clock, timer_get, (timr, &cur_setting));
+	}
 
 	unlock_timer(timr, flags);
 
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index 27d13a4..0f6f913 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -299,3 +299,18 @@ int clock_device_timer_delete(struct clock_device *clk, struct k_itimer *kit)
 
 	return err;
 }
+
+void clock_device_timer_gettime(struct clock_device *clk, struct k_itimer *kit,
+				struct itimerspec *tsp)
+{
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		goto out;
+	else if (!clk->ops->timer_gettime)
+		goto out;
+	else
+		clk->ops->timer_gettime(clk->priv, kit, tsp);
+out:
+	mutex_unlock(&clk->mux);
+}
-- 
1.7.0.4
