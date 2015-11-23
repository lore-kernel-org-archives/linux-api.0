From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [GIT PULL] Kselftest fixes for 4.4-rc3
Date: Mon, 23 Nov 2015 11:31:47 -0700
Message-ID: <56535B93.8070401@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Could you please pull the following update for 4.4-rc3.

thanks,
-- Shuah

----------------------------------------------------------------------
The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.4-rc3

for you to fetch changes up to 2ce47b44b25d8fb0114ff117813742adbefec8ff:

  selftests/seccomp: Get page size from sysconf (2015-11-18 16:56:53 -0700)

----------------------------------------------------------------
linux-kselftest-4.4-rc3

This update consists of one minor documentation fix and a fix
to an existing test.

----------------------------------------------------------------
Bamvor Jian Zhang (1):
      selftests/seccomp: Get page size from sysconf

Wei Jiangang (1):
      tools:testing/selftests: fix typo in futex/README

 tools/testing/selftests/futex/README          |  2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

--------------------------------------------------------------------------


diff --git a/tools/testing/selftests/futex/README
b/tools/testing/selftests/futex/README
index 3224a04..0558bb9 100644
--- a/tools/testing/selftests/futex/README
+++ b/tools/testing/selftests/futex/README
@@ -27,7 +27,7 @@ o The build system shall remain as simple as possible,
avoiding any archive or
 o Where possible, any helper functions or other package-wide code shall be
   implemented in header files, avoiding the need to compile
intermediate object
   files.
-o External dependendencies shall remain as minimal as possible.
Currently gcc
+o External dependencies shall remain as minimal as possible. Currently gcc
   and glibc are the only dependencies.
 o Tests return 0 for success and < 0 for failure.

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c
b/tools/testing/selftests/seccomp/seccomp_bpf.c
index e38cc54..882fe83 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -492,6 +492,9 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
        pid_t parent = getppid();
        int fd;
        void *map1, *map2;
+       int page_size = sysconf(_SC_PAGESIZE);
+
+       ASSERT_LT(0, page_size);

        ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
        ASSERT_EQ(0, ret);
@@ -504,16 +507,16 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)

        EXPECT_EQ(parent, syscall(__NR_getppid));
        map1 = (void *)syscall(sysno,
-               NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, PAGE_SIZE);
+               NULL, page_size, PROT_READ, MAP_PRIVATE, fd, page_size);
        EXPECT_NE(MAP_FAILED, map1);
        /* mmap2() should never return. */
        map2 = (void *)syscall(sysno,
-                NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0x0C0FFEE);
+                NULL, page_size, PROT_READ, MAP_PRIVATE, fd, 0x0C0FFEE);
        EXPECT_EQ(MAP_FAILED, map2);

        /* The test failed, so clean up the resources. */
-       munmap(map1, PAGE_SIZE);
-       munmap(map2, PAGE_SIZE);
+       munmap(map1, page_size);
+       munmap(map2, page_size);
        close(fd);
 }

~
-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
