From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] kselftest fixes for 4.1-rc4
Date: Fri, 15 May 2015 12:47:51 -0600
Message-ID: <55563F57.1060703@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following Kselftest fixes for 4.1-rc4

thanks,
-- Shuah


The following changes since commit b787f68c36d49bb1d9236f403813641efa74a031:

  Linux 4.1-rc1 (2015-04-26 17:59:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.1-rc4

for you to fetch changes up to e9886ace222eb48bb57bd541320056ca334bd3a0:

  selftests, x86: Rework x86 target architecture detection (2015-05-12
20:02:40 -0600)

----------------------------------------------------------------
linux-kselftest-4.1-rc4

Urgent fix for Kselftest regression introduced in 4.1-rc1
by the new x86 test due to its hard dependency on 32-bit
build environment. A set of 5 patches fix the make kselftest
run and kselftest install.

----------------------------------------------------------------
Andy Lutomirski (2):
      selftests, x86: Remove useless run_tests rule
      selftests, x86: Rework x86 target architecture detection

Tyler Baker (3):
      selftest/x86: build both bitnesses
      selftest/x86: have no dependency on all when cross building
      selftests/x86: install tests

 tools/testing/selftests/x86/Makefile               | 53
+++++++++++++---------
 tools/testing/selftests/x86/check_cc.sh            | 16 +++++++
 tools/testing/selftests/x86/run_x86_tests.sh       | 13 ------
 .../testing/selftests/x86/trivial_32bit_program.c  |  4 ++
 .../testing/selftests/x86/trivial_64bit_program.c  | 18 ++++++++
 5 files changed, 69 insertions(+), 35 deletions(-)
 create mode 100755 tools/testing/selftests/x86/check_cc.sh
 delete mode 100644 tools/testing/selftests/x86/run_x86_tests.sh
 create mode 100644 tools/testing/selftests/x86/trivial_64bit_program.c


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
