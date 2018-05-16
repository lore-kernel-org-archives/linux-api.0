From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 07/24] arm64: ilp32: add documentation on the ILP32 ABI for ARM64
Date: Wed, 16 May 2018 11:18:52 +0300
Message-ID: <20180516081910.10067-8-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

Based on Andrew Pinski's patch-series.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 Documentation/arm64/ilp32.txt | 45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/arm64/ilp32.txt

diff --git a/Documentation/arm64/ilp32.txt b/Documentation/arm64/ilp32.txt
new file mode 100644
index 000000000000..d0fd5109c4b2
--- /dev/null
+++ b/Documentation/arm64/ilp32.txt
@@ -0,0 +1,45 @@
+ILP32 AARCH64 SYSCALL ABI
+=========================
+
+This document describes the ILP32 syscall ABI and where it differs
+from the generic compat linux syscall interface.
+
+AARCH64/ILP32 userspace can pass garbage in the top halve of w0-w7 registers
+(syscall arguments). So top 32 bits are zeroed for them.
+
+Comparing to AARCH32, AARCH64/ILP32 has 64-bit length of following types:
+ino_t       is u64 type.
+off_t       is s64 type.
+blkcnt_t    is s64 type.
+fsblkcnt_t  is u64 type.
+fsfilcnt_t  is u64 type.
+rlim_t      is u64 type.
+
+AARCH64/ILP32 ABI uses standard syscall table which can be found at
+include/uapi/asm-generic/unistd.h, with the exceptions listed below.
+
+Syscalls which pass 64-bit values are handled by the code shared from
+AARCH32 and pass that value as a pair. Following syscalls are affected:
+fadvise64_64()
+fallocate()
+ftruncate64()
+pread64()
+pwrite64()
+readahead()
+sync_file_range()
+truncate64()
+
+ptrace() syscall is handled by compat version.
+
+shmat() syscall is handled by non-compat handler as aarch64/ilp32 has no
+limitation on 4-pages alignment for shared memory.
+
+statfs() and fstatfs() take the size of struct statfs as an argument.
+It is calculated differently in kernel and user spaces. So AARCH32 handlers
+are taken to handle it.
+
+struct rt_sigframe is redefined and contains struct compat_siginfo,
+as compat syscalls expect, and struct ilp32_ucontext, to handle
+AARCH64 register set and 32-bit userspace register representation.
+
+elf_gregset_t is taken from lp64 to handle registers properly.
-- 
2.17.0
