From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] kselftest fixes for 4.0-rc4
Date: Fri, 13 Mar 2015 11:39:28 -0600
Message-ID: <550320D0.6080103@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the kselftest fix for 4.0-rc4.

thanks,
-- Shuah

The following changes since commit 9eccca0843205f87c00404b663188b88eb248051:

  Linux 4.0-rc3 (2015-03-08 16:09:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.0-rc4

for you to fetch changes up to 9a0b57451ae8142c74d65bddb6d7765818babbed:

  selftests/exec: Check if the syscall exists and bail if not
(2015-03-11 10:15:19 -0600)

----------------------------------------------------------------
Kselftest fixes for Linux 4.0-rc4

selftests/exec: Check if the syscall exists and bail if not

----------------------------------------------------------------
Michael Ellerman (1):
      selftests/exec: Check if the syscall exists and bail if not

 tools/testing/selftests/exec/execveat.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
