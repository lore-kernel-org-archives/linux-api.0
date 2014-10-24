From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Date: Fri, 24 Oct 2014 14:56:39 +0100
Message-ID: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, serban.constantinescu-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently, the arm64 /proc/cpuinfo format differs from that of arm, in a
manner which prevents some otherwise portable applications from
functioning as expected. Specifically, the "Features" line describes the
64-bit hwcaps exclusive of the 32-bit hwcaps, which causes issues for
certain applications which attempt to parse /proc/cpuinfo to detect
features rather than directly using the hwcaps exposed via auxval.

Additionally, the arm64 /proc/cpuinfo format only provides identifying
information for a single CPU (unlike 32-bit), which is problematic for
systems with heterogeneous CPUs (i.e. big.LITTLE).

This patch attempts to solve both issues. I believe the contentious part
is what to do with the Features line, and for that there are a number of
possibilities:

[a] Only print the 64-bit hwcaps

    This would match our current behaviour. However certain 32-bit
    applications will not detect CPU features correctly, and could fail
    to launch. The appropriate hwcaps are available in auxval, but this
    will not be of help to existing binaries.

[b] Append the 64-bit and 32-bit hwcaps

    This would allow for a consistent format. However, some
    human-readable hwcap names have been reused for analogous
    instruction set features (e.g. "aes") despite 32-bit and 64-bit
    instruction set support being largely unrelated per the
    architecture. This could lead to applications mis-detecting
    instruction set support on some CPUs in future, and may be
    misleading to a casual reader.

[c] Print different hwcaps for compat tasks

    This would allow for 32-bit and 64-bit applications to function
    correctly. Having the format differ depending on the instruction set
    of the application reading /proc/cpuinfo may be misleading in some
    cases (e.g. a human using a 32-bit cat to read /proc/cpuinfo on a
    64-bit system).

[d] Print different hwcaps dependent on the personality.

    This would allow for 32-bit and 64-bit applications to function
    correctly, but for some 32-bit applications the personality would
    need to be set explicitly by the user.

This patch takes approach d, aligning with what we do for
COMPART_UTS_NAME and COMPAT_ELF_PLATFORM function. Below are sample
output on a 32-bit platform and a 64-bit platform before and after this
patch (with and without LINUX32 personality).

Does it sound reasonable for the /proc/cpuinfo format to vary depending
on the task or personality?

Are there applications for which any of these strategies will not work?

Thanks,
Mark.

[1] arm, v3.17, Versatile Express A15x2 A7x3 coretile
---->8----
processor       : 0
model name      : ARMv7 Processor rev 1 (v7l)
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc0f
CPU revision    : 1

processor       : 1
model name      : ARMv7 Processor rev 1 (v7l)
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc0f
CPU revision    : 1

processor       : 2
model name      : ARMv7 Processor rev 1 (v7l)
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x0
CPU part        : 0xc07
CPU revision    : 1

processor       : 3
model name      : ARMv7 Processor rev 1 (v7l)
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x0
CPU part        : 0xc07
CPU revision    : 1

processor       : 4
model name      : ARMv7 Processor rev 1 (v7l)
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x0
CPU part        : 0xc07
CPU revision    : 1

Hardware        : ARM-Versatile Express
Revision        : 0000
Serial          : 0000000000000000
----8<----

[2] arm64, v3.17, Juno platform
---->8----
Processor       : AArch64 Processor rev 0 (aarch64)
processor       : 0
processor       : 1
processor       : 2
processor       : 3
processor       : 4
processor       : 5
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 
CPU implementer : 0x41
CPU architecture: AArch64
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

Hardware        : Juno
----8<----

[3] arm64, v3.17 + this patch, Juno platform
---->8----
processor       : 0
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 1
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 2
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 3
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 4
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd07
CPU revision    : 0

processor       : 5
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd07
CPU revision    : 0
----8<----

[4] arm64, v3.17 + this patch, Juno platform, LINUX32 personality
---->8----
processor       : 0
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 1
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 2
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 3
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 0

processor       : 4
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd07
CPU revision    : 0

processor       : 5
Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt evtstrm aes pmull sha1 sha2 crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd07
CPU revision    : 0
----8<----

Mark Rutland (1):
  arm64: Fix up /proc/cpuinfo

 arch/arm64/kernel/setup.c | 96 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 72 insertions(+), 24 deletions(-)

-- 
1.9.1
