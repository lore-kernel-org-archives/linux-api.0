From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] Kselftest updates for 3.20-rc1
Date: Mon, 09 Feb 2015 11:36:12 -0700
Message-ID: <54D8FE1C.5040303@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following Kselftest updates for 3.20-rc1

thanks,
-- Shuah

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-3.20-rc1

for you to fetch changes up to 6ddf898c23d62c974e148efd9e509731324a167a:

  selftests/exec: Check if the syscall exists and bail if not
(2015-02-04 10:17:35 -0700)

----------------------------------------------------------------
Kselftest updates for 3.20-rc1

This update adds:
- Kselftest install target feature
- Fix for selftests/exec test

----------------------------------------------------------------
Michael Ellerman (1):
      selftests/exec: Check if the syscall exists and bail if not

Shuah Khan (20):
      selftests/breakpoints: add install target to enable test install
      selftests/cpu-hotplug: add install target to enable test install
      selftests/efivarfs: add install target to enable test install
      selftests/firmware: add install target to enable test install
      selftests/ftrace: add install target to enable test install
      selftests/ipc: add install target to enable test install
      selftests/kcmp: add install target to enable test install
      selftests/memfd: add install target to enable test install
      selftests/memory-hotplug: add install target to enable test install
      selftests/mount: add install target to enable test install
      selftests/mqueue: add install target to enable test install
      selftests/net: add install target to enable test install
      selftests/ptrace: add install target to enable test install
      selftests/size: add install target to enable test install
      selftests/sysctl: add install target to enable test install
      selftests/timers: add install target to enable test install
      selftests/user: add install target to enable test install
      selftests/vm: add install target to enable test install
      selftests: add install target to enable test install
      kbuild: add a new kselftest_install make target to install selftests

 Makefile                                           | 14 +++++-
 tools/testing/selftests/Makefile                   | 54
+++++++++++++++++++++-
 tools/testing/selftests/breakpoints/Makefile       | 19 +++++++-
 tools/testing/selftests/cpu-hotplug/Makefile       | 14 +++++-
 .../{on-off-test.sh => cpu-on-off-test.sh}         |  0
 tools/testing/selftests/efivarfs/Makefile          | 16 ++++++-
 tools/testing/selftests/exec/execveat.c            | 10 +++-
 tools/testing/selftests/firmware/Makefile          | 43 ++++++++++-------
 tools/testing/selftests/ftrace/Makefile            | 13 +++++-
 tools/testing/selftests/ipc/Makefile               | 19 +++++++-
 tools/testing/selftests/kcmp/Makefile              | 13 +++++-
 tools/testing/selftests/memfd/Makefile             | 17 +++++--
 tools/testing/selftests/memory-hotplug/Makefile    | 14 +++++-
 .../{on-off-test.sh => mem-on-off-test.sh}         |  0
 tools/testing/selftests/mount/Makefile             | 12 ++++-
 tools/testing/selftests/mqueue/Makefile            | 18 ++++++--
 tools/testing/selftests/net/Makefile               | 20 ++++++--
 tools/testing/selftests/ptrace/Makefile            | 16 +++++--
 tools/testing/selftests/size/Makefile              | 12 ++++-
 tools/testing/selftests/sysctl/Makefile            | 17 ++++++-
 tools/testing/selftests/timers/Makefile            | 12 ++++-
 tools/testing/selftests/user/Makefile              | 12 ++++-
 tools/testing/selftests/vm/Makefile                | 11 ++++-
 23 files changed, 326 insertions(+), 50 deletions(-)
 rename tools/testing/selftests/cpu-hotplug/{on-off-test.sh =>
cpu-on-off-test.sh} (100%)
 rename tools/testing/selftests/memory-hotplug/{on-off-test.sh =>
mem-on-off-test.sh} (100%)

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
