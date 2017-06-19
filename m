From: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 03/20] asm-generic: Drop getrlimit and setrlimit syscalls
 from default list
Date: Mon, 19 Jun 2017 22:42:23 +0100
Message-ID: <20170619214223.GS6973@jhogan-linux.le.imgtec.org>
References: <20170619155003.13218-1-ynorov@caviumnetworks.com>
 <20170619155003.13218-4-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4657337216978541920=="
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170619155003.13218-4-ynorov@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: linux-doc@vger.kernel.org, szabolcs.nagy@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Chris Metcalf <cmetcalf@ezchip.com>, linux@lists.openrisc.net, linux-hexagon@vger.kernel.org, philipp.tomsich@theobroma-systems.com, Joseph Myers <joseph@codesourcery.com>, linux-arch@vger.kernel.org, Chen Liqin <liqin.linux@gmail.com>, zhouchengming1@huawei.com, Guan Xuetao <gxt@mprc.pku.edu.cn>, Steve Ellcey <sellcey@caviumnetworks.com>, linux-c6x-dev@linux-c6x.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Prasun.Kapoor@caviumnetworks.com, Andreas Schwab <schwab@suse.de>, Aurelien Jacquiot <a-jacquiot@ti.com>, Alexander Graf <agraf@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Lennox Wu <lennox.wu@gmail.com>, Mark Salter <msalter@redhat.com>, linux-snps-arc@lists.infradead.org, uclinux-h
List-Id: linux-api@vger.kernel.org

--===============4657337216978541920==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VAJERZhbIWAQ3W3F"
Content-Disposition: inline

--VAJERZhbIWAQ3W3F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yury,

On Mon, Jun 19, 2017 at 06:49:46PM +0300, Yury Norov wrote:
> The newer prlimit64 syscall provides all the functionality provided by
> the getrlimit and setrlimit syscalls and adds the pid of target process,
> so future architectures won't need to include getrlimit and setrlimit.
>=20
> Therefore drop getrlimit and setrlimit syscalls from the generic syscall
> list unless __ARCH_WANT_SET_GET_RLIMIT is defined by the architecture's
> unistd.h prior to including asm-generic/unistd.h, and adjust all architec=
tures
> using the generic syscall list to define it so that no in-tree architectu=
res
> are affected.

I have a similar experimental patch lying around for the stat system
calls which are superseded by statx (see below). If it looks acceptable
maybe you'd like to incorporate it (or something similar) into your
series.

Cheers
James

---
=46rom: James Hogan <james.hogan@imgtec.com>
Date: Fri, 2 Jun 2017 13:07:27 +0100
Subject: [PATCH] Deprecate stat syscalls superseded by statx

Various stat system calls can now be implemented as userland wrappers
around the new statx system call, so allow them to be removed from the
kernel by default for new architectures / ABIs.

This involves adding __ARCH_WANT_SYSCALL_UNXSTAT to each existing
architecture, which enables the relevant stat system calls in the
generic system call list (if used). It also conditionally defines the
syscalls in fs/stat.c and struct stat / struct stat64 in
asm-generic/stat.h.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/alpha/include/asm/unistd.h          | 1 +
 arch/arc/include/uapi/asm/unistd.h       | 1 +
 arch/arm/include/asm/unistd.h            | 1 +
 arch/arm64/include/uapi/asm/unistd.h     | 1 +
 arch/blackfin/include/asm/unistd.h       | 1 +
 arch/c6x/include/uapi/asm/unistd.h       | 1 +
 arch/cris/include/asm/unistd.h           | 1 +
 arch/frv/include/asm/unistd.h            | 1 +
 arch/h8300/include/uapi/asm/unistd.h     | 1 +
 arch/hexagon/include/uapi/asm/unistd.h   | 1 +
 arch/ia64/include/asm/unistd.h           | 2 ++
 arch/m32r/include/asm/unistd.h           | 1 +
 arch/m68k/include/asm/unistd.h           | 1 +
 arch/metag/include/uapi/asm/unistd.h     | 1 +
 arch/microblaze/include/asm/unistd.h     | 1 +
 arch/mips/include/asm/unistd.h           | 1 +
 arch/mn10300/include/asm/unistd.h        | 1 +
 arch/nios2/include/uapi/asm/unistd.h     | 1 +
 arch/openrisc/include/uapi/asm/unistd.h  | 1 +
 arch/parisc/include/asm/unistd.h         | 1 +
 arch/powerpc/include/asm/unistd.h        | 1 +
 arch/s390/include/asm/unistd.h           | 1 +
 arch/score/include/uapi/asm/unistd.h     | 1 +
 arch/sh/include/asm/unistd.h             | 1 +
 arch/sparc/include/asm/unistd.h          | 1 +
 arch/tile/include/uapi/asm/unistd.h      | 1 +
 arch/unicore32/include/uapi/asm/unistd.h | 1 +
 arch/x86/include/asm/unistd.h            | 2 ++
 arch/xtensa/include/asm/unistd.h         | 1 +
 fs/stat.c                                | 4 ++++
 include/asm-generic/unistd.h             | 2 ++
 include/uapi/asm-generic/stat.h          | 7 +++++++
 include/uapi/asm-generic/unistd.h        | 6 ++++++
 scripts/checksyscalls.sh                 | 9 +++++++++
 34 files changed, 59 insertions(+)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unist=
d.h
index a56e608db2f9..5ad9d35b1bfb 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -7,6 +7,7 @@
=20
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_FADVISE64
 #define __ARCH_WANT_SYS_GETPGRP
diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm=
/unistd.h
index ac6496527ad6..e68bdb8c6f58 100644
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -17,6 +17,7 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 076090d2dbf5..68bc0b5e58a4 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -17,6 +17,7 @@
 #include <asm/unistd-nr.h>
=20
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_GETPGRP
diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi=
/asm/unistd.h
index 48355a683e25..d066041b53e7 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -16,5 +16,6 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
=20
 #include <asm-generic/unistd.h>
diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm=
/unistd.h
index c8c8ff9eff61..eb0e20e02006 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -9,6 +9,7 @@
 #include <uapi/asm/unistd.h>
=20
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/c6x/include/uapi/asm/unistd.h b/arch/c6x/include/uapi/asm=
/unistd.h
index f67623137853..6e38fa29637c 100644
--- a/arch/c6x/include/uapi/asm/unistd.h
+++ b/arch/c6x/include/uapi/asm/unistd.h
@@ -16,6 +16,7 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_CLONE
=20
 /* Use the standard ABI for syscalls. */
diff --git a/arch/cris/include/asm/unistd.h b/arch/cris/include/asm/unistd.h
index 9c23535821c0..84e6a0cac8a7 100644
--- a/arch/cris/include/asm/unistd.h
+++ b/arch/cris/include/asm/unistd.h
@@ -11,6 +11,7 @@
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index 17b5df8fc28a..4023d0a9f7a4 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -9,6 +9,7 @@
 /* #define __ARCH_WANT_OLD_READDIR */
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 /* #define __ARCH_WANT_SYS_GETHOSTNAME */
 #define __ARCH_WANT_SYS_IPC
diff --git a/arch/h8300/include/uapi/asm/unistd.h b/arch/h8300/include/uapi=
/asm/unistd.h
index 2f98394b77d4..8109fb2856b3 100644
--- a/arch/h8300/include/uapi/asm/unistd.h
+++ b/arch/h8300/include/uapi/asm/unistd.h
@@ -2,5 +2,6 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
=20
 #include <asm-generic/unistd.h>
diff --git a/arch/hexagon/include/uapi/asm/unistd.h b/arch/hexagon/include/=
uapi/asm/unistd.h
index 52d585c5cdb2..a45f8f9a9544 100644
--- a/arch/hexagon/include/uapi/asm/unistd.h
+++ b/arch/hexagon/include/uapi/asm/unistd.h
@@ -29,6 +29,7 @@
 #define sys_mmap2 sys_mmap_pgoff
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 8c85209753ab..c1cfe1c98e6c 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -13,6 +13,8 @@
=20
 #define NR_syscalls			326 /* length of syscall table */
=20
+#define __ARCH_WANT_SYSCALL_UNXSTAT
+
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining ab=
out
  * unimplemented system calls.  Glibc provides for each of these by using
diff --git a/arch/m32r/include/asm/unistd.h b/arch/m32r/include/asm/unistd.h
index 59db80193454..adde7a9b9e8b 100644
--- a/arch/m32r/include/asm/unistd.h
+++ b/arch/m32r/include/asm/unistd.h
@@ -7,6 +7,7 @@
 #define NR_syscalls 326
=20
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index aab1edd0d4ba..0d9dee1f8e38 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -9,6 +9,7 @@
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
diff --git a/arch/metag/include/uapi/asm/unistd.h b/arch/metag/include/uapi=
/asm/unistd.h
index 16b5cb32ec21..11f5267da973 100644
--- a/arch/metag/include/uapi/asm/unistd.h
+++ b/arch/metag/include/uapi/asm/unistd.h
@@ -9,6 +9,7 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
=20
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include=
/asm/unistd.h
index 032fed71223f..183caf9398fd 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -16,6 +16,7 @@
 /* #define __ARCH_WANT_OLD_READDIR */
 /* #define __ARCH_WANT_OLD_STAT */
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index 11fa291ec25a..6cc6206b501b 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -30,6 +30,7 @@
 #ifndef __ASSEMBLY__
=20
 #define __ARCH_WANT_OLD_READDIR
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
diff --git a/arch/mn10300/include/asm/unistd.h b/arch/mn10300/include/asm/u=
nistd.h
index 0522468f488b..0e0c645b85b9 100644
--- a/arch/mn10300/include/asm/unistd.h
+++ b/arch/mn10300/include/asm/unistd.h
@@ -22,6 +22,7 @@
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
diff --git a/arch/nios2/include/uapi/asm/unistd.h b/arch/nios2/include/uapi=
/asm/unistd.h
index b0dda4de2bc7..803241364fa1 100644
--- a/arch/nios2/include/uapi/asm/unistd.h
+++ b/arch/nios2/include/uapi/asm/unistd.h
@@ -19,6 +19,7 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
=20
 /* Use the standard ABI for syscalls */
 #include <asm-generic/unistd.h>
diff --git a/arch/openrisc/include/uapi/asm/unistd.h b/arch/openrisc/includ=
e/uapi/asm/unistd.h
index 6812d81b3c6c..ae91c8ef72dd 100644
--- a/arch/openrisc/include/uapi/asm/unistd.h
+++ b/arch/openrisc/include/uapi/asm/unistd.h
@@ -22,6 +22,7 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_CLONE
=20
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/uni=
std.h
index 5f4c68daa261..8299302eee31 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -142,6 +142,7 @@ type name(type1 arg1, type2 arg2, type3 arg3, type4 arg=
4, type5 arg5)	\
=20
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/u=
nistd.h
index 9ba11dbcaca9..8fb678b94f3f 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -28,6 +28,7 @@
=20
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 3066031a73fe..5e260f0b41ec 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -14,6 +14,7 @@
 #define __IGNORE_pkey_free
=20
 #define __ARCH_WANT_OLD_READDIR
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/score/include/uapi/asm/unistd.h b/arch/score/include/uapi=
/asm/unistd.h
index 7ad1bdcb8615..0532e4e7ee75 100644
--- a/arch/score/include/uapi/asm/unistd.h
+++ b/arch/score/include/uapi/asm/unistd.h
@@ -6,6 +6,7 @@
 #define __ARCH_WANT_SYSCALL_NO_FLAGS
 #define __ARCH_WANT_SYSCALL_OFF_T
 #define __ARCH_WANT_SYSCALL_DEPRECATED
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/sh/include/asm/unistd.h b/arch/sh/include/asm/unistd.h
index 126fe8340b22..e44c78720f37 100644
--- a/arch/sh/include/asm/unistd.h
+++ b/arch/sh/include/asm/unistd.h
@@ -7,6 +7,7 @@
 # define __ARCH_WANT_OLD_READDIR
 # define __ARCH_WANT_OLD_STAT
 # define __ARCH_WANT_STAT64
+# define __ARCH_WANT_SYSCALL_UNXSTAT
 # define __ARCH_WANT_SYS_ALARM
 # define __ARCH_WANT_SYS_GETHOSTNAME
 # define __ARCH_WANT_SYS_IPC
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unist=
d.h
index 0aac1e8f2968..23e28bd8e0b4 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -22,6 +22,7 @@
 #endif
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/tile/include/uapi/asm/unistd.h b/arch/tile/include/uapi/a=
sm/unistd.h
index cf0505fe4b9c..210747e7aa5b 100644
--- a/arch/tile/include/uapi/asm/unistd.h
+++ b/arch/tile/include/uapi/asm/unistd.h
@@ -18,6 +18,7 @@
 /* Use the flavor of this syscall that matches the 32-bit API better. */
 #define __ARCH_WANT_SYNC_FILE_RANGE2
 #endif
+#define __ARCH_WANT_SYSCALL_UNXSTAT
=20
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
diff --git a/arch/unicore32/include/uapi/asm/unistd.h b/arch/unicore32/incl=
ude/uapi/asm/unistd.h
index ef25aec1d440..00b869fe907f 100644
--- a/arch/unicore32/include/uapi/asm/unistd.h
+++ b/arch/unicore32/include/uapi/asm/unistd.h
@@ -12,6 +12,7 @@
=20
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_SYSCALL_UNXSTAT
=20
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 1ba1536f627e..fa06083f723c 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -10,6 +10,8 @@
 #  define __SYSCALL_MASK (~0)
 # endif
=20
+#define __ARCH_WANT_SYSCALL_UNXSTAT
+
 # ifdef CONFIG_X86_32
=20
 #  include <asm/unistd_32.h>
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/uni=
std.h
index cb4c2ce8d447..4440601477ba 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -5,6 +5,7 @@
 #include <uapi/asm/unistd.h>
=20
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_GETPGRP
diff --git a/fs/stat.c b/fs/stat.c
index f494b182c7c7..f3c7292cf138 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -292,6 +292,8 @@ SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_k=
ernel_stat __user *, stat
 #  define INIT_STRUCT_STAT_PADDING(st) memset(&st, 0, sizeof(st))
 #endif
=20
+#ifdef __ARCH_WANT_SYSCALL_UNXSTAT
+
 static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 {
 	struct stat tmp;
@@ -378,6 +380,8 @@ SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat=
 __user *, statbuf)
 	return error;
 }
=20
+#endif /* __ARCH_WANT_SYSCALL_UNXSTAT */
+
 SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
 		char __user *, buf, int, bufsiz)
 {
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index cccc86ecfeaa..5ea721d393db 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -7,6 +7,8 @@
  * be selected by default.
  */
 #if __BITS_PER_LONG =3D=3D 32
+#ifdef __ARCH_WANT_SYSCALL_UNXSTAT
 #define __ARCH_WANT_STAT64
+#endif
 #define __ARCH_WANT_SYS_LLSEEK
 #endif
diff --git a/include/uapi/asm-generic/stat.h b/include/uapi/asm-generic/sta=
t.h
index bd8cad21998e..bcf335581980 100644
--- a/include/uapi/asm-generic/stat.h
+++ b/include/uapi/asm-generic/stat.h
@@ -1,6 +1,11 @@
 #ifndef __ASM_GENERIC_STAT_H
 #define __ASM_GENERIC_STAT_H
=20
+#include <asm/unistd.h>
+
+/* statx deprecates the un-extended stat syscalls which use struct stat[64=
] */
+#ifdef __ARCH_WANT_SYSCALL_UNXSTAT
+
 /*
  * Everybody gets this wrong and has to stick with it for all
  * eternity. Hopefully, this version gets used by new architectures
@@ -69,4 +74,6 @@ struct stat64 {
 };
 #endif
=20
+#endif /* __ARCH_WANT_SYSCALL_UNXSTAT */
+
 #endif /* __ASM_GENERIC_STAT_H */
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/u=
nistd.h
index ffc30294103b..d6291b38092e 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -241,10 +241,12 @@ __SYSCALL(__NR_tee, sys_tee)
 /* fs/stat.c */
 #define __NR_readlinkat 78
 __SYSCALL(__NR_readlinkat, sys_readlinkat)
+#ifdef __ARCH_WANT_SYSCALL_UNXSTAT
 #define __NR3264_fstatat 79
 __SC_3264(__NR3264_fstatat, sys_fstatat64, sys_newfstatat)
 #define __NR3264_fstat 80
 __SC_3264(__NR3264_fstat, sys_fstat64, sys_newfstat)
+#endif /* __ARCH_WANT_SYSCALL_UNXSTAT */
=20
 /* fs/sync.c */
 #define __NR_sync 81
@@ -925,8 +927,10 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
 #define __NR_ftruncate __NR3264_ftruncate
 #define __NR_lseek __NR3264_lseek
 #define __NR_sendfile __NR3264_sendfile
+#ifdef __NR3264_fstat
 #define __NR_newfstatat __NR3264_fstatat
 #define __NR_fstat __NR3264_fstat
+#endif
 #define __NR_mmap __NR3264_mmap
 #define __NR_fadvise64 __NR3264_fadvise64
 #ifdef __NR3264_stat
@@ -941,8 +945,10 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
 #define __NR_ftruncate64 __NR3264_ftruncate
 #define __NR_llseek __NR3264_lseek
 #define __NR_sendfile64 __NR3264_sendfile
+#ifdef __NR3264_fstat
 #define __NR_fstatat64 __NR3264_fstatat
 #define __NR_fstat64 __NR3264_fstat
+#endif
 #define __NR_mmap2 __NR3264_mmap
 #define __NR_fadvise64_64 __NR3264_fadvise64
 #ifdef __NR3264_stat
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index a5a0a341aa17..ef14cab988a9 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -37,6 +37,15 @@ cat << EOF
 #define __IGNORE_lstat64	/* fstatat64 */
 #endif
=20
+/* statx */
+#if BITS_PER_LONG =3D=3D 64
+#define __IGNORE_newfstatat	/* statx */
+#define __IGNORE_newfstat	/* statx */
+#else
+#define __IGNORE_fstatat64	/* statx */
+#define __IGNORE_fstat64	/* statx */
+#endif
+
 /* Missing flags argument */
 #define __IGNORE_renameat	/* renameat2 */
=20
--=20
2.13.1



--VAJERZhbIWAQ3W3F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAllIRT4ACgkQbAtpk944
dnoAFA//UvIoqXy1+j3Uu9mblw72IyR3tMcW78B7CwaQO3EpeIR595eJLLApUDY4
OaGtmgblEL/a7MPDY0eOrukeKWSj1eLpyOcER+pa+5aoT5CAtA7GCgBFaN4S1PPZ
9/uweu6JJVVTl+ujxUFMcqcrt4pysXI3dszDm/3EWnBJ+0ceyR3fzlkQTCHAIpL6
v6tPEFShcl0fl0sW/IJkTXQ2H0F2yCTxv6bdzfalCEnePqXnYeO0ZaLYBRg2KOQH
WRg6gFGhvzfKHTkV03Isvztchiip/kbVKm6UtA1djypfsQQ0lVK2477OBsRzVRP/
EPz/mb5uRGnKAZQwkXwbG6MxPcVZRGqTq4J7CukegsdYZ5rHS/DUBmoxMRfekuyb
m9AskLIXs0KCFKiirvzMj8tX12yQZYzIjDHbEFzNH6vCO1tCJcRnhzIEym5uaD/g
Uq/zWB2ok+kcvtUieMkevZY1369mokZpnNPeGaCY7PooSsXd8iUxkzG/4FIN9gDz
RAiGzPTEuJrybHVJDu0LOlYCi+lRPpID2XUqoHOGf5GfA/MbhmtCMU4uMwd9Kpfq
tXbARgJcF4oP8CtpQQvJR6USO7fIJVpUZBAj0OoeF/NEoB5rQxk0SnpKC/pEXnNz
UT5r5T89w9dkqD24gFdZfQBr6BMfUqBGtsSAmBM9XIPUgJgschY=
=deyt
-----END PGP SIGNATURE-----

--VAJERZhbIWAQ3W3F--


--===============4657337216978541920==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-snps-arc mailing list
linux-snps-arc@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-snps-arc
--===============4657337216978541920==--
