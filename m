From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v4 0/5] y2038: Make ppoll, io_pgetevents and pselect y2038 safe
Date: Wed, 19 Sep 2018 21:41:03 -0700
Message-ID: <20180920044108.6606-1-deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-aio@kvack.org
List-Id: linux-api@vger.kernel.org

The series transitions the ppoll, io_getevents, and pselect syscalls
to be y2038 safe.

This is part of the work proceeding for syscalls for y2038.
It is based on the series [1] from Arnd Bergmann.

The overview of the series is as below:
1. Refactor sigmask handling logic for the above syscalls.
2. Provide y2038 safe versions of the syscalls for all ABIs.

[1] https://lkml.org/lkml/2018/8/27/651

Changes since v3:
* fixed pselect copy+paste error
Changes since v2:
* remove 64BIT_TIME conditional for ppoll, pselect,
  io_getpevents as per review comments
Changes since v1:
* fixed bug pointed out by arnd

Deepa Dinamani (5):
  signal: Add set_user_sigmask()
  signal: Add restore_user_sigmask()
  ppoll: use __kernel_timespec
  pselect6: use __kernel_timespec
  io_pgetevents: use __kernel_timespec

 fs/aio.c                 | 134 ++++++++++-----
 fs/eventpoll.c           |  52 +-----
 fs/select.c              | 360 ++++++++++++++++++++++-----------------
 include/linux/compat.h   |  20 +++
 include/linux/signal.h   |   4 +
 include/linux/syscalls.h |  20 ++-
 kernel/signal.c          |  78 +++++++++
 7 files changed, 426 insertions(+), 242 deletions(-)

-- 
2.17.1
