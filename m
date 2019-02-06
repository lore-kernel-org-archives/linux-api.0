From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 18/32] x86/vdso.lds: Align !timens (host's) vdso.so entries
Date: Wed,  6 Feb 2019 00:10:52 +0000
Message-ID: <20190206001107.16488-19-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

As it has been discussed on timens RFC, adding a new conditional branch
`if (inside_time_ns)` on VDSO for all processes is undesirable.
It will add a penalty for everybody as branch predictor may mispredict
the jump. Also there are instruction cache lines wasted on cmp/jmp.

Those effects of introducing time namespace are very much unwanted
having in mind how much work have been spent on micro-optimisation
vdso code.

Addressing those problems, there are two versions of VDSO's .so:
for host tasks (without any penalty) and for processes inside of time
namespace with clk_to_ns() that subtracts offsets from host's time.

Unfortunately, to allow changing VDSO VMA on a running process,
the entry points to VDSO should have the same offsets (addresses).
That's needed as i.e. application that calls setns() may have already
resolved VDSO symbols in GOT/PLT.

Align VDSO entries for host with addresses generated from timens VDSO
(which is bigger as it has code for adding offsets).

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vdso-layout.lds.S | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index ba216527e59f..e529ee3ec9e8 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -70,7 +70,17 @@ SECTIONS
 	 * stuff that isn't used at runtime in between.
 	 */
 
-	.text		: { *(.text*) }			:text	=0x90909090,
+	.text		: {
+#if defined(CONFIG_TIME_NS) && !defined(UNALIGNED_ENTRIES)
+#ifdef BUILD_VDSO32
+# include "vdso32.entries"
+#endif
+#ifdef BUILD_VDSO64
+# include "vdso64.entries"
+#endif
+#endif
+		*(.text*)
+	}						:text	=0x90909090,
 
 	.altinstructions	: { *(.altinstructions) }	:text
 	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
-- 
2.20.1
