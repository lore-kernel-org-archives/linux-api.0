From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] kselftest fixes for 3.19-rc5
Date: Tue, 13 Jan 2015 11:07:12 -0700
Message-ID: <54B55ED0.5000607@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following ksefltest fixes for 3.19-rc5

thanks,
-- Shuah

The following changes since commit 6898b627aab6ba553e6d8b40a0b1ddc43c48d42f:

  selftests/exec: Use %zu to format size_t (2014-12-22 11:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-3.19-rc-5

for you to fetch changes up to f5db310d77ef1742e40bfc303b8625584c55f9e3:

  selftests/vm: fix link error for transhuge-stress test (2015-01-08
09:01:00 -0700)

----------------------------------------------------------------
kselftest fixes for: 3.19-rc5

This update contains 3 patches to fix one compile error,
and two run-time bugs. One of them fixes infinite loop
on ARM.

----------------------------------------------------------------
Andrey Skvortsov (1):
      selftests/vm: fix link error for transhuge-stress test

David Drysdale (1):
      selftests/exec: allow shell return code of 126

dann frazier (1):
      tools: testing: selftests: mq_perf_tests: Fix infinite loop on ARM

 tools/testing/selftests/exec/execveat.c        | 19 +++++++++++++------
 tools/testing/selftests/mqueue/mq_perf_tests.c |  3 +--
 tools/testing/selftests/vm/Makefile            |  2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
