From: Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH RFC 5/8] clock device: convert timer_create
Date: Thu, 4 Nov 2010 20:29:34 +0100
Message-ID: <996249855b4c2b680bedddf8a4e825a9d7eca3e5.1288897199.git.richard.cochran@omicron.at>
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

This patch lets the timer_create system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/clockdevice.h |    5 +++++
 kernel/posix-timers.c       |   12 ++++++++++--
 kernel/time/clockdevice.c   |   17 +++++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
index ae258ac..3201a28 100644
--- a/include/linux/clockdevice.h
+++ b/include/linux/clockdevice.h
@@ -103,4 +103,9 @@ void *clock_device_private(struct file *fp);
  */
 struct clock_device *clockid_to_clock_device(clockid_t id);
 
+/*
+ * The following functions are only to be called from posix-timers.c
+ */
+int clock_device_timer_create(struct clock_device *clk, struct k_itimer *kit);
+
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ef4e222..42efbe9 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -39,6 +39,7 @@
 #include <asm/uaccess.h>
 #include <linux/list.h>
 #include <linux/init.h>
+#include <linux/clockdevice.h>
 #include <linux/compiler.h>
 #include <linux/idr.h>
 #include <linux/posix-timers.h>
@@ -523,12 +524,15 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		struct sigevent __user *, timer_event_spec,
 		timer_t __user *, created_timer_id)
 {
+	struct clock_device *clk_dev;
 	struct k_itimer *new_timer;
 	int error, new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
-	if (invalid_clockid(which_clock))
+	clk_dev = clockid_to_clock_device(which_clock);
+
+	if (!clk_dev && invalid_clockid(which_clock))
 		return -EINVAL;
 
 	new_timer = alloc_posix_timer();
@@ -591,7 +595,11 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		goto out;
 	}
 
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	if (clk_dev)
+		error = clock_device_timer_create(clk_dev, new_timer);
+	else {
+		error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	}
 	if (error)
 		goto out;
 
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index 3f2870d..166cc30 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -264,3 +264,20 @@ SYSCALL_DEFINE2(clock_settime,
 	mutex_unlock(&clk->mux);
 	return err;
 }
+
+int clock_device_timer_create(struct clock_device *clk, struct k_itimer *kit)
+{
+	int err;
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->timer_create)
+		err = -EOPNOTSUPP;
+	else
+		err = clk->ops->timer_create(clk->priv, kit);
+
+	mutex_unlock(&clk->mux);
+	return err;
+}
-- 
1.7.0.4
