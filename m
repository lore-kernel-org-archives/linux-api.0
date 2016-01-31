From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH v2 0/4] make sigaltstack() compatible with swapcontext()
Date: Sun, 31 Jan 2016 22:10:00 +0300
Message-ID: <56AE5C08.6010403@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux kernel <linux-kernel@vger.kernel.org>
Cc: linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

The following patches add the self-test for
sigaltstack(SS_DISABLE) inside the signal handler,
and allow an app to temporarily disable and re-enable
the sigaltstack within a sighandler.
This is needed to make sigaltstack() compatible with
swapcontext(): before using swapcontext() inside
the sighandler, the sigaltstack should be disabled, or
the stack will be corrupted by the subsequent signals.


v2: avoid duplicating the "!sigstack" check in get_sigframe()
as requested by Andy Lutomirski.



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
