From: Arnd Bergmann <arnd@arndb.de>
Subject: y2038 kernel status update
Date: Wed, 25 Apr 2018 16:00:33 +0200
Message-ID: <CAK8P3a2fJODEHVJ1jfTsX9DGQAPh=FipUDHTqJhRRARXv5JDvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038 Mailman List <y2038@lists.linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Baolin Wang <baolin.wang@linaro.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Firoz Khan <firoz.khan@linaro.org>, RISC-V SW Dev <sw-dev@groups.riscv.org>, Linux API <linux-api@vger.kernel.org>, Private Kernel Alias <private-kwg@linaro.org>
List-Id: linux-api@vger.kernel.org

Hi everyone,

A lot of things have happened in the move to make the kernel y2038
ready in recent times. I've sent out new patches recently but will be
on vacation for the next few weeks, so here's a quick update on where
we are today with recent changes and work in progress:

- A large number of small driver fixes got merged into linux-4.16.
  Many of these were old patches I had done a while ago but that had
  not made it in yet. There are a few dozen more of these coming, but
  those have some dependency.

- Deepa Dinamani has done a lot of the groundwork for the system
  call conversion. Her latest patch series that got merged now finally
  adds new system call entry points for timekeeping related syscalls. They
  are not wired up yet, but now we have a template for the remaining ones,
  and we have sorted out the header file dependencies.

- I just sent a pull request for a second chunk of system calls:
  The sysvipc semtimedop, semctl/shmctl/msgctl and
  mq_timedsend/mq_timedreceive calls. I have more patches for most of
  the remaining calls, and they should be simpler (this one was rather
  tricky). A full list can be found in a spreadsheet I made[2].

- Baolin Wang has worked on RTC related issues and most recently
  posted a series to convert the user space ABI for ALSA. This is
  currently under discussion.

- The most complicated remaining part is the conversion of
  the VFS layer. Deepa is getting a new series for this ready after
  having done some groundwork over the past years.  The current idea is
  to have a flag-day patch using coccinelle to change the inode, iattr
  and kstat structures over at the same time. Many file systems will
  require further changes after that, but those can be done individually
  through their respective maintainers.

- Firoz Khan has started looking at the system call entry
  points in the architectures. We want to add the new system calls to
  all 32-bit architectures at once, in order to have a baseline release
  that C libraries can rely on for implementing 64-bit time_t on all
  architectures.  Even after the architecture removal series, we still
  have over a dozen different syscall tables and each one is laid out
  slightly differently, which makes it hard to change.  To improve this,
  Firoz is preparing a series that changes
  all architectures to use a common table format as used by x86, arm
  and s390 today.

- I have collected all those patches in a git tree [1] for testing.
  This currently has updated system call entry points for 32-bit ARM
  and x86, but no others so far.  The system call numbers *will* change
  before it gets merged, so be careful when building user space based
  on this, but it should be a starting point for testing. I definitely
  expect this to contain bugs still, especially to the end of the series,
  but the start of it should be fairly solid. Some patches are marked
  as work-in-progress or don't contain a proper changelog text. Those
  will still get reworked before a first version is posted to the
  mainling lists.

- There are two notable areas not included in that tree today:
  v4l and socket timestamps. I've had patches for both in the past but
  they need to be reworked.

        Arnd

[1] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=y2038-next
[2] https://docs.google.com/spreadsheets/d/1HCYwHXxs48TsTb6IGUduNjQnmfRvMPzCN6T_0YiQwis/
