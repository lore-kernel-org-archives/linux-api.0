From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Fri, 25 Oct 2019 23:12:43 +0300
Message-ID: <20191025201242.GA8710@linux.ibm.com>
References: <20191012191602.45649-1-dancol@google.com>
 <20191012191602.45649-4-dancol@google.com>
 <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
 <CAKOZuevUqs_Oe1UEwguQK7Ate3ai1DSVSij=0R=vmz9LzX4k6Q@mail.gmail.com>
 <CALCETrUyq=J37gU-MYXqLdoi7uH7iNNVRjvcGUT11JA1QuTFyg@mail.gmail.com>
 <CAG48ez3P27-xqdjKLqfP_0Q_v9K92CgEjU4C=kob2Ax7=NoZbA@mail.gmail.com>
 <20191023190959.GA9902@redhat.com>
 <20191024090258.GA9802@linux.ibm.com>
 <20191024151054.GJ9902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191024151054.GJ9902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Thu, Oct 24, 2019 at 11:10:54AM -0400, Andrea Arcangeli wrote:
> Hello,
> 
> On Thu, Oct 24, 2019 at 12:02:59PM +0300, Mike Rapoport wrote:
> > That's no the reason that UFFD_FEATURE_EVENT_FORK does not show up in
> > Debian code search, CRIU simply is not there. Debian packages CRIU only in
> > experimental and I believe that's not indexed by the code search.
> > 
> > As for the limitations, the races were fixed, I just forgot to update the
> > wiki. As for the supported memory types and COW pages, these only affect
> > efficiency of post-copy, but not the correctness.
> 
> That's what I was hoping for. If the wiki information is stale and
> there are no races it is totally plausible that it's being actively
> used in production so we need to fix the kernel bug. I was just
> checking because I wasn't sure anymore of the status after I read the
> wiki.
> 
> If the CRIU initialization code that issues the uffd syscall runs as
> global root the ABI breaking permission check from Andy sounds the
> simplest for a short term fix, because it will be unnoticed by any
> production usage with CIRU --lazy-pages.
 
In general, criu can run as non-root, but such use of criu has limitations,
so allowing criu --lazy-pages only for root sounds reasonable as a short
term solution.

> Then later we could add a UFFD_FEATURE_EVENT_FORK2 that will not
> require root permission.

Agree.

> Thanks,
> Andrea
> 

-- 
Sincerely yours,
Mike.
