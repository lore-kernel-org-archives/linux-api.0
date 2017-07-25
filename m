From: prakash.sangappa@oracle.com
Subject: [PATCH 0/2] userfaultfd: Add feature to request for a signal delivery
Date: Mon, 24 Jul 2017 22:30:20 -0400
Message-ID: <1500949822-949266-1-git-send-email-prakash.sangappa@oracle.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: inux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, rppt@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@parallels.com, mike.kravetz@oracle.com
List-Id: linux-api@vger.kernel.org

From: Prakash Sangappa <prakash.sangappa@oracle.com>

Hi Andrea, Mike,

Here is the patch set for the proposed userfaultfd UFFD_FEATURE_SIGBUS
feature, including tests in selftest/vm/userfaultfd.c

Please review.

See following for previous discussion.

http://www.spinics.net/lists/linux-mm/msg129224.html
http://www.spinics.net/lists/linux-mm/msg130678.html


Thanks,


Prakash Sangappa (2):
  userfaultfd: Add feature to request for a signal delivery
  userfaultfd: selftest: Add tests for UFFD_FREATURE_SIGBUS

 fs/userfaultfd.c                         |    3 +
 include/uapi/linux/userfaultfd.h         |   10 ++-
 tools/testing/selftests/vm/userfaultfd.c |  121 +++++++++++++++++++++++++++++-
 3 files changed, 130 insertions(+), 4 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
