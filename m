From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] Kselftest fixes for 4.2-rc5
Date: Mon, 27 Jul 2015 09:01:32 -0600
Message-ID: <55B647CC.3010800@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following Kselftest fixes for 4.2-rc5

thanks,
-- Shuah

The following changes since commit d770e558e21961ad6cfdf0ff7df0eb5d7d4f0754:

  Linux 4.2-rc1 (2015-07-05 11:01:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.2-rc5

for you to fetch changes up to fee50f3c8427aacabfb603229bf0a9056c3f2638:

  selftests/futex: Fix futex_cmp_requeue_pi() error handling (2015-07-20
18:29:38 -0600)

----------------------------------------------------------------
linux-kselftest-4.2-rc5

Kselftest fixes for 4.2-rc5

----------------------------------------------------------------
Darren Hart (1):
      selftests/futex: Fix futex_cmp_requeue_pi() error handling

 .../selftests/futex/functional/futex_requeue_pi_signal_restart.c
 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
