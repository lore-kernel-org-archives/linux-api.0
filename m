From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 18/19] y2038: introduce jiffies_to_timespec64
Date: Wed,  6 May 2015 18:30:25 +0200
Message-ID: <1430929826-318934-19-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-58718-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Needed for converting sys_sched_rr_get_interval

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/jiffies.h | 12 +++++++++---
 kernel/time/time.c      |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 2aeb872f5547..6647257fa3da 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -301,9 +301,15 @@ static inline unsigned long timespec64_to_jiffies(const struct timespec64 *value
 	return __timespec_to_jiffies(value->tv_sec, value->tv_nsec);
 }
 
-
-extern void jiffies_to_timespec(const unsigned long jiffies,
-				struct timespec *value);
+extern void jiffies_to_timespec64(const unsigned long jiffies,
+				  struct timespec64 *value);
+static inline void jiffies_to_timespec(const unsigned long jiffies,
+				       struct timespec *value)
+{
+	struct timespec64 ts64;
+	jiffies_to_timespec64(jiffies, &ts64);
+	*value = timespec64_to_timespec(ts64);
+}
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 4d96236c07b0..5e71dbd36fff 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -588,7 +588,7 @@ __timespec_to_jiffies(unsigned long sec, long nsec)
 EXPORT_SYMBOL(__timespec_to_jiffies);
 
 void
-jiffies_to_timespec(const unsigned long jiffies, struct timespec *value)
+jiffies_to_timespec64(const unsigned long jiffies, struct timespec64 *value)
 {
 	/*
 	 * Convert jiffies to nanoseconds and separate with
-- 
2.1.0.rc2
