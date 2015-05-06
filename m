From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/19] y2038: introduce CONFIG_COMPAT_TIME
Date: Wed,  6 May 2015 18:30:11 +0200
Message-ID: <1430929826-318934-5-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-58711-glibc-alpha=m.gmane.org@sourceware.org>
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

There are a total of system calls (aside from ioctl) that pass a time_t
or derived data structure as an argument, and in order to extend time_t
to 64-bit, we have to replace them with new system calls and keep providing
backwards compatibility.

To avoid adding completely new and untested code for this purpose, we
introduce a new CONFIG_COMPAT_TIME symbol that is always set on 64-bit
architectures with 32-bit compat mode, as well as all 32-bit architectures
that have been extended to provide the new system calls.

After this is done for all architectures, the CONFIG_COMPAT_TIME symbol
can be made a user-selected option, to enable users to build a kernel
that only provides y2038-safe system calls.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index a65eafb24997..630d3d289569 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -545,4 +545,15 @@ config OLD_SIGACTION
 config COMPAT_OLD_SIGACTION
 	bool
 
+config ARCH_HAS_COMPAT_TIME
+	def_bool COMPAT
+
+config COMPAT_TIME
+	def_bool ARCH_HAS_COMPAT_TIME
+	help
+	  This should be selected by all architectures that need to support
+	  system calls with a 32-bit time_t. Traditionally, this has been
+	  used on all 32-bit architectures, and needs to be supported on
+	  64-bit architectures as part of compat syscall handling.
+
 source "kernel/gcov/Kconfig"
-- 
2.1.0.rc2
