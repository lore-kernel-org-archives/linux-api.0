From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 10/20] x86/vdso: Use set_normalized_timespec() to avoid 32 bit overflow
Date: Wed, 19 Sep 2018 21:50:27 +0100
Message-ID: <20180919205037.9574-11-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

ts->tv_nsec + offset->tv_nsec

On 32 bit machines that sum can be larger than (1 << 31) and therefor
result in a negative value which screws up the result completely.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vclock_gettime.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/entry/vdso/vclock_gettime.c b/arch/x86/entry/vdso/vclock_gettime.c
index 0594266740b9..a265e2737a9a 100644
--- a/arch/x86/entry/vdso/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vclock_gettime.c
@@ -231,20 +231,37 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 	return mode;
 }
 
+notrace void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec)
+{
+	while (nsec >= NSEC_PER_SEC) {
+		/*
+		 * The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation. See
+		 * also __iter_div_u64_rem() in include/linux/time.h
+		 */
+		asm("" : "+rm"(nsec));
+		nsec -= NSEC_PER_SEC;
+		++sec;
+	}
+	while (nsec < 0) {
+		asm("" : "+rm"(nsec));
+		nsec += NSEC_PER_SEC;
+		--sec;
+	}
+	ts->tv_sec = sec;
+	ts->tv_nsec = nsec;
+}
+
 notrace static __always_inline void monotonic_to_ns(struct timespec *ts)
 {
 #ifdef CONFIG_TIME_NS
 	struct timens_offsets *timens = (struct timens_offsets *) &timens_page;
+	struct timespec offset;
+
+	offset = timespec64_to_timespec(timens->monotonic_time_offset);
+
+	*ts = timespec_add(*ts, offset);
 
-	ts->tv_sec += timens->monotonic_time_offset.tv_sec;
-	ts->tv_nsec += timens->monotonic_time_offset.tv_nsec;
-	if (ts->tv_nsec > NSEC_PER_SEC) {
-		ts->tv_nsec -= NSEC_PER_SEC;
-		ts->tv_sec++;
-	} else if (ts->tv_nsec < 0) {
-		ts->tv_nsec += NSEC_PER_SEC;
-		ts->tv_sec--;
-	}
 #endif
 }
 
-- 
2.13.6
