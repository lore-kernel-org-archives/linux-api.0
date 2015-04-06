From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] kselftest updates for 4.1-rc1
Date: Mon, 06 Apr 2015 14:53:05 -0600
Message-ID: <5522F231.2050903@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Here is the pull request for Kselftest updates for 4.1-rc1
This is a milestone update in a sense. Several new tests and
install and packaging support is added in this update.

thanks,
-- Shuah

The following changes since commit 9eccca0843205f87c00404b663188b88eb248051:

  Linux 4.0-rc3 (2015-03-08 16:09:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.1-rc1

for you to fetch changes up to 2bfd4d1f8c2bee8b0b8832be0c38d3916713625f:

  ftracetest: Do not use usleep directly (2015-04-03 09:16:32 -0600)

----------------------------------------------------------------
linux-kselftest-4.1-rc1

This update adds install and packaging tools developed on top
of back-end shared logic enhancemnets to run and install tests.
In addition several timer tests are added.

- New timer tests from John Stultz
- rtc test from Prarit Bhargava
- Enhancements to un and install tests from Michael Ellerman
- Install and packaging tools from Shuah Khan
- Cross-compilation enablement from Tyler Baker
- A couple of bug fixes.

----------------------------------------------------------------
John Stultz (22):
      selftests/timers: Cleanup Makefile to make it easier to add future
tests
      selftests/timers: Quiet warning due to lack of return check on brk
      selftests/timers: Add nanosleep test from timetest suite
      selftests/timers: Add inconsistency-check test from timetests
      selftests/timers: Add nsleep-lat test from timetest suite
      selftests/timers: Add clock skew estimation test from timetest suite
      selftests/timers: Add set-timer-lat test from timetest suite
      selftests/timers: Add threaded time inconsistency test from
timetest suite
      selftests/timers: Add mqueue latency test from the timetest suite
      selftests/timers: Add adjtimex validation test from timetest suite
      selftests/timers: Add alarmtimer-suspend test from timetests suite
      selftests/timers: Add change_skew test from timetest suite
      selftests/timers: Add skew_consistency test from the timetests suite
      selftests/timers: Add clocksource-switch test from timetest suite
      selftests/timers: Add leap-a-day test from timetest suite
      selftests/timers: Add leapcrash test from the timetest suite
      selftests/timers: Add set-tai from the timetest suite
      selftests/timers: Add set-2038 test from timetest suite
      MAINTAINERS: Add selftests/timers to the timekeeping maintainance list
      kselftest/timers: Set default threadtest values to simplify
execution scripts
      kselftests: timers: Reduce default runtime on inconsistency-check
and set-timer-lat
      kselftests: timers: Make set-timer-lat fail more gracefully for
!CAP_WAKE_ALARM

Michael Ellerman (7):
      selftests: Introduce minimal shared logic for running tests
      selftests: Add install target
      selftests/timers: Use shared logic to run and install tests
      selftests: Add install support for the powerpc tests
      selftests: Set CC using CROSS_COMPILE once in lib.mk
      ftracetest: Cope properly with stack tracer not being enabled
      ftracetest: Convert exit -1 to exit $FAIL

Namhyung Kim (1):
      ftracetest: Do not use usleep directly

Prarit Bhargava (2):
      Documentation, split up rtc.txt into documentation and test file
      tools, update rtctest.c to verify passage of time

Shuah Khan (4):
      selftests: Add kselftest install tool
      selftests: Add tool to generate kselftest tar archive
      selftests: change cpu on-off-test.sh name to be unique
      selftests: Change memory on-off-test.sh name to be unique

Tyler Baker (5):
      selftest/memfd: enable cross compilation
      selftest/mount: enable cross compilation
      selftest/memfd: include default header install path
      selftest/ipc: enable cross compilation
      selftest/mqueue: enable cross compilation

Zhang Zhen (1):
      selftests/mount: Make git ignore all binaries in mount test suite

 Documentation/rtc.txt                              | 264 +----------------
 MAINTAINERS                                        |   1 +
 tools/testing/selftests/Makefile                   |  33 +++
 tools/testing/selftests/breakpoints/Makefile       |   5 +-
 tools/testing/selftests/cpu-hotplug/Makefile       |   7 +-
 .../{on-off-test.sh => cpu-on-off-test.sh}         |   0
 tools/testing/selftests/efivarfs/Makefile          |   7 +-
 tools/testing/selftests/efivarfs/efivarfs.sh       |   0
 tools/testing/selftests/exec/Makefile              |   9 +-
 tools/testing/selftests/firmware/Makefile          |  20 +-
 tools/testing/selftests/firmware/fw_filesystem.sh  |   0
 tools/testing/selftests/firmware/fw_userhelper.sh  |   0
 tools/testing/selftests/ftrace/Makefile            |   5 +-
 .../selftests/ftrace/test.d/00basic/basic4.tc      |   2 +-
 .../selftests/ftrace/test.d/event/event-enable.tc  |  15 +-
 .../ftrace/test.d/event/subsystem-enable.tc        |  15 +-
 .../ftrace/test.d/event/toplevel-enable.tc         |  15 +-

 .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    |   6 +-
 .../ftrace/test.d/ftrace/fgraph-filter.tc          |   2 +-
 .../ftrace/test.d/ftrace/func_profiler.tc          |   2 +-
 tools/testing/selftests/gen_kselftest_tar.sh       |  55 ++++
 tools/testing/selftests/ipc/Makefile               |  11 +-
 tools/testing/selftests/kcmp/Makefile              |   6 +-
 tools/testing/selftests/kselftest_install.sh       |  37 +++
 tools/testing/selftests/lib.mk                     |  35 +++
 tools/testing/selftests/memfd/Makefile             |  14 +-
 tools/testing/selftests/memory-hotplug/Makefile    |   9 +-
 .../{on-off-test.sh => mem-on-off-test.sh}         |   0
 tools/testing/selftests/mount/.gitignore           |   1 +
 tools/testing/selftests/mount/Makefile             |  15 +-
 tools/testing/selftests/mqueue/Makefile            |  22 +-
 tools/testing/selftests/net/Makefile               |  10 +-
 tools/testing/selftests/net/run_afpackettests      |   0
 tools/testing/selftests/net/run_netsocktests       |   0
 tools/testing/selftests/powerpc/Makefile           |  22 +-
 tools/testing/selftests/powerpc/copyloops/Makefile |  15 +-
 tools/testing/selftests/powerpc/mm/Makefile        |  15 +-
 tools/testing/selftests/powerpc/pmu/Makefile       |  48 ++--
 tools/testing/selftests/powerpc/pmu/ebb/Makefile   |  13 +-
 .../testing/selftests/powerpc/primitives/Makefile  |  15 +-
 .../testing/selftests/powerpc/stringloops/Makefile |  15 +-
 tools/testing/selftests/powerpc/tm/Makefile        |  15 +-
 tools/testing/selftests/ptrace/Makefile            |   5 +-
 tools/testing/selftests/size/Makefile              |   7 +-
 tools/testing/selftests/sysctl/Makefile            |  12 +-
 tools/testing/selftests/sysctl/run_numerictests    |   0
 tools/testing/selftests/sysctl/run_stringtests     |   0
 tools/testing/selftests/timers/Makefile            |  38 ++-
 .../testing/selftests/timers/alarmtimer-suspend.c  | 185 ++++++++++++
 tools/testing/selftests/timers/change_skew.c       | 107 +++++++
 .../testing/selftests/timers/clocksource-switch.c  | 179 ++++++++++++
 .../testing/selftests/timers/inconsistency-check.c | 204 +++++++++++++
 tools/testing/selftests/timers/leap-a-day.c        | 319
+++++++++++++++++++++
 tools/testing/selftests/timers/leapcrash.c         | 120 ++++++++
 tools/testing/selftests/timers/mqueue-lat.c        | 124 ++++++++
 tools/testing/selftests/timers/nanosleep.c         | 174 +++++++++++
 tools/testing/selftests/timers/nsleep-lat.c        | 190 ++++++++++++
 tools/testing/selftests/timers/posix_timers.c      |   9 +-
 tools/testing/selftests/timers/raw_skew.c          | 154 ++++++++++
 tools/testing/selftests/timers/rtctest.c           | 271 +++++++++++++++++
 tools/testing/selftests/timers/set-2038.c          | 144 ++++++++++
 tools/testing/selftests/timers/set-tai.c           |  79 +++++
 tools/testing/selftests/timers/set-timer-lat.c     | 216 ++++++++++++++
tools/testing/selftests/timers/skew_consistency.c  |  89 ++++++
 tools/testing/selftests/timers/threadtest.c        | 204 +++++++++++++
 tools/testing/selftests/timers/valid-adjtimex.c    | 202 +++++++++++++
 tools/testing/selftests/user/Makefile              |   5 +-
 tools/testing/selftests/vm/Makefile                |   7 +-
 tools/testing/selftests/vm/run_vmtests             |   0
 69 files changed, 3366 insertions(+), 459 deletions(-)
 rename tools/testing/selftests/cpu-hotplug/{on-off-test.sh =>
cpu-on-off-test.sh} (100%)
 mode change 100644 => 100755
 mode change 100644 => 100755 tools/testing/selftests/efivarfs/efivarfs.sh
 mode change 100644 => 100755
tools/testing/selftests/firmware/fw_filesystem.sh
 mode change 100644 => 100755
tools/testing/selftests/firmware/fw_userhelper.sh
 create mode 100755 tools/testing/selftests/gen_kselftest_tar.sh
 create mode 100755 tools/testing/selftests/kselftest_install.sh
 create mode 100644 tools/testing/selftests/lib.mk
 rename tools/testing/selftests/memory-hotplug/{on-off-test.sh =>
mem-on-off-test.sh} (100%)
 mode change 100644 => 100755
 create mode 100644 tools/testing/selftests/mount/.gitignore
 mode change 100644 => 100755 tools/testing/selftests/net/run_afpackettests
 mode change 100644 => 100755 tools/testing/selftests/net/run_netsocktests
 mode change 100644 => 100755
tools/testing/selftests/sysctl/run_numerictests
 mode change 100644 => 100755 tools/testing/selftests/sysctl/run_stringtests
 create mode 100644 tools/testing/selftests/timers/alarmtimer-suspend.c
 create mode 100644 tools/testing/selftests/timers/change_skew.c
 create mode 100644 tools/testing/selftests/timers/clocksource-switch.c
 create mode 100644 tools/testing/selftests/timers/inconsistency-check.c
 create mode 100644 tools/testing/selftests/timers/leap-a-day.c
 create mode 100644 tools/testing/selftests/timers/leapcrash.c
 create mode 100644 tools/testing/selftests/timers/mqueue-lat.c
 create mode 100644 tools/testing/selftests/timers/nanosleep.c
 create mode 100644 tools/testing/selftests/timers/nsleep-lat.c
 create mode 100644 tools/testing/selftests/timers/raw_skew.c
 create mode 100644 tools/testing/selftests/timers/rtctest.c
 create mode 100644 tools/testing/selftests/timers/set-2038.c
 create mode 100644 tools/testing/selftests/timers/set-tai.c
 create mode 100644 tools/testing/selftests/timers/set-timer-lat.c
 create mode 100644 tools/testing/selftests/timers/skew_consistency.c
 create mode 100644 tools/testing/selftests/timers/threadtest.c
 create mode 100644 tools/testing/selftests/timers/valid-adjtimex.c
 mode change 100644 => 100755 tools/testing/selftests/vm/run_vmtests

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
