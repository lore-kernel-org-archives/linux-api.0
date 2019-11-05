From: Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH 0/1] userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK
Date: Tue,  5 Nov 2019 17:29:36 +0200
Message-ID: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

Hi,

A while ago Andy noticed [1] that UFFD_FEATURE_EVENT_FORK used by an
unprivileged user may have security implications.

As the first step of the solution the following patch limits the
availably of UFFD_FEATURE_EVENT_FORK only for those having CAP_SYS_PTRACE.

The usage of CAP_SYS_PTRACE ensures compatibility with CRIU.

Yet, if there are other users of non-cooperative userfaultfd that run
without CAP_SYS_PTRACE, they would be broken :(

[1] https://lore.kernel.org/lkml/CALCETrWY+5ynDct7eU_nDUqx=okQvjm=Y5wJvA4ahBja=CQXGw@mail.gmail.com

Mike Rapoport (1):
  userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK

 fs/userfaultfd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

-- 
2.7.4
