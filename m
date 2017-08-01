From: Prakash Sangappa <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [RESEND PATCH v3 0/2] userfaultfd: selftest: Add tests for UFFD_FEATURE_SIGBUS feature
Date: Mon, 31 Jul 2017 21:54:04 -0400
Message-ID: <1501552446-748335-1-git-send-email-prakash.sangappa@oracle.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Resending, Andrew asked if I could resend the whole set.
Just added 'Reviewed-by' to commit log for 1/2, no other
changes.

v3 patch for 2/2 as before
http://marc.info/?l=linux-mm&m=150148267803458&w=2

Previous patch set here:
http://marc.info/?l=linux-mm&m=150095815413275&w=2

Prakash Sangappa (2):
  userfaultfd: Add feature to request for a signal delivery
  userfaultfd: selftest: Add tests for UFFD_FEATURE_SIGBUS feature

 fs/userfaultfd.c                         |    3 +
 include/uapi/linux/userfaultfd.h         |   10 ++-
 tools/testing/selftests/vm/userfaultfd.c |  127 +++++++++++++++++++++++++++++-
 3 files changed, 136 insertions(+), 4 deletions(-)
