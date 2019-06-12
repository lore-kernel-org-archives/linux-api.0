From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv4 26/28] x86/vdso: Align VDSO functions by CPU L1 cache line
Date: Wed, 12 Jun 2019 20:26:25 +0100
Message-ID: <20190612192628.23797-27-dima@arista.com>
References: <20190612192628.23797-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612192628.23797-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.ke
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

After performance testing VDSO patches a noticeable 20% regression was
found on gettime_perf selftest with a cold cache.
As it turns to be, before time namespaces introduction, VDSO functions
were quite aligned to cache lines, but adding a new code to adjust
timens offset inside namespace created a small shift and vdso functions
become unaligned on cache lines.

Add align to vdso functions with gcc option to fix performance drop.

Coping the resulting numbers from cover letter:

Hot CPU cache (more gettime_perf.c cycles - the better):
        | before     | CONFIG_TIME_NS=n | host        | inside timens
--------|------------|------------------|-------------|-------------
cycles  | 139887013  | 139453003        | 139899785   | 128792458
diff (%)| 100        | 99.7             | 100         | 92

Cold cache (lesser tsc per gettime_perf_cold.c cycle - the better):
        | before     | CONFIG_TIME_NS=n | host        | inside timens
--------|------------|------------------|-------------|-------------
tsc     | 6748       | 6718             | 6862        | 12682
diff (%)| 100        | 99.6             | 101.7       | 188

Measured on Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz

Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index b58d34120fd8..c7bfd62d1fc3 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -4,6 +4,7 @@
 #
 
 KBUILD_CFLAGS += $(DISABLE_LTO)
+KBUILD_CFLAGS += -falign-functions=$(CONFIG_X86_L1_CACHE_SHIFT)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
-- 
2.22.0
