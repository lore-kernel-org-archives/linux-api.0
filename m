From: Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] tools: selftests cleanup
Date: Tue, 23 Sep 2014 12:03:47 -0700
Message-ID: <1411499027-17801-1-git-send-email-pfeiner@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickens <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A couple of small patches to make working with selftests easier.

Peter Feiner (3):
  tools: add .gitignore entries for selftests
  tools: fix warning in memfd_test
  tools: parallel selftests building & running

 tools/testing/selftests/Makefile               | 49 +++++++++++---------------
 tools/testing/selftests/breakpoints/.gitignore |  1 +
 tools/testing/selftests/efivarfs/.gitignore    |  2 ++
 tools/testing/selftests/memfd/memfd_test.c     |  2 +-
 tools/testing/selftests/ptrace/.gitignore      |  1 +
 tools/testing/selftests/timers/.gitignore      |  1 +
 tools/testing/selftests/user/Makefile          |  2 ++
 tools/testing/selftests/vm/.gitignore          |  9 ++---
 8 files changed, 33 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore
 create mode 100644 tools/testing/selftests/ptrace/.gitignore
 create mode 100644 tools/testing/selftests/timers/.gitignore

-- 
2.1.0.rc2.206.gedb03e5
