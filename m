From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Wed, 22 Mar 2017 13:52:02 +0100
Message-ID: <CAFy1USQ=HBsp9AmGJ3=i8mjxmAN7aNTyZkbWpag3ogKZFUrPSw@mail.gmail.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
 <20161129115552.8148-7-bamvor.zhangjian@huawei.com> <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA@mail.gmail.com>
 <87fui7owls.fsf@concordia.ellerman.id.au> <CAFy1USRoKJ7G9ewLGBa1yy9V5UA+g=jo7O+eU1wV_rjKDYtJWg@mail.gmail.com>
 <87d1d9czi4.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87d1d9czi4.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi, Michael, Shuah

On 22 March 2017 at 12:38, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>> On 21 March 2017 at 16:35, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
>>> I see at least 18 Makefile's in tools/testing/selftests that use
>>> $(OUTPUT)/, which would all need to be updated at least to use $(OUTPUT)
>>> (no trailing slash), and then some other changes to not propagate OUTPUT
>>> when the user didn't specify it. But hopefully someone will prove me
>>> wrong.
>> I also look at this issue. Originally, I use OUTPUT without slash in my
>> patch. People argue that it is not very clear. So, I add slash in curent
>> version.
>
> That was me, you can say so.
>
> I wasn't thinking at the time of OUTPUT being empty, but with hindsight
> obviously I should have.
After think about it. I find a way to keep OUTPUT with out slash. Could
you please take a look?

I have already test the x86 with the following method:
make -C tools/testing/selftests TAREGTS=x86
make -C tools/testing/selftests/x86
make -C tools/testing/selftests/x86 xxx

The build flag and dependency is correct.
Build all the testcase succesful. I am running the test and try difference build
method. Hope I could solve the regression soon.

Regards

Bamvor

>From ae092145868def26665b588d718d1a7ab28b5c15 Mon Sep 17 00:00:00 2001
From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Date: Wed, 22 Mar 2017 20:34:25 +0800
Subject: [PATCH] selftests: fix the broken individual test for x86

Andy Lutomirski report that build individual testcase in x86 is broken:

$ make -C tools/testing/selftests/x86 ldt_gdt_32
make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
Makefile:44: warning: overriding recipe for target 'clean'
../lib.mk:55: warning: ignoring old recipe for target 'clean'
make: *** No rule to make target 'ldt_gdt_32'.  Stop.
make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'

This patch fix this issue by adding default OUTPUT and convert
target in Makefile of x86.

And also mention this use case in Documentation/kselftests.txt

Reported-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/kselftest.txt          |  6 ++++++
 tools/testing/selftests/lib.mk       |  2 +-
 tools/testing/selftests/x86/Makefile | 23 ++++++++++++++---------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/Documentation/kselftest.txt b/Documentation/kselftest.txt
index 5bd5903..3dfca71 100644
--- a/Documentation/kselftest.txt
+++ b/Documentation/kselftest.txt
@@ -43,6 +43,12 @@ See the top-level tools/testing/selftests/Makefile
for the list of all
 possible targets.


+Building individual test case of a subset
+=========================================
+You could build the individual test case in subset if subset supported:
+  $  make -C tools/testing/selftests/x86 ldt_gdt_32
+
+
 Running the full range hotplug selftests
 ========================================

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 069a1c9..df2fbfb 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -2,7 +2,7 @@
 # Makefile can operate with or without the kbuild infrastructure.
 CC := $(CROSS_COMPILE)gcc

-OUTPUT ?= $(shell pwd)/
+OUTPUT ?= $(shell pwd)

 TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
 TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
diff --git a/tools/testing/selftests/x86/Makefile
b/tools/testing/selftests/x86/Makefile
index 3a5ebae..f8ea3bb 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -17,8 +17,8 @@ TARGETS_C_64BIT_ALL := $(TARGETS_C_BOTHBITS)
$(TARGETS_C_64BIT_ONLY)
 BINARIES_32 := $(TARGETS_C_32BIT_ALL:%=%_32)
 BINARIES_64 := $(TARGETS_C_64BIT_ALL:%=%_64)

-BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
-BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
+BINARIES_32_FULL_PATH := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
+BINARIES_64_FULL_PATH := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))

 CFLAGS := -O2 -g -std=gnu99 -pthread -Wall

@@ -28,25 +28,29 @@ CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC)
trivial_64bit_program.c)

 ifeq ($(CAN_BUILD_I386),1)
 all: all_32
-TEST_PROGS += $(BINARIES_32)
+TEST_PROGS += $(BINARIES_32_FULL_PATH)
 endif

 ifeq ($(CAN_BUILD_X86_64),1)
 all: all_64
-TEST_PROGS += $(BINARIES_64)
+TEST_PROGS += $(BINARIES_64_FULL_PATH)
 endif

-all_32: $(BINARIES_32)
+all_32: $(BINARIES_32_FULL_PATH)

-all_64: $(BINARIES_64)
+all_64: $(BINARIES_64_FULL_PATH)

 clean:
- $(RM) $(BINARIES_32) $(BINARIES_64)
+ $(RM) $(BINARIES_32_FULL_PATH) $(BINARIES_64_FULL_PATH)

-$(BINARIES_32): $(OUTPUT)/%_32: %.c
+$(BINARIES_32): %_32: $(OUTPUT)/%_32
+
+$(BINARIES_64): %_64: $(OUTPUT)/%_64
+
+$(BINARIES_32_FULL_PATH): $(OUTPUT)/%_32: %.c
  $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm

-$(BINARIES_64): $(OUTPUT)/%_64: %.c
+$(BINARIES_64_FULL_PATH): $(OUTPUT)/%_64: %.c
  $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl

 # x86_64 users should be encouraged to install 32-bit libraries
@@ -77,3 +81,4 @@ $(OUTPUT)/test_syscall_vdso_32: thunks_32.S
 # state.
 $(OUTPUT)/check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
 $(OUTPUT)/check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
+
-- 
1.9.1

> cheers
