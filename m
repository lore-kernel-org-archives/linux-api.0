From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL RESEND] kselftest-3.19-rc1
Date: Mon, 15 Dec 2014 14:51:20 -0700
Message-ID: <548F57D8.4080809@osg.samsung.com>
References: <548750AD.6090201@osg.samsung.com> <CA+55aFx2DSXuikfd-RyEN3V+OaLSYhWub92=NJsNXGUhVnKKFQ@mail.gmail.com> <548EEA88.2060206@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <548EEA88.2060206-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuah.kh-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following Kselftest updates for 3.19-rc1. Hope
I have this right this time. Sorry again for the messed up
first request.

thanks,
-- Shuah

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-3.19-rc1

for you to fetch changes up to 3ce51050fadd63737c03627293ca2dc4be238891:

  selftest: size: Add size test for Linux kernel (2014-12-03 19:27:47 -0700)

----------------------------------------------------------------
kselftest updates for 3.19-rc1

----------------------------------------------------------------
Michael Ellerman (3):
      kcmp: Move kcmp.h into uapi
      selftests/kcmp: Don't include kernel headers
      selftests/kcmp: Always try to build the test

Shuah Khan (7):
      selftests/net: move test out of Makefile into a shell script
      selftests/user: move test out of Makefile into a shell script
      selftests: add kselftest framework for uniform test reporting
      selftests/breakpoints: change test to use ksft framework
      selftests/ipc: change test to use ksft framework
      selftests/kcmp: change test to use ksft framework
      selftests/timers: change test to use ksft framework

Tim Bird (1):
      selftest: size: Add size test for Linux kernel

 include/uapi/linux/Kbuild                          |   1 +
 include/{ => uapi}/linux/kcmp.h                    |   6 +-
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/breakpoints/breakpoint_test.c        |  10 ++-
 tools/testing/selftests/ipc/msgque.c               |  26 +++---
 tools/testing/selftests/kcmp/Makefile              |  22 +----
 tools/testing/selftests/kcmp/kcmp_test.c           |  27 ++++--
 tools/testing/selftests/kselftest.h                |  62 +++++++++++++
 tools/testing/selftests/net/Makefile               |   8 +-
 tools/testing/selftests/net/test_bpf.sh            |  10 +++
 tools/testing/selftests/size/.gitignore            |   1 +
 tools/testing/selftests/size/Makefile              |  12 +++
 tools/testing/selftests/size/get_size.c            | 100
+++++++++++++++++++++
 tools/testing/selftests/timers/posix_timers.c      |  14 +--
 tools/testing/selftests/user/Makefile              |   8 +-
 tools/testing/selftests/user/test_user_copy.sh     |  10 +++
 16 files changed, 252 insertions(+), 66 deletions(-)
 rename include/{ => uapi}/linux/kcmp.h (62%)
 create mode 100644 tools/testing/selftests/kselftest.h
tools/testing/selftests/net/Makefile               |   8 +-
 tools/testing/selftests/net/test_bpf.sh            |  10 +++
 tools/testing/selftests/size/.gitignore            |   1 +
 tools/testing/selftests/size/Makefile              |  12 +++
 tools/testing/selftests/size/get_size.c            | 100
+++++++++++++++++++++
 tools/testing/selftests/timers/posix_timers.c      |  14 +--
 tools/testing/selftests/user/Makefile              |   8 +-
 tools/testing/selftests/user/test_user_copy.sh     |  10 +++
 16 files changed, 252 insertions(+), 66 deletions(-)
 rename include/{ => uapi}/linux/kcmp.h (62%)
 create mode 100644 tools/testing/selftests/kselftest.h
 create mode 100755 tools/testing/selftests/net/test_bpf.sh
 create mode 100644 tools/testing/selftests/size/.gitignore
 create mode 100644 tools/testing/selftests/size/Makefile
 create mode 100644 tools/testing/selftests/size/get_size.c
 create mode 100755 tools/testing/selftests/user/test_user_copy.sh


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Open Source Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
