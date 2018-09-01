From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 0/5] y2038: Make ppoll, io_pgetevents and pselect y2038 safe
Date: Sat,  1 Sep 2018 13:47:16 -0700
Message-ID: <20180901204721.13117-1-deepa.kernel@gmail.com>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-aio@kvack.org
List-Id: linux-api@vger.kernel.org

The series transitions the ppoll, io_getevents, and pselect syscalls
to be y2038 safe.

This is part of the work proceeding for syscalls for y2038.
It is based on the series [1] from Arnd Bergmann.

The overview of the series is as below:
1. Refactor sigmask handling logic for the above syscalls.
2. Provide y2038 safe versions of syscalls for all ABIs.

[1] https://lkml.org/lkml/2018/8/27/651

Deepa Dinamani (5):
  signal: Add set_user_sigmask()
  signal: Add restore_user_sigmask()
  ppoll: use __kernel_timespec
  pselect6: use __kernel_timespec
  io_pgetevents: use __kernel_timespec

 fs/aio.c                 | 138 ++++++++++-----
 fs/eventpoll.c           |  52 +-----
 fs/select.c              | 367 +++++++++++++++++++++++----------------
 include/linux/compat.h   |  20 +++
 include/linux/signal.h   |   4 +
 include/linux/syscalls.h |  20 ++-
 kernel/signal.c          |  78 +++++++++
 7 files changed, 437 insertions(+), 242 deletions(-)

-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
