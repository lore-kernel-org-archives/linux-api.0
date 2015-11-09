From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/2] selftests/mlock2: Build warning fixes on Debian/m68k 4.0
Date: Mon,  9 Nov 2015 11:14:27 +0100
Message-ID: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>, Thierry Reding <treding@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-api@vger.kernel.org

	Hi,

The following 2 patches are needed to fix build warnings on Debian/m68k
4.0.

However, after wiring up the mlock2 syscall, the test fails with:

# ./mlock2-tests
fread kpageflags: Success
# 

as the fread() call returns 0, not 1.

The original commit description for the test said "Note that the limit
test needs to be run a normal user.". But running it as a non-root user
also fails:

$ ./mlock2-tests 
fopen kpageflags: Permission denied
$ ls -l /proc/kpageflags 
-r-------- 1 root root 0 Nov  9 11:05 /proc/kpageflags
$

What am I missing?

Thanks!

Geert Uytterhoeven (2):
  selftests/mlock2: Add missing #define _GNU_SOURCE
  selftests/mlock2: Add ULL prefix to 64-bit constants

 tools/testing/selftests/vm/mlock2-tests.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
