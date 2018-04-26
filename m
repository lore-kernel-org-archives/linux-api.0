From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH manpages] clock_getres.2: document CLOCK_MONOTONIC suspend behavior
Date: Thu, 26 Apr 2018 15:44:19 -0400
Message-ID: <20180426194419.24854-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Stephen Boyd <sboyd@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Considering that user-space expects CLOCK_MONOTONIC not to account time
during which system is suspended, explicitly document this behavior as
ABI.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>
CC: Stephen Boyd <sboyd@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
---
 man2/clock_getres.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man2/clock_getres.2 b/man2/clock_getres.2
index 0812d159a..ca5ca87c8 100644
--- a/man2/clock_getres.2
+++ b/man2/clock_getres.2
@@ -144,7 +144,7 @@ This clock is not affected by discontinuous jumps in the system time
 (e.g., if the system administrator manually changes the clock),
 but is affected by the incremental adjustments performed by
 .BR adjtime (3)
-and NTP.
+and NTP. It does not include time during which the system is suspended.
 .TP
 .BR CLOCK_MONOTONIC_COARSE " (since Linux 2.6.32; Linux-specific)"
 .\" Added in commit da15cfdae03351c689736f8d142618592e3cebc3
-- 
2.11.0
