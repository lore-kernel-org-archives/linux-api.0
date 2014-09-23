From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 0/7] kselftest framework and test changes to use it
Date: Tue, 23 Sep 2014 15:32:53 -0600
Message-ID: <cover.1411506121.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch v2 series: (revised to address v1 comments)

Add kselftest framework for tests to use. This is a light
weight framework provides a set of interfaces to report test
results and test statistics on number of tests passed and failed.

Several tests are changed to use the framework to report results.

Shuah Khan (7):
  selftests: add kselftest framework for uniform test reporting
  selftests/breakpoints: change test to use ksft framework
  selftests/ipc: change test to use ksft framework
  selftests/kcmp: change test to use ksft framework
  selftests/mount: change test to use ksft framework
  selftests/ptrace: change test to use ksft framework
  selftests/timers: change test to use ksft framework

 .../selftests/breakpoints/breakpoint_test.c        | 10 +++---
 tools/testing/selftests/ipc/msgque.c               | 26 +++++++-------
 tools/testing/selftests/kcmp/kcmp_test.c           | 27 ++++++++++----
 tools/testing/selftests/kselftest.h                | 41 ++++++++++++++++++++++
 .../selftests/mount/unprivileged-remount-test.c    |  8 +++--
 tools/testing/selftests/ptrace/peeksiginfo.c       | 14 ++++----
 tools/testing/selftests/timers/posix_timers.c      | 14 ++++----
 7 files changed, 101 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest.h

-- 
1.9.1
