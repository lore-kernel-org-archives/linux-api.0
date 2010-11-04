From: Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH RFC 6/8] clock device: convert timer_delete
Date: Thu, 4 Nov 2010 20:30:04 +0100
Message-ID: <9572b12e091e4dbab43e7c883e633fdb314fe574.1288897199.git.richard.cochran@omicron.at>
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

This patch lets the timer_delete system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/clockdevice.h |    1 +
 kernel/posix-timers.c       |    7 +++++++
 kernel/time/clockdevice.c   |   18 ++++++++++++++++++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
index 3201a28..592bd5e 100644
--- a/include/linux/clockdevice.h
+++ b/include/linux/clockdevice.h
@@ -107,5 +107,6 @@ struct clock_device *clockid_to_clock_device(clockid_t id);
  * The following functions are only to be called from posix-timers.c
  */
 int clock_device_timer_create(struct clock_device *clk, struct k_itimer *kit);
+int clock_device_timer_delete(struct clock_device *clk, struct k_itimer *kit);
 
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 42efbe9..5feb565 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -857,6 +857,13 @@ static inline int common_timer_del(struct k_itimer *timer)
 
 static inline int timer_delete_hook(struct k_itimer *timer)
 {
+	struct clock_device *clk_dev;
+
+	clk_dev = clockid_to_clock_device(timer->it_clock);
+
+	if (clk_dev)
+		return clock_device_timer_delete(clk_dev, timer);
+
 	return CLOCK_DISPATCH(timer->it_clock, timer_del, (timer));
 }
 
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index 166cc30..27d13a4 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -281,3 +281,21 @@ int clock_device_timer_create(struct clock_device *clk, struct k_itimer *kit)
 	mutex_unlock(&clk->mux);
 	return err;
 }
+
+int clock_device_timer_delete(struct clock_device *clk, struct k_itimer *kit)
+{
+	int err;
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->timer_delete)
+		err = -EOPNOTSUPP;
+	else
+		err = clk->ops->timer_delete(clk->priv, kit);
+
+	mutex_unlock(&clk->mux);
+
+	return err;
+}
-- 
1.7.0.4
