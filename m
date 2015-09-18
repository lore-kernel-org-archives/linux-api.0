From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [GIT PULL] Kselftest fixes for 4.3-rc2
Date: Fri, 18 Sep 2015 08:41:10 -0600
Message-ID: <55FC2286.7010809@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following fixes for 4.3-rc2. This update contains 7
fixes for problems ranging from build failures to incorrect error
reporting.

thanks,
-- Shuah

The following changes since commit 6ff33f3902c3b1c5d0db6b1e2c70b6d76fba357f:

  Linux 4.3-rc1 (2015-09-12 16:35:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.3-rc2

for you to fetch changes up to ae7858180510d6fd0dfaf66d209bc6103db1678f:

  selftests: exec: revert to default emit rule (2015-09-14 16:45:05 -0600)

----------------------------------------------------------------
linux-kselftest-4.3-rc2-fixes

This update contains 7 fixes for problems ranging from
build failurs to incorrect error reporting.

----------------------------------------------------------------
Bamvor Jian Zhang (5):
      selftests: rename jump label to static_keys
      selftests: mqueue: allow extra cflags
      selftests: mqueue: simplify the Makefile
      selftests: change install command to rsync
      selftests: exec: revert to default emit rule

Kees Cook (1):
      selftests/seccomp: add support for s390

Zhang Zhen (1):
      seltests/zram: fix syntax error

 tools/testing/selftests/Makefile               |  2 +-
 tools/testing/selftests/exec/Makefile          |  4 +--
 tools/testing/selftests/ftrace/Makefile        |  2 +-
 tools/testing/selftests/lib.mk                 | 11 +++-----
 tools/testing/selftests/mqueue/Makefile        | 10 +++----
 tools/testing/selftests/seccomp/seccomp_bpf.c  | 37
+++++++++++++++++++++++++-
 tools/testing/selftests/seccomp/test_harness.h |  7 ++---
 tools/testing/selftests/zram/zram.sh           | 10 +------
 tools/testing/selftests/zram/zram_lib.sh       |  3 ++-
 9 files changed, 52 insertions(+), 34 deletions(-)

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
