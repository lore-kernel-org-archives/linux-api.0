From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC PATCH] selftests: use INSTALL_HDR_PATH instead of relative
 paths
Date: Thu, 14 Jan 2016 14:37:20 +1100
Message-ID: <1452742640.25808.1.camel@ellerman.id.au>
References: <1452522172-16650-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452522172-16650-1-git-send-email-sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2016-01-11 at 14:22 +0000, Sudeep Holla wrote:

> The selftests build fails or picks up wrong headers when cross-compiling
> and build directory is different from source as the headers are referred
> using the relative paths.
> 
> This patch use $INSTALL_HDR_PATH to fix the compilation. It also removes
> installing the headers.
> 
> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> Signed-off-by: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
> ---
>  tools/testing/selftests/membarrier/Makefile | 2 +-
>  tools/testing/selftests/memfd/Makefile      | 2 +-
>  tools/testing/selftests/net/Makefile        | 2 +-
>  tools/testing/selftests/vm/Makefile         | 7 ++-----
>  4 files changed, 5 insertions(+), 8 deletions(-)
> 
> Hi,
> 
> When I was cross-compiling these tests for arm{32,64}, I faced issues.
> With limited knowledge I have on this build system, I came up with this
> patch. Please treat this as bug report if this approach makes no-sense
> and suggest on how to fix it.

Yeah sorry that doesn't work.

If $(INSTALL_HDR_PATH) isn't defined you end up with:

  gcc -Wall -I /include  -o compaction_test compaction_test.c -lrt
               ^

Which is wrong.

INSTALL_HDR_PATH will not be defined when the tests are built standalone, ie.
like:

  $ make -C tools/testing/selftests


This has been on my todo list to fix, but it doesn't actually bother me so I
haven't got around to it.

Does the patch below work for you? It uses INSTALL_HDR_PATH if it is defined,
or otherwise KERNEL_HEADERS if it is defined, or finally it guesses at
../../../usr/include (ie. the base of the source tree).

cheers


diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index b04afc3295df..78e293829779 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -44,6 +44,13 @@ override LDFLAGS =
 override MAKEFLAGS =
 endif
 
+ifneq ($(INSTALL_HDR_PATH),)
+KERNEL_HEADERS := $(INSTALL_HDR_PATH)/include
+else
+KERNEL_HEADERS ?= $(abspath ../../../usr/include)
+endif
+export KERNEL_HEADERS
+
 all:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET; \
diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 25d2e702c68a..67f5da755a69 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -9,7 +9,7 @@ ifeq ($(ARCH),x86_64)
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I $(KERNEL_HEADERS)
 
 all:
 	$(CC) $(CFLAGS) msgque.c -o msgque_test
diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 2ae7450a9a89..64455a77b7bc 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,4 +1,4 @@
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I $(KERNEL_HEADERS)
 
 all: kcmp_test
 
diff --git a/tools/testing/selftests/membarrier/Makefile b/tools/testing/selftests/membarrier/Makefile
index a1a97085847d..155e92d297d6 100644
--- a/tools/testing/selftests/membarrier/Makefile
+++ b/tools/testing/selftests/membarrier/Makefile
@@ -1,4 +1,4 @@
-CFLAGS += -g -I../../../../usr/include/
+CFLAGS += -g -I $(KERNEL_HEADERS)
 
 TEST_PROGS := membarrier_test
 
diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index fd396ac811b6..e193537110ff 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -1,8 +1,6 @@
 CC = $(CROSS_COMPILE)gcc
 CFLAGS += -D_FILE_OFFSET_BITS=64
-CFLAGS += -I../../../../include/uapi/
-CFLAGS += -I../../../../include/
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I$(KERNEL_HEADERS)
 
 TEST_PROGS := memfd_test
 
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 41449b5ad0a9..dfe3c8935082 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -2,7 +2,7 @@
 
 CFLAGS = -Wall -O2 -g
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I$(KERNEL_HEADERS)
 
 NET_PROGS = socket psock_fanout psock_tpacket reuseport_bpf
 
diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
index b35c7945bec5..5ea163b2cc91 100644
--- a/tools/testing/selftests/powerpc/syscalls/Makefile
+++ b/tools/testing/selftests/powerpc/syscalls/Makefile
@@ -1,6 +1,6 @@
 TEST_PROGS := ipc_unmuxed
 
-CFLAGS += -I../../../../../usr/include
+CFLAGS += -I $(KERNEL_HEADERS)
 
 all: $(TEST_PROGS)
 
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index 737f72c964e6..bb6cb5d4fc2d 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -5,7 +5,7 @@ all: $(TEST_PROGS)
 $(TEST_PROGS): ../harness.c ../utils.c
 
 tm-syscall: tm-syscall-asm.S
-tm-syscall: CFLAGS += -mhtm -I../../../../../usr/include
+tm-syscall: CFLAGS += -mhtm -I $(KERNEL_HEADERS)
 
 include ../../lib.mk
 
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index e4bb1de1d526..4f45b9c8dd75 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,6 @@
 # Makefile for vm selftests
 
-CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
+CFLAGS = -Wall -I $(KERNEL_HEADERS) $(EXTRA_CFLAGS)
 BINARIES = compaction_test
 BINARIES += hugepage-mmap
 BINARIES += hugepage-shm
@@ -14,12 +14,9 @@ BINARIES += userfaultfd
 all: $(BINARIES)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^ -lrt
-userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
+userfaultfd: userfaultfd.c $(KERNEL_HEADERS)/linux/kernel.h
 	$(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
 
-../../../../usr/include/linux/kernel.h:
-	make -C ../../../.. headers_install
-
 TEST_PROGS := run_vmtests
 TEST_FILES := $(BINARIES)
 
