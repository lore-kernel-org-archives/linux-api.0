From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v3 0/5] kselftest framework and test changes to use it
Date: Fri,  3 Oct 2014 09:36:15 -0600
Message-ID: <cover.1412349412.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, dbueso@suse.de, luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch v3 series: (revised to address v2 comments)
Dropped mount and ptrace patches.

Add kselftest framework for tests to use. This is a light
weight framework provides a set of interfaces to report test
results and test statistics on number of tests passed and failed.

Several tests are changed to use the framework to report results.

Shuah Khan (5):
  selftests: add kselftest framework for uniform test reporting
  selftests/breakpoints: change test to use ksft framework
  selftests/ipc: change test to use ksft framework
  selftests/kcmp: change test to use ksft framework
  selftests/timers: change test to use ksft framework

 .../selftests/breakpoints/breakpoint_test.c        | 10 ++--
 tools/testing/selftests/ipc/msgque.c               | 26 ++++-----
 tools/testing/selftests/kcmp/kcmp_test.c           | 27 +++++++---
 tools/testing/selftests/kselftest.h                | 62 ++++++++++++++++++++++
 tools/testing/selftests/timers/posix_timers.c      | 14 ++---
 5 files changed, 110 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest.h

-- 
1.9.1
