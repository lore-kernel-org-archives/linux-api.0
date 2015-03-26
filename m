From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] kselftest fixes for 4.0-rc6
Date: Thu, 26 Mar 2015 12:08:10 -0600
Message-ID: <55144B0A.9090303@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Could you please pull the following kselftest fix for 4.0-rc6.

thanks,
-- Shuah

The following changes since commit 9a0b57451ae8142c74d65bddb6d7765818babbed:

  selftests/exec: Check if the syscall exists and bail if not
(2015-03-11 10:15:19 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.0-rc6

for you to fetch changes up to 67d8712dcc70aa16d8e14a52eb73870e3cbddfc2:

  selftests: Fix build failures when invoked from kselftest target
(2015-03-19 09:54:55 -0600)

----------------------------------------------------------------
kselftest fixes for: 4.0-rc6

----------------------------------------------------------------
Shuah Khan (1):
      selftests: Fix build failures when invoked from kselftest target

 tools/testing/selftests/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
