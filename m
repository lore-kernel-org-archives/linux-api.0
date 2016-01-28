From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 01/10] selftests/x86: Extend Makefile to allow 64-bit-only tests
Date: Thu, 28 Jan 2016 15:11:19 -0800
Message-ID: <99789bfe65706e6df32cc7e13f656e8c9fa92031.1454022279.git.luto@kernel.org>
References: <cover.1454022279.git.luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454022279.git.luto@kernel.org>
In-Reply-To: <cover.1454022279.git.luto@kernel.org>
References: <cover.1454022279.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Shuah Khan <shuahkhan@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Previously the Makefile supported 32-bit-only tests and tests that
were 32-bit and 64-bit.  This adds the support for tests that are
only built as 64-bit binaries.

There aren't any yet, but there might be a few some day.

Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-api@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 tools/testing/selftests/x86/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index d0c473f65850..9c81f263a396 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -11,8 +11,9 @@ TARGETS_C_32BIT_ONLY := entry_from_vm86 syscall_arg_fault sigreturn test_syscall
 			vdso_restorer
 
 TARGETS_C_32BIT_ALL := $(TARGETS_C_BOTHBITS) $(TARGETS_C_32BIT_ONLY)
+TARGETS_C_64BIT_ALL := $(TARGETS_C_BOTHBITS) $(TARGETS_C_64BIT_ONLY)
 BINARIES_32 := $(TARGETS_C_32BIT_ALL:%=%_32)
-BINARIES_64 := $(TARGETS_C_BOTHBITS:%=%_64)
+BINARIES_64 := $(TARGETS_C_64BIT_ALL:%=%_64)
 
 CFLAGS := -O2 -g -std=gnu99 -pthread -Wall
 
@@ -40,7 +41,7 @@ clean:
 $(TARGETS_C_32BIT_ALL:%=%_32): %_32: %.c
 	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
 
-$(TARGETS_C_BOTHBITS:%=%_64): %_64: %.c
+$(TARGETS_C_64BIT_ALL:%=%_64): %_64: %.c
 	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
 
 # x86_64 users should be encouraged to install 32-bit libraries
-- 
2.5.0
