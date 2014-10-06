From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] kselftest 3.18-updates-1
Date: Mon, 06 Oct 2014 10:47:04 -0600
Message-ID: <5432C788.50609@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Here are the updates for kselftest for 3.18. Please see
details in the signed tag.

thanks,
-- Shuah

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:


git-OoYKEaZ2EDaWaY/ihj7yzEB+6BGkLq7r@public.gmane.org:/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/kselftest-3.18-updates-1

for you to fetch changes up to ce6a144a0d01c6628496e4c0d18fbf3a0362cc67:

  selftests/memfd: Run test on all architectures (2014-09-17 08:00:16 -0600)

----------------------------------------------------------------
kselftest Updates for 3.18
- Fix for missing arguments to printf
- Fix to build failures on 32-bit systems.
- Enhancement to run memfd_test run on all architectures
  as most architectures support __NR_memfd_create
----------------------------------------------------------------
Pranith Kumar (3):
      memfd_test: Make it work on 32-bit systems
      memfd_test: Add missing argument to printf()
      selftests/memfd: Run test on all architectures

 tools/testing/selftests/memfd/Makefile     | 21 -----------------
 tools/testing/selftests/memfd/memfd_test.c | 36
++++++++++++++----------------
 2 files changed, 17 insertions(+), 40 deletions(-)


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
