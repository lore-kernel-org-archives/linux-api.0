From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 15/19] y2038: introduce timespec64_to_jiffies
Date: Wed,  6 May 2015 18:30:22 +0200
Message-ID: <1430929826-318934-16-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-58717-glibc-alpha=m.gmane.org@sourceware.org>
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

This is needed to convert do_sigtimedwait to use timespec64.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/jiffies.h | 13 ++++++++++++-
 kernel/time/time.c      | 11 ++---------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index c367cbdf73ab..2aeb872f5547 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -290,7 +290,18 @@ static inline u64 jiffies_to_nsecs(const unsigned long j)
 
 extern unsigned long msecs_to_jiffies(const unsigned int m);
 extern unsigned long usecs_to_jiffies(const unsigned int u);
-extern unsigned long timespec_to_jiffies(const struct timespec *value);
+extern unsigned long __timespec_to_jiffies(unsigned long sec, long nsec);
+static inline unsigned long timespec_to_jiffies(const struct timespec *value)
+{
+	return __timespec_to_jiffies(value->tv_sec, value->tv_nsec);
+}
+
+static inline unsigned long timespec64_to_jiffies(const struct timespec64 *value)
+{
+	return __timespec_to_jiffies(value->tv_sec, value->tv_nsec);
+}
+
+
 extern void jiffies_to_timespec(const unsigned long jiffies,
 				struct timespec *value);
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 845af1db66fa..4d96236c07b0 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -571,7 +571,7 @@ EXPORT_SYMBOL(usecs_to_jiffies);
  * The >> (NSEC_JIFFIE_SC - SEC_JIFFIE_SC) converts the scaled nsec
  * value to a scaled second value.
  */
-static unsigned long
+unsigned long
 __timespec_to_jiffies(unsigned long sec, long nsec)
 {
 	nsec = nsec + TICK_NSEC - 1;
@@ -585,14 +585,7 @@ __timespec_to_jiffies(unsigned long sec, long nsec)
 		 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
 
 }
-
-unsigned long
-timespec_to_jiffies(const struct timespec *value)
-{
-	return __timespec_to_jiffies(value->tv_sec, value->tv_nsec);
-}
-
-EXPORT_SYMBOL(timespec_to_jiffies);
+EXPORT_SYMBOL(__timespec_to_jiffies);
 
 void
 jiffies_to_timespec(const unsigned long jiffies, struct timespec *value)
-- 
2.1.0.rc2
