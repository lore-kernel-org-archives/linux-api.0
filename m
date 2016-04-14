From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH v6(resend2) 0/4] make sigaltstack compatible with swapcontext()
Date: Thu, 14 Apr 2016 23:20:01 +0300
Message-ID: <1460665206-13646-1-git-send-email-stsp@list.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stsp@list.ru
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

The following patches make it possible to use swapcontext()
in a sighandler that works on sigaltstack.
The approach is inspired by Andy Lutomirski's suggestion that
sigaltstack should disarm itself after saving into uc_stack:
https://lkml.org/lkml/2016/2/1/594

I add the SS_AUTODISARM flag that does exactly that.
On sighandler exit, the sigaltstack is restored from uc_stack.
Another possible name could be SS_ONESHOT, but, since it gets
always re-enabled, I choose SS_AUTODISARM.

Changes since previous resend:
- Added missing CCs, thanks for the hint Ingo

Change since v5:
- Fix description of patch 4/4

Change since v4:
- Implement this Andy Lutomirski's suggestion:
https://lkml.org/lkml/2016/3/6/158
that allows the run-time probing of the existence of the
flags added in the future.

[PATCH 1/4] [Cleanup] x86: signal: unify the sigaltstack check with
	A clean-up patch that unifies x86's sigaltstack handling with
	other arches.
[PATCH 2/4] sigaltstack: preparations for adding new SS_xxx flags
	Andy's suggested changes
[PATCH 3/4] sigaltstack: implement SS_AUTODISARM flag
	This patch implements SS_AUTODISARM flag
[PATCH 4/4] selftests: Add test for
	This patch adds the selftest code for new functionality

CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org
CC: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Shuah Khan <shuahkh@osg.samsung.com>
CC: Ingo Molnar <mingo@redhat.com>

Diffstat:
 arch/x86/kernel/signal.c                     |   23 +--
 include/linux/sched.h                        |    8 +
 include/linux/signal.h                       |    4 
 include/uapi/linux/signal.h                  |    7 +
 kernel/fork.c                                |    2 
 kernel/signal.c                              |   26 ++--
 tools/testing/selftests/Makefile             |    1 
 tools/testing/selftests/sigaltstack/Makefile |    8 +
 tools/testing/selftests/sigaltstack/sas.c    |  156 +++++++++++++++++++++++++++
 9 files changed, 208 insertions(+), 27 deletions(-)
