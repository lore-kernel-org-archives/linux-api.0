From: Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 00/20] Fix handling of compat_siginfo_t
Date: Thu,  5 Nov 2015 00:50:19 +0000
Message-ID: <1446684640-4112-1-git-send-email-amanieu@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The current handling of compat_siginfo_t is a mess: each architecture has its
own implementation, all of which are incorrect in different ways. This patch
series replaces all of the arch-specific versions with a single generic one that
is guaranteed to produce the same results as a 32-bit kernel.

Most architectures are able to use the generic compat_siginfo_t, except x86 and
MIPS. MIPS uses a slightly different compat_siginfo_t structure for ABI reasons
but can still use the generic copy_siginfo_{to,from}_user32. x86 can't use the
generic versions because it needs special handling for __SI_CHLD for x32 tasks.

One issue that isn't resolved in this series is sending signals between a 32-bit
process and 64-bit process. Sending a si_int will work correctly, but a si_ptr
value will likely get corrupted due to the different layouts of the 32-bit and
64-bit siginfo_t structures.

signalfd_copyinfo was also modified to properly generate data for compat tasks.
In particular the ssi_ptr and ssi_data members need to be sign-extended to 64
bits rather than zero-extended, since that is the behavior in 32-bit kernels.

This series has been tested on x86_64 and arm64.

Changes since v1:
- Properly copy padding bytes and avoid leaking uninitialized data to userspace
- Fixed compile errors on mips and powerpc
- Fixed some compiler warnings
- Fixed some formatting issues

Amanieu d'Antras (20):
  compat: Add generic compat_siginfo_t
  compat: Add generic copy_siginfo_{to,from}_user32
  x86: Update compat_siginfo_t to be closer to the generic version
  x86: Rewrite copy_siginfo_{to,from}_user32
  mips: Clean up compat_siginfo_t
  mips: Use generic copy_siginfo_{to,from}_user32
  arm64: Use generic compat_siginfo_t
  arm64: Use generic copy_siginfo_{to,from}_user32
  parisc: Use generic compat_siginfo_t
  parsic: Use generic copy_siginfo_{to,from}_user32
  s390: Use generic compat_siginfo_t
  s390: Use generic copy_siginfo_{to,from}_user32
  powerpc: Use generic compat_siginfo_t
  powerpc: Use generic copy_siginfo_{to,from}_user32
  tile: Use generic compat_siginfo_t
  tile: Use generic copy_siginfo_{to,from}_user32
  sparc: Use generic compat_siginfo_t
  sparc: Use generic copy_siginfo_{to,from}_user32
  signalfd: Fix some issues in signalfd_copyinfo
  signal: Remove unnecessary zero-initialization of siginfo_t

 arch/arm64/include/asm/compat.h    |  59 --------
 arch/arm64/kernel/signal32.c       |  85 -----------
 arch/mips/include/asm/compat.h     |  63 ++++----
 arch/mips/kernel/signal32.c        |  62 --------
 arch/parisc/include/asm/compat.h   |  52 -------
 arch/parisc/kernel/signal32.c      | 102 -------------
 arch/powerpc/include/asm/compat.h  |  60 --------
 arch/powerpc/kernel/signal_32.c    |  72 +---------
 arch/s390/include/asm/compat.h     |  51 -------
 arch/s390/kernel/compat_signal.c   | 102 -------------
 arch/sparc/include/asm/compat.h    |  54 -------
 arch/sparc/kernel/signal32.c       |  69 ---------
 arch/tile/include/asm/compat.h     |  57 --------
 arch/tile/kernel/compat_signal.c   |  75 ----------
 arch/x86/include/asm/compat.h      |  39 +++--
 arch/x86/kernel/signal_compat.c    | 285 ++++++++++++++++++++++++++++---------
 fs/signalfd.c                      |  58 +++++---
 include/linux/compat.h             |  66 ++++++++-
 include/uapi/asm-generic/siginfo.h |   1 +
 kernel/compat.c                    | 224 +++++++++++++++++++++++++++++
 kernel/ptrace.c                    |   1 -
 kernel/signal.c                    |  16 ++-
 22 files changed, 615 insertions(+), 1038 deletions(-)

-- 
2.6.2
