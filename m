From: Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] asm-generic: bugfix for asm/unistd.h
Date: Sat, 8 Dec 2018 17:01:30 +0100
Message-ID: <CAK8P3a20S++xEHTYXXuipZ+YUZc0_EY2bj0JmaDwWdgWoLTROA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guo Ren <ren_guo@c-sky.com>, Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

The following changes since commit 2e6e902d185027f8e3cb8b7305238f7e35d6a436:

  Linux 4.20-rc4 (2018-11-25 14:19:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
tags/asm-generic-4.20

for you to fetch changes up to b7d624ab431227af376787148cd7d474088c03aa:

  asm-generic: unistd.h: fixup broken macro include. (2018-12-06 16:57:47 +0100)

----------------------------------------------------------------
asm-generic: bugfix for asm/unistd.h

Multiple people reported a bug I introduced in asm-generic/unistd.h
in 4.20, this is the obvious bugfix to get glibc and others to
correctly build again on new architectures that no longer provide
the old fstatat64() family of system calls.

----------------------------------------------------------------
Guo Ren (1):
      asm-generic: unistd.h: fixup broken macro include.

 include/uapi/asm-generic/unistd.h | 4 ++++
 1 file changed, 4 insertions(+)
