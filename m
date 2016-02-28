From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH v3 0/2] make sigaltstack() compatible with swapcontext()
Date: Mon, 29 Feb 2016 00:13:18 +0300
Message-ID: <1456694000-16395-1-git-send-email-stsp@list.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stsp@list.ru
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
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

CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org

Diffstat:
 include/linux/sched.h                        |    1 
 include/linux/signal.h                       |    4 
 include/uapi/linux/signal.h                  |    3 
 kernel/fork.c                                |    4 
 kernel/signal.c                              |   23 ++--
 tools/testing/selftests/Makefile             |    1 
 tools/testing/selftests/sigaltstack/Makefile |    8 +
 tools/testing/selftests/sigaltstack/sas.c    |  151 +++++++++++++++++++++++++++
 8 files changed, 182 insertions(+), 13 deletions(-)
