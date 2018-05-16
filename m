From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 05/24] asm-generic: Drop getrlimit and setrlimit syscalls from
 default list
Date: Wed, 16 May 2018 11:18:50 +0300
Message-ID: <20180516081910.10067-6-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux@lists.openrisc.net, linux-hexagon@vger.kernel.org, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, Jonas Bonn <jonas@southpole.se>, Chen Liqin <liqin.linux@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>, Steve Ellcey <sellcey@caviumnetworks.com>, linux-c6x-dev@linux-c6x.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Alexander Graf <agraf@suse.de>, Bamvor Zhangjian <bamv2005@gmail.com>, Lennox Wu <lennox.wu@gmail.com>, Mark Salter <msalter@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-snps-arc@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, uclinux-h
List-Id: linux-api@vger.kernel.org

The newer prlimit64 syscall provides all the functionality provided by
getrlimit and setrlimit syscalls and adds the pid of target process, so
future architectures won't need to include getrlimit and setrlimit.

Therefore drop getrlimit and setrlimit syscalls from the generic syscall
list unless __ARCH_WANT_SET_GET_RLIMIT is defined by the architecture's
unistd.h prior to including asm-generic/unistd.h, and adjust all
architectures using the generic syscall list to define it so that no
in-tree architectures are affected.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org
Cc: linux-snps-arc@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-metag@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: nios2-dev@lists.rocketboards.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: uclinux-h8-devel@lists.sourceforge.jp
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Salter <msalter@redhat.com> [c6x]
Acked-by: James Hogan <james.hogan@imgtec.com> [metag]
Acked-by: Ley Foon Tan <lftan@altera.com> [nios2]
Acked-by: Stafford Horne <shorne@gmail.com> [openrisc]
Acked-by: Will Deacon <will.deacon@arm.com> [arm64]
Acked-by: Vineet Gupta <vgupta@synopsys.com> #arch/arc bits
---
 arch/arc/include/uapi/asm/unistd.h       | 1 +
 arch/arm64/include/uapi/asm/unistd.h     | 1 +
 arch/c6x/include/uapi/asm/unistd.h       | 1 +
 arch/h8300/include/uapi/asm/unistd.h     | 1 +
 arch/hexagon/include/uapi/asm/unistd.h   | 1 +
 arch/metag/include/uapi/asm/unistd.h     | 1 +
 arch/nios2/include/uapi/asm/unistd.h     | 1 +
 arch/openrisc/include/uapi/asm/unistd.h  | 1 +
 arch/score/include/uapi/asm/unistd.h     | 1 +
 arch/tile/include/uapi/asm/unistd.h      | 1 +
 arch/unicore32/include/uapi/asm/unistd.h | 1 +
 include/uapi/asm-generic/unistd.h        | 5 +++++
 scripts/checksyscalls.sh                 | 5 +++++
 13 files changed, 21 insertions(+)

diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
index 517178b1daef..660dbb2e799c 100644
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -17,6 +17,7 @@
 #define _UAPI_ASM_ARC_UNISTD_H
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
index 5072cbd15c82..439b1c55c827 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -16,5 +16,6 @@
  */
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 #include <asm-generic/unistd.h>
diff --git a/arch/c6x/include/uapi/asm/unistd.h b/arch/c6x/include/uapi/asm/unistd.h
index 0d2daf7f9809..df40dc128ba9 100644
--- a/arch/c6x/include/uapi/asm/unistd.h
+++ b/arch/c6x/include/uapi/asm/unistd.h
@@ -16,6 +16,7 @@
  */
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_CLONE
 
 /* Use the standard ABI for syscalls. */
diff --git a/arch/h8300/include/uapi/asm/unistd.h b/arch/h8300/include/uapi/asm/unistd.h
index 7dd20ef7625a..2f98394b77d4 100644
--- a/arch/h8300/include/uapi/asm/unistd.h
+++ b/arch/h8300/include/uapi/asm/unistd.h
@@ -1,5 +1,6 @@
 #define __ARCH_NOMMU
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 #include <asm-generic/unistd.h>
diff --git a/arch/hexagon/include/uapi/asm/unistd.h b/arch/hexagon/include/uapi/asm/unistd.h
index ea181e79162e..c9eb56ed5744 100644
--- a/arch/hexagon/include/uapi/asm/unistd.h
+++ b/arch/hexagon/include/uapi/asm/unistd.h
@@ -29,6 +29,7 @@
 
 #define sys_mmap2 sys_mmap_pgoff
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/metag/include/uapi/asm/unistd.h b/arch/metag/include/uapi/asm/unistd.h
index 9f72c4cfcfb5..ca34435878dc 100644
--- a/arch/metag/include/uapi/asm/unistd.h
+++ b/arch/metag/include/uapi/asm/unistd.h
@@ -9,6 +9,7 @@
  */
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
diff --git a/arch/nios2/include/uapi/asm/unistd.h b/arch/nios2/include/uapi/asm/unistd.h
index b6bdae04bc84..aa4e90e00885 100644
--- a/arch/nios2/include/uapi/asm/unistd.h
+++ b/arch/nios2/include/uapi/asm/unistd.h
@@ -19,6 +19,7 @@
  #define sys_mmap2 sys_mmap_pgoff
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 /* Use the standard ABI for syscalls */
 #include <asm-generic/unistd.h>
diff --git a/arch/openrisc/include/uapi/asm/unistd.h b/arch/openrisc/include/uapi/asm/unistd.h
index 9a3ee389631e..8e838aa4fcd8 100644
--- a/arch/openrisc/include/uapi/asm/unistd.h
+++ b/arch/openrisc/include/uapi/asm/unistd.h
@@ -22,6 +22,7 @@
 #define sys_mmap2 sys_mmap_pgoff
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_CLONE
 
diff --git a/arch/score/include/uapi/asm/unistd.h b/arch/score/include/uapi/asm/unistd.h
index 04da47bd3d46..a64e6f131434 100644
--- a/arch/score/include/uapi/asm/unistd.h
+++ b/arch/score/include/uapi/asm/unistd.h
@@ -2,6 +2,7 @@
 #define __ARCH_HAVE_MMU
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYSCALL_NO_AT
 #define __ARCH_WANT_SYSCALL_NO_FLAGS
 #define __ARCH_WANT_SYSCALL_OFF_T
diff --git a/arch/tile/include/uapi/asm/unistd.h b/arch/tile/include/uapi/asm/unistd.h
index 1a169ec92ef8..57ab278fe26f 100644
--- a/arch/tile/include/uapi/asm/unistd.h
+++ b/arch/tile/include/uapi/asm/unistd.h
@@ -14,6 +14,7 @@
  */
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 #if !defined(__LP64__) || defined(__SYSCALL_COMPAT)
 /* Use the flavor of this syscall that matches the 32-bit API better. */
 #define __ARCH_WANT_SYNC_FILE_RANGE2
diff --git a/arch/unicore32/include/uapi/asm/unistd.h b/arch/unicore32/include/uapi/asm/unistd.h
index 65856eaab163..0314f7894375 100644
--- a/arch/unicore32/include/uapi/asm/unistd.h
+++ b/arch/unicore32/include/uapi/asm/unistd.h
@@ -12,6 +12,7 @@
  */
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 426a1a496d9d..a460e9a9b42d 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -465,10 +465,15 @@ __SYSCALL(__NR_uname, sys_newuname)
 __SYSCALL(__NR_sethostname, sys_sethostname)
 #define __NR_setdomainname 162
 __SYSCALL(__NR_setdomainname, sys_setdomainname)
+
+#ifdef __ARCH_WANT_SET_GET_RLIMIT
+/* getrlimit and setrlimit are superseded with prlimit64 */
 #define __NR_getrlimit 163
 __SC_COMP(__NR_getrlimit, sys_getrlimit, compat_sys_getrlimit)
 #define __NR_setrlimit 164
 __SC_COMP(__NR_setrlimit, sys_setrlimit, compat_sys_setrlimit)
+#endif
+
 #define __NR_getrusage 165
 __SC_COMP(__NR_getrusage, sys_getrusage, compat_sys_getrusage)
 #define __NR_umask 166
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index ee3dfb5be6cd..5717766c5b4a 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -38,6 +38,11 @@ cat << EOF
 #define __IGNORE_lstat64	/* fstatat64 */
 #endif
 
+#ifndef __ARCH_WANT_SET_GET_RLIMIT
+#define __IGNORE_getrlimit	/* getrlimit */
+#define __IGNORE_setrlimit	/* setrlimit */
+#endif
+
 /* Missing flags argument */
 #define __IGNORE_renameat	/* renameat2 */
 
-- 
2.17.0
