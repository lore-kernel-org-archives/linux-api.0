From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/11] UAPI: Check headers build for C++ [ver #2]
Date: Thu, 06 Sep 2018 10:19:37 +0100
Message-ID: <153622557736.14298.10350496216090814292.stgit@warthog.procyon.org.uk>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

Check that all the headers can be included from one file and built for C++,
thereby catching the use of C++ reserved words and bits of unimplemented
C++ in the UAPI headers.

Note that certain headers are excluded from the build, including:

 (1) Any header ending in "_32.h", "_64.h" or "_x32.h" as these are
     expected to be multiarch variant headers.

 (2) Endianness variant headers.

 (3) asm-generic/ headers (they're used conditionally by the asm/ headers
     and shouldn't be used directly).

 (4) netfilter_ipv*/ip*t_LOG.h headers.  They emit a warning indicating
     they're going to be removed soon.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Masahiro Yamada <yamada.masahiro@socionext.com>
cc: Michal Marek <michal.lkml@markovi.net>
cc: linux-kbuild@vger.kernel.org
---

 Makefile               |    1 
 scripts/headers-c++.sh |  124 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)
 create mode 100755 scripts/headers-c++.sh

diff --git a/Makefile b/Makefile
index 19948e556941..38d655cb4474 100644
--- a/Makefile
+++ b/Makefile
@@ -1186,6 +1186,7 @@ headers_install: __headers
 	  $(error Headers not exportable for the $(SRCARCH) architecture))
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi dst=include
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(SRCARCH)/include/uapi $(hdr-dst)
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/headers-c++.sh check
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
diff --git a/scripts/headers-c++.sh b/scripts/headers-c++.sh
new file mode 100755
index 000000000000..7e56913629f8
--- /dev/null
+++ b/scripts/headers-c++.sh
@@ -0,0 +1,124 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Run headers_$1 command for all suitable architectures
+
+# Stop on error
+set -e
+
+if ! $CC -x c++ -c - -o /dev/null </dev/null 2>/dev/null
+then
+    echo "  CHECK   C++ HEADER COMPILATION [SKIPPED]"
+    exit 0
+fi
+
+echo "  CHECK   C++ HEADER COMPILATION"
+
+mkdir -p hdr-check
+cd hdr-check
+
+mkdir -p include/sys
+mkdir -p include/arpa
+mkdir -p include/xen/interface
+echo >include/endian.h
+echo >include/limits.h
+echo >include/stdint.h
+echo >include/stdlib.h
+echo >include/stdio.h
+echo >include/string.h
+echo >include/time.h
+echo >include/unistd.h
+echo >include/arpa/inet.h
+echo >include/sys/ioctl.h
+echo >include/sys/types.h
+echo >include/sys/time.h
+echo >include/sys/socket.h
+echo >include/xen/interface/xen.h
+
+cat >test.h <<EOF
+#ifdef __cplusplus
+#define NULL nullptr
+#define _Bool bool
+#else
+#define NULL ((void *)0)
+#define bool _Bool
+#endif
+#include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/time.h>
+
+typedef __s8			int8_t;
+typedef __s16			int16_t;
+typedef __s32			int32_t;
+typedef __s64			int64_t;
+typedef __u8			uint8_t;
+typedef __u16			uint16_t;
+typedef __u32			uint32_t;
+typedef __u64			uint64_t;
+typedef long int		intptr_t;
+typedef unsigned long int	uintptr_t;
+typedef unsigned short		u_short;
+typedef unsigned int		u_int;
+typedef unsigned long		u_long;
+typedef char			*caddr_t;
+
+typedef __kernel_clockid_t	clockid_t;
+typedef __kernel_ino_t		ino_t;
+typedef __kernel_pid_t		pid_t;
+typedef __kernel_sa_family_t	sa_family_t;
+typedef __kernel_size_t		size_t;
+typedef __kernel_uid_t		uid_t;
+
+typedef unsigned long		elf_greg_t;
+typedef elf_greg_t		elf_gregset_t[1];
+typedef unsigned long long	elf_fpregset_t[1];
+typedef unsigned long long	elf_fpxregset_t[1];
+
+#define INT_MIN ((int)0x80000000)
+#define INT_MAX ((int)0x7fffffff)
+
+extern size_t strlen(const char *);
+extern void *memset(void *, int, size_t);
+extern void *memcpy(void *, const void *, size_t);
+extern __u16 ntohs(__u16);
+extern __u16 htons(__u16);
+extern __u32 ntohl(__u32);
+extern __u32 htonl(__u32);
+
+typedef uint32_t		grant_ref_t;
+typedef uint16_t		domid_t;
+typedef unsigned long		xen_pfn_t;
+
+#define MSG_FIN         0x200
+
+typedef int SVGA3dMSPattern;
+typedef int SVGA3dMSQualityLevel;
+
+struct sockaddr
+{
+	sa_family_t	sa_family;
+	char		sa_data[14];
+};
+#define sockaddr_storage __kernel_sockaddr_storage
+
+#define _LINUX_PATCHKEY_H_INDIRECT
+
+EOF
+
+find ../usr/include -name '*.h' |
+    grep -v 'linux/byteorder/big_endian.h' |
+    grep -v 'linux/byteorder/little_endian.h' |
+    grep -v '_\(32\|64\|x32\)[.]h$' |
+    grep -v '/asm-generic/' |
+    # ip*t_LOG.h are deprecated
+    grep -v 'linux/netfilter_ipv4/ipt_LOG[.]h' |
+    grep -v 'linux/netfilter_ipv6/ip6t_LOG[.]h' |
+    sed -e 's!../usr/include/!#include <!' -e 's!$!>!' >>test.h
+
+echo '#include "test.h"' >test.cpp
+
+$CC -x c++ -o /dev/null -c test.cpp \
+    -nostdinc \
+    -isystem ./include \
+    -isystem ../usr/include \
+    -fpermissive \
+    -D PAGE_SIZE='#PAGE_SIZE_IS_NOT_VALID_OUTSIDE_OF_KERNEL'
