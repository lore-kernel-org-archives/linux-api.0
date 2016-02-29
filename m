From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: [PATCH v4 0/2] make sigaltstack() compatible with swapcontext()
Date: Tue,  1 Mar 2016 00:29:03 +0300
Message-ID: <1456781345-8243-1-git-send-email-stsp@list.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stsp-cmBhpYW9OiY@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
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

[PATCH 1/2] sigaltstack: implement SS_AUTODISARM flag
	This patch implements SS_AUTODISARM flag
[PATCH 2/2] selftests: Add test for sigaltstack(SS_AUTODISARM)
	This patch adds the selftest code for new functionality

CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

Diffstat:
 include/linux/sched.h                        |    8 +
 include/linux/signal.h                       |    4 
 include/uapi/linux/signal.h                  |    3 
 kernel/fork.c                                |    2 
 kernel/signal.c                              |   23 ++--
 tools/testing/selftests/Makefile             |    1 
 tools/testing/selftests/sigaltstack/Makefile |    8 +
 tools/testing/selftests/sigaltstack/sas.c    |  151 +++++++++++++++++++++++++++
 8 files changed, 187 insertions(+), 13 deletions(-)
