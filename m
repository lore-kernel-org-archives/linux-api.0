From: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 0/4] Add the ability to get a pidfd on seccomp user notifications
Date: Fri, 24 Jan 2020 01:17:39 -0800
Message-ID: <20200124091743.3357-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, tycho-E0fblnxP3wo@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patchset adds the ability for users of the seccomp user notification API
to receive the pidfd of the process which triggered the notification. It is
an optional feature that users must opt into by setting a flag when they
call the ioctl. With enhancements to other APIs, it should decrease
the need for the cookie-checking mechanism.

Sargun Dhillon (4):
  pid: Add pidfd_create_file helper
  fork: Use newly created pidfd_create_file helper
  seccomp: Add SECCOMP_USER_NOTIF_FLAG_PIDFD to get pidfd on listener
    trap
  selftests/seccomp: test SECCOMP_USER_NOTIF_FLAG_PIDFD

 include/linux/pid.h                           |   1 +
 include/uapi/linux/seccomp.h                  |   4 +
 kernel/fork.c                                 |   4 +-
 kernel/pid.c                                  |  22 ++++
 kernel/seccomp.c                              |  68 ++++++++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 110 ++++++++++++++++++
 6 files changed, 200 insertions(+), 9 deletions(-)

-- 
2.20.1
