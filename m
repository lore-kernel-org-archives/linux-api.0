From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5/5] selftests/powerpc: Fix remaining fallout from recent
 changes
Date: Thu,  9 Feb 2017 19:56:30 +1100
Message-ID: <1486630590-9410-5-git-send-email-mpe@ellerman.id.au>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: shuahkh@osg.samsung.com, bamvor.zhangjian@huawei.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

In benchmarks we need to use $(TEST_GEN_PROGS) after we include lib.mk,
because lib.mk does the substitution to add $(OUTPUT).

In math the vmx and fpu names were typoed so they no longer matched
correctly, put back the 'v' and 'f'.

In tm we need to substitute $(OUTPUT) into SIGNAL_CONTEXT_CHK_TESTS so
that the rule matches.

In pmu there is an extraneous ':' on the end of $$BUILD_TARGET for the
clean and install rules, which breaks the logic in the child Makefiles.

Fixes: a8ba798bc8ec ("selftests: enable O and KBUILD_OUTPUT")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/powerpc/benchmarks/Makefile |  4 ++--
 tools/testing/selftests/powerpc/math/Makefile       | 16 ++++++++--------
 tools/testing/selftests/powerpc/pmu/Makefile        |  4 ++--
 tools/testing/selftests/powerpc/tm/Makefile         |  1 +
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/powerpc/benchmarks/Makefile b/tools/testing/selftests/powerpc/benchmarks/Makefile
index 286c6ed2378c..fb96a89bd953 100644
--- a/tools/testing/selftests/powerpc/benchmarks/Makefile
+++ b/tools/testing/selftests/powerpc/benchmarks/Makefile
@@ -2,10 +2,10 @@ TEST_GEN_PROGS := gettimeofday context_switch mmap_bench futex_bench null_syscal
 
 CFLAGS += -O2
 
-$(TEST_GEN_PROGS): ../harness.c
-
 include ../../lib.mk
 
+$(TEST_GEN_PROGS): ../harness.c
+
 $(OUTPUT)/context_switch: ../utils.c
 $(OUTPUT)/context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
 $(OUTPUT)/context_switch: LDLIBS += -lpthread
diff --git a/tools/testing/selftests/powerpc/math/Makefile b/tools/testing/selftests/powerpc/math/Makefile
index da9f42feaaac..fa8bae920c91 100644
--- a/tools/testing/selftests/powerpc/math/Makefile
+++ b/tools/testing/selftests/powerpc/math/Makefile
@@ -5,13 +5,13 @@ include ../../lib.mk
 $(TEST_GEN_PROGS): ../harness.c
 $(TEST_GEN_PROGS): CFLAGS += -O2 -g -pthread -m64 -maltivec
 
-$(OUTPUT)/pu_syscall: fpu_asm.S
-$(OUTPUT)/pu_preempt: fpu_asm.S
-$(OUTPUT)/pu_signal:  fpu_asm.S
+$(OUTPUT)/fpu_syscall: fpu_asm.S
+$(OUTPUT)/fpu_preempt: fpu_asm.S
+$(OUTPUT)/fpu_signal:  fpu_asm.S
 
-$(OUTPUT)/mx_syscall: vmx_asm.S
-$(OUTPUT)/mx_preempt: vmx_asm.S
-$(OUTPUT)/mx_signal: vmx_asm.S
+$(OUTPUT)/vmx_syscall: vmx_asm.S
+$(OUTPUT)/vmx_preempt: vmx_asm.S
+$(OUTPUT)/vmx_signal: vmx_asm.S
 
-vsx_preempt: CFLAGS += -mvsx
-vsx_preempt: vsx_asm.S
+$(OUTPUT)/vsx_preempt: CFLAGS += -mvsx
+$(OUTPUT)/vsx_preempt: vsx_asm.S
diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
index 097b08acd867..e4e55d1d3e0f 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -31,12 +31,12 @@ endef
 DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
 override define INSTALL_RULE
 	$(DEFAULT_INSTALL_RULE)
-	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET: -C $$TARGET install
+	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
 endef
 
 clean:
 	$(RM) $(TEST_GEN_PROGS) $(OUTPUT)/loop.o
-	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET: -C $$TARGET clean
+	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
 
 ebb:
 	TARGET=$@; BUILD_TARGET=$$OUTPUT/$$TARGET; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -k -C $$TARGET all
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index 07da21769ff8..5576ee6a51f2 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -14,5 +14,6 @@ $(OUTPUT)/tm-syscall: tm-syscall-asm.S
 $(OUTPUT)/tm-syscall: CFLAGS += -I../../../../../usr/include
 $(OUTPUT)/tm-tmspr: CFLAGS += -pthread
 
+SIGNAL_CONTEXT_CHK_TESTS := $(patsubst %,$(OUTPUT)/%,$(SIGNAL_CONTEXT_CHK_TESTS))
 $(SIGNAL_CONTEXT_CHK_TESTS): tm-signal.S
 $(SIGNAL_CONTEXT_CHK_TESTS): CFLAGS += -mhtm -m64 -mvsx
-- 
2.7.4
