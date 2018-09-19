From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 14/20] timens: Add align for timens_offsets
Date: Wed, 19 Sep 2018 21:50:31 +0100
Message-ID: <20180919205037.9574-15-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Align offsets so that Time Namespace will work for ia32 applications on
x86_64 host.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/timens_offsets.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/timens_offsets.h b/include/linux/timens_offsets.h
index 777530c46852..92a8ea5601eb 100644
--- a/include/linux/timens_offsets.h
+++ b/include/linux/timens_offsets.h
@@ -2,9 +2,16 @@
 #ifndef _LINUX_TIME_OFFSETS_H
 #define _LINUX_TIME_OFFSETS_H
 
+/*
+ * Time offsets need align as they're placed on vvar page,
+ * which should have tail paddings on ia32 vdso.
+ * Otherwise as u64 has align(4), vvar offsets will differ.
+ * On 64-bit big-endian systems vdso should convert to timespec64
+ * to timespec because of a padding occuring between the fields.
+ */
 struct timens_offsets {
-	struct timespec64  monotonic_time_offset;
-	struct timespec64  monotonic_boottime_offset;
+	struct timespec64  monotonic_time_offset __aligned(8);
+	struct timespec64  monotonic_boottime_offset __aligned(8);
 };
 
 #endif
-- 
2.13.6
