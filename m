From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Wed, 23 Oct 2019 20:23:12 -0400
Message-ID: <20191024002312.GB433@redhat.com>
References: <20191012191602.45649-1-dancol@google.com>
 <20191012191602.45649-4-dancol@google.com>
 <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
 <CAKOZuevUqs_Oe1UEwguQK7Ate3ai1DSVSij=0R=vmz9LzX4k6Q@mail.gmail.com>
 <CALCETrUyq=J37gU-MYXqLdoi7uH7iNNVRjvcGUT11JA1QuTFyg@mail.gmail.com>
 <CAG48ez3P27-xqdjKLqfP_0Q_v9K92CgEjU4C=kob2Ax7=NoZbA@mail.gmail.com>
 <20191023190959.GA9902@redhat.com>
 <CAKOZuetKkM=PK2QA8LdXwM8cM8qJvFu4u5bjePWai3XRnHe-pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetKkM=PK2QA8LdXwM8cM8qJvFu4u5bjePWai3XRnHe-pA@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 23, 2019 at 01:05:47PM -0700, Daniel Colascione wrote:
> This is a debate that won't get resolved here. A ton of work has gone
> into namespaces, migration, various cgroup things, and so on, and I
> don't see that work getting torn out.

This is precisely why I thought it was a good idea to support the
non-cooperative use case too even though we had no immediate use for
it.

> Sure they can. Can't we stick processes in a memcg and set a
> memory.high threshold beyond which threads in that cgroup will enter
> direct reclaim on page allocations? I'd call that throttling.

The uffd-wp solution during the throttling can resolve a wrprotect
fault in the parent for every 4k page that has been written to disk
and it'll prioritize writing to disk those userfaults that are
currently blocked. I don't see how you could reach an equivalent
optimal runtime without uffd-wp and just with memcg because the
snapshot process won't have a clue which pages are been duped by the
COWs. The uffd-wp by avoding fork will also avoid more expensive MM
switches during the snapshot.

> This issue *has* to get fixed one way or another.

Sure.
