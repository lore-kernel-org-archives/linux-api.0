From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: [PATCH 0/4] make sigaltstack() compatible with swapcontext()
Date: Sun, 31 Jan 2016 19:16:41 +0300
Message-ID: <56AE3369.2090709@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The following patches add the self-test for
sigaltstack(SS_DISABLE) inside the signal handler,
and allow an app to temporarily disable and re-enable
the sigaltstack within a sighandler.
This is needed to make sigaltstack() compatible with
swapcontext(): before using swapcontext() inside
the sighandler, the sigaltstack should be disabled, or
the stack will be corrupted by the subsequent signals.



  arch/score/kernel/signal.c                   |    2
  arch/x86/kernel/signal.c                     |    2
  include/linux/sched.h                        |    8 +
  include/linux/signal.h                       |    2
  kernel/fork.c                                |    4
  kernel/signal.c                              |   54 +++++++----
  tools/testing/selftests/Makefile             |    1
  tools/testing/selftests/sigaltstack/Makefile |    8 +
  tools/testing/selftests/sigaltstack/sas.c    |  132 
+++++++++++++++++++++++++++
  9 files changed, 189 insertions(+), 24 deletions(-)
