From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] Kselftest updates for 4.3-rc1
Date: Tue, 8 Sep 2015 10:07:40 -0600
Message-ID: <55EF07CC.4070005@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the first update for Kselftest 4.3-rc1. I will send
another update later on this week to fix kselftest breakage due
to commit "2bf9e0a locking/static_keys: Provide a selftest" after
the fix soaks in next for a couple of days.

thanks,
-- Shuah

The following changes since commit d770e558e21961ad6cfdf0ff7df0eb5d7d4f0754:

  Linux 4.2-rc1 (2015-07-05 11:01:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.3-rc1

for you to fetch changes up to 7eba7d90d48217a97afc171a311b386bde965f39:

  selftests/zram: Makefile fix (2015-09-01 10:52:25 -0600)

----------------------------------------------------------------
liux-kselftest-4.3-rc1:

This update adds new zram test and fixes to problems found
during testing this new zram test. In addition, there are
a few bug fixes and ksefltest improvement patches from Linaro
developers.

----------------------------------------------------------------
Bamvor Jian Zhang (2):
      selftests: check before install
      selftests: breakpoints: fix installing error on the architecture
except x86

Naresh Kamboju (3):
      selftests/zram: Adding zram tests
      selftests/zram: must be run as root
      selftests/zram: Makefile fix

 tools/testing/selftests/Makefile             |   2 +-
 tools/testing/selftests/breakpoints/Makefile |  16 +-
 tools/testing/selftests/lib.mk               |  13 +-
 tools/testing/selftests/zram/Makefile        |   9 ++
 tools/testing/selftests/zram/README          |  40 +++++
 tools/testing/selftests/zram/zram.sh         |  35 ++++
 tools/testing/selftests/zram/zram01.sh       |  99 ++++++++++++
 tools/testing/selftests/zram/zram02.sh       |  54 +++++++
 tools/testing/selftests/zram/zram_lib.sh     | 232
+++++++++++++++++++++++++++
 9 files changed, 481 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/zram/Makefile
 create mode 100644 tools/testing/selftests/zram/README
 create mode 100755 tools/testing/selftests/zram/zram.sh
 create mode 100755 tools/testing/selftests/zram/zram01.sh
 create mode 100755 tools/testing/selftests/zram/zram02.sh
 create mode 100755 tools/testing/selftests/zram/zram_lib.sh

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
