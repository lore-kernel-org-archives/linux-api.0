From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 0/2] selftests/userfaultfd: fix build
Date: Tue, 22 Sep 2015 11:45:54 +0100
Message-ID: <1442918756-17892-1-git-send-email-andre.przywara@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

These two patches fix building the userfaultfd test tool for me.
The first patch fixes a build error I experienced by removing a kernel
header from an uapi header file.
The second fix adds the syscall numbers for other architectures,
fixes a typo and makes the whole syscall numbering more future-proof.

Tested on x86, arm and arm64.

Andre Przywara (2):
  userfaultfd: remove kernel header include from uapi header
  selftests/userfaultfd: improve syscall number definition

 include/uapi/linux/userfaultfd.h         |  2 --
 tools/testing/selftests/vm/userfaultfd.c | 13 ++++++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.5.1
