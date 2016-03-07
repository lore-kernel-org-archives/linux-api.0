From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: [PATCH v5 0/4] make sigaltstack() compatible with swapcontext()
Date: Mon,  7 Mar 2016 19:39:40 +0300
Message-ID: <1457368784-11090-1-git-send-email-stsp@list.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stsp-cmBhpYW9OiY@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
[PATCH 4/4] selftests: Add test for sigaltstack(SS_ONSTACK |
	This patch adds the selftest code for new functionality

CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

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
