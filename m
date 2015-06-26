From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] Kselftest updates for 4.2-rc1
Date: Fri, 26 Jun 2015 14:02:33 -0600
Message-ID: <558DAFD9.2040108@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following Kselftest updates for 4.2-rc1

thanks,
-- Shuah

 The following changes since commit
ba155e2d21f6bf05de86a78dbe5bfd8757604a65:

  Linux 4.1-rc5 (2015-05-24 18:22:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.2-rc1

for you to fetch changes up to 2278e5ed9f36baca7c972ed17aae7467ca91b2b9:

  selftests: add quicktest support (2015-06-23 07:20:16 -0600)

----------------------------------------------------------------
linux-kselftest-4.2-rc1

This update adds two new test suites: futex and seccomp.
In addition, it includes fixes for bugs in timers, other
tests, and compile framework. It introduces new quicktest
feature to enable users to choose to run tests that complete
in a short time..

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      tools selftests: Fix 'clean' target with make 3.81

Darren Hart (6):
      selftests: Add futex functional tests
      selftests/futex: Update Makefile to use lib.mk
      selftests/futex: Increment ksft pass and fail counters
      selftests: Add futex tests to the top-level Makefile
      kselftest: Add exit code defines
      selftests/futex: Add .gitignore

John Stultz (3):
      kselftests: timers: Increase delay between suspends in
alarmtimer-suspend
      kselftests: timers: Ease alarmtimer-suspend unreasonable latency value
      kselftests: timers: Check _ALARM clockids are supported before
suspending

Kees Cook (1):
      selftests: add seccomp suite

Martin Kelly (1):
      selftest, x86: fix incorrect comment

Shuah Khan (1):
      selftests: add quicktest support

Sri Jayaramappa (1):
      Test compaction of mlocked memory

Tyler Baker (3):
      selftests: copy TEST_DIRS to INSTALL_PATH
      selftests/ftrace: install test.d
      selftests/exec: do not install subdir as it is already created

Zhang Zhen (2):
      selftests/timers: Make git ignore all binaries in timers test suite
      selftests/mount: output WARN messages when mount test skipped

 MAINTAINERS                                        |    1 +
 tools/testing/selftests/Makefile                   |    8 +-
 tools/testing/selftests/exec/Makefile              |    2 +-
 tools/testing/selftests/ftrace/Makefile            |    1 +
 tools/testing/selftests/futex/Makefile             |   29 +
 tools/testing/selftests/futex/README               |   62 +
 .../testing/selftests/futex/functional/.gitignore  |    7 +
 tools/testing/selftests/futex/functional/Makefile  |   25 +
 .../selftests/futex/functional/futex_requeue_pi.c  |  409 ++++
 .../functional/futex_requeue_pi_mismatched_ops.c   |  135 ++
 .../functional/futex_requeue_pi_signal_restart.c   |  223 +++
 .../functional/futex_wait_private_mapped_file.c    |  125 ++
 .../futex/functional/futex_wait_timeout.c          |   86 +
 .../functional/futex_wait_uninitialized_heap.c     |  124 ++
 .../futex/functional/futex_wait_wouldblock.c       |   79 +
 tools/testing/selftests/futex/functional/run.sh    |   79 +
 tools/testing/selftests/futex/include/atomic.h     |   83 +
 tools/testing/selftests/futex/include/futextest.h  |  266 +++
 tools/testing/selftests/futex/include/logging.h    |  153 ++
 tools/testing/selftests/futex/run.sh               |   33 +
 tools/testing/selftests/kselftest.h                |   17 +-
 tools/testing/selftests/lib.mk                     |    3 +
 tools/testing/selftests/mount/Makefile             |    7 +-
 tools/testing/selftests/seccomp/.gitignore         |    1 +
 tools/testing/selftests/seccomp/Makefile           |   10 +
 tools/testing/selftests/seccomp/seccomp_bpf.c      | 2109
++++++++++++++++++++
 tools/testing/selftests/seccomp/test_harness.h     |  537 +++++
 tools/testing/selftests/timers/.gitignore          |   18 +
 .../testing/selftests/timers/alarmtimer-suspend.c  |   10 +-
 tools/testing/selftests/vm/Makefile                |    7 +-
 tools/testing/selftests/vm/compaction_test.c       |  225 +++
 tools/testing/selftests/vm/run_vmtests             |   12 +
 .../testing/selftests/x86/trivial_64bit_program.c  |    2 +-
 33 files changed, 4875 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/futex/Makefile
 create mode 100644 tools/testing/selftests/futex/README
 create mode 100644 tools/testing/selftests/futex/functional/.gitignore
 create mode 100644 tools/testing/selftests/futex/functional/Makefile
 create mode 100644
tools/testing/selftests/futex/functional/futex_requeue_pi.c
 create mode 100644
tools/testing/selftests/futex/functional/futex_requeue_pi_mismatched_ops.c
 create mode 100644
tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
 create mode 100644
tools/testing/selftests/futex/functional/futex_wait_private_mapped_file.c
 create mode 100644
tools/testing/selftests/futex/functional/futex_wait_timeout.c
 create mode 100644
tools/testing/selftests/futex/functional/futex_wait_uninitialized_heap.c
 create mode 100644
tools/testing/selftests/futex/functional/futex_wait_wouldblock.c
 create mode 100755 tools/testing/selftests/futex/functional/run.sh
 create mode 100644 tools/testing/selftests/futex/include/atomic.h
 create mode 100644 tools/testing/selftests/futex/include/futextest.h
 create mode 100644 tools/testing/selftests/futex/include/logging.h
 create mode 100755 tools/testing/selftests/futex/run.sh
 create mode 100644 tools/testing/selftests/seccomp/.gitignore
 create mode 100644 tools/testing/selftests/seccomp/Makefile
 create mode 100644 tools/testing/selftests/seccomp/seccomp_bpf.c
 create mode 100644 tools/testing/selftests/seccomp/test_harness.h
 create mode 100644 tools/testing/selftests/timers/.gitignore
 create mode 100644 tools/testing/selftests/vm/compaction_test.c


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
