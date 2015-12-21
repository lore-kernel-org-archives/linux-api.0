From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH v1 0/4] um: Add seccomp support
Date: Mon, 21 Dec 2015 01:03:25 +0100
Message-ID: <1450656209-2676-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.o>
List-Id: linux-api@vger.kernel.org

This series add seccomp support to User-mode Linux (i386 and x86_64
subarchitectures) and fix ptrace issues. This apply on v4.4-rc4 and pas=
s all
the 48 tests from selftest/seccomp.

Regards,
 Micka=C3=ABl

Micka=C3=ABl Sala=C3=BCn (4):
  um: Fix ptrace GETREGS/SETREGS bugs
  selftests/seccomp: Remove the need for HAVE_ARCH_TRACEHOOK
  um: Add full asm/syscall.h support
  um: Add seccomp support

 .../seccomp/seccomp-filter/arch-support.txt        |   2 +-
 arch/um/Kconfig.common                             |   1 +
 arch/um/Kconfig.um                                 |  16 +++
 arch/um/include/asm/syscall-generic.h              | 138 +++++++++++++=
++++++++
 arch/um/include/asm/thread_info.h                  |   2 +
 arch/um/kernel/skas/syscall.c                      |  16 ++-
 arch/um/os-Linux/skas/process.c                    |   7 --
 arch/x86/um/asm/syscall.h                          |   1 +
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  27 +++-
 9 files changed, 198 insertions(+), 12 deletions(-)
 create mode 100644 arch/um/include/asm/syscall-generic.h

--=20
2.6.4
