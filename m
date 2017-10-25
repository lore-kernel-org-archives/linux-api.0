From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/3] userfaultfd: non-cooperative: syncronous events
Date: Wed, 25 Oct 2017 19:19:39 +0300
Message-ID: <1508948382-20951-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

Hi,

These patches add ability to generate userfaultfd events so that their
processing will be synchronized with the non-cooperative thread that caused
the event.

In the non-cooperative case userfaultfd resumes execution of the thread
that caused an event when the notification is read() by the uffd monitor.
In some cases, like, for example, madvise(MADV_REMOVE), it might be
desirable to keep the thread that caused the event suspended until the
uffd monitor had the event handled.

Theses patches extend the userfaultfd API with an implementation of
UFFD_EVENT_REMOVE_SYNC that allows to keep the thread that triggered
UFFD_EVENT_REMOVE until the uffd monitor would not wake it explicitly.

Mike Rapoport (3):
  userfaultfd: introduce userfaultfd_init_waitqueue helper
  userfaultfd: non-cooperative: generalize wake key structure
  userfaultfd: non-cooperative: allow synchronous EVENT_REMOVE

 fs/userfaultfd.c                 | 158 ++++++++++++++++++++++++++++-----------
 include/uapi/linux/userfaultfd.h |  11 +++
 2 files changed, 124 insertions(+), 45 deletions(-)

-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
