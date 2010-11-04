From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 8/8] clock device: convert timer_settime
Date: Thu, 4 Nov 2010 20:30:49 +0100
Message-ID: <b01f31d7dbb6c60b9b36d7408c0be99badfa7661.1288897199.git.richard.cochran@omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch lets the timer_settime system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
---
 include/linux/clockdevice.h |    3 +++
 kernel/posix-timers.c       |   12 +++++++++---
 kernel/time/clockdevice.c   |   20 ++++++++++++++++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
index b56debb..d3589a0 100644
--- a/include/linux/clockdevice.h
+++ b/include/linux/clockdevice.h
@@ -110,5 +110,8 @@ int clock_device_timer_create(struct clock_device *clk, struct k_itimer *kit);
 int clock_device_timer_delete(struct clock_device *clk, struct k_itimer *kit);
 void clock_device_timer_gettime(struct clock_device *clk, struct k_itimer *kit,
 				struct itimerspec *tsp);
+int clock_device_timer_settime(struct clock_device *clk,
+			       struct k_itimer *kit, int flags,
+			       struct itimerspec *tsp, struct itimerspec *old);
 
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index d00ff73..b09e37e 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -817,6 +817,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 		const struct itimerspec __user *, new_setting,
 		struct itimerspec __user *, old_setting)
 {
+	struct clock_device *clk_dev;
 	struct k_itimer *timr;
 	struct itimerspec new_spec, old_spec;
 	int error = 0;
@@ -837,9 +838,14 @@ retry:
 	if (!timr)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(timr->it_clock, timer_set,
-			       (timr, flags, &new_spec, rtn));
-
+	clk_dev = clockid_to_clock_device(timr->it_clock);
+	if (clk_dev)
+		error = clock_device_timer_settime(clk_dev, timr,
+						   flags, &new_spec, rtn);
+	else {
+		error = CLOCK_DISPATCH(timr->it_clock, timer_set,
+				       (timr, flags, &new_spec, rtn));
+	}
 	unlock_timer(timr, flag);
 	if (error == TIMER_RETRY) {
 		rtn = NULL;	// We already got the old time...
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index 0f6f913..3345c3a 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -314,3 +314,23 @@ void clock_device_timer_gettime(struct clock_device *clk, struct k_itimer *kit,
 out:
 	mutex_unlock(&clk->mux);
 }
+
+int clock_device_timer_settime(struct clock_device *clk,
+			       struct k_itimer *kit, int flags,
+			       struct itimerspec *tsp, struct itimerspec *old)
+{
+	int err;
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->timer_settime)
+		err = -EOPNOTSUPP;
+	else
+		err = clk->ops->timer_settime(clk->priv, kit, flags, tsp, old);
+
+	mutex_unlock(&clk->mux);
+
+	return err;
+}
-- 
1.7.0.4
