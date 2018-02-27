From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: [PATCH 0/3] userfaultfd: non-cooperative: syncronous events
Date: Tue, 27 Feb 2018 10:19:49 +0200
Message-ID: <1519719592-22668-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, crml <criu@openvz.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

Hi,

These patches add ability to generate userfaultfd events so that their
processing will be synchronized with the non-cooperative thread that caused
the event.

In the non-cooperative case userfaultfd resumes execution of the thread
that caused an event when the notification is read() by the uffd monitor.
In some cases, like, for example, madvise(MADV_REMOVE), it might be
desirable to keep the thread that caused the event suspended until the
uffd monitor had the event handled to avoid races between the thread that
caused the and userfaultfd ioctls.

Theses patches extend the userfaultfd API with an implementation of
UFFD_EVENT_REMOVE_SYNC that allows to keep the thread that triggered
UFFD_EVENT_REMOVE until the uffd monitor would not wake it explicitly.

Mike Rapoport (3):
  userfaultfd: introduce userfaultfd_init_waitqueue helper
  userfaultfd: non-cooperative: generalize wake key structure
  userfaultfd: non-cooperative: allow synchronous EVENT_REMOVE

 fs/userfaultfd.c                 | 191 +++++++++++++++++++++++++++++----------
 include/uapi/linux/userfaultfd.h |  14 +++
 2 files changed, 158 insertions(+), 47 deletions(-)

-- 
2.7.4
