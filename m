From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 18:15:30 +0000
Message-ID: <alpine.DEB.2.21.1811141741000.16571@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com> <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
 <CAKOZuesta_V=doXsVLc2E6WCQvywdur3F+u2pFKaPN+CEQd+ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuesta_V=doXsVLc2E6WCQvywdur3F+u2pFKaPN+CEQd+ZQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Wed, 14 Nov 2018, Daniel Colascione wrote:

> > there is a lot of bikesheding here by people who
> > don't understand the constraints nor the use-cases.
> 
> Conversely, there's a lot of doubt-sowing from the other side that

"other side" is the wrong concept here in the first place - it's supposed 
to be a matter of cooperating projects trying to find good interfaces 
together.

Any new feature from the kernel that is meant to be of use to libcs is 
best designed in a way involving such cooperation (with multiple libcs).  
I concur with Zack's assessment in 
<https://sourceware.org/ml/libc-alpha/2018-11/msg00286.html> that a 
technical fix to process / communication issues cannot work here.  Any 
feature (e.g. syscall library) with a design coming solely from the kernel 
rather than a cooperative process is also likely to have an unsuitable 
design meaning it doesn't get used.  Once we have sufficient communication 
to design suitable interfaces *together*, "avoiding the need to 
communicate" becomes irrelevant as a design criterion anyway.

> After looking at the history of settid, signal multi-handler
> registration, and other proposed improvements running into the brick
> wall of glibc's API process, I think it's clear that requiring glibc
> signoff on new kernel interfaces would simply lead to stagnation. It's

That there was disagreement on some particular interface does not mean 
there are problems with the basic principle of working with libc 
maintainers (of multiple libcs, not just one!) to establish what the 
intended userspace C API to some new kernel interface should be, and to 
nail down the details of how the kernel interface is defined in the 
process.

(And as noted elsewhere, I think the main people objecting to generally 
having bindings for all non-obsolescent syscalls are no longer active in 
glibc.)

If the semantics of some proposed kernel interface, both at the syscall 
level and at the userspace C API level, are agreed e.g. by kernel and musl 
people, I'd think the API agreement from musl would be a good indication 
of the API also being suitable to add to glibc.  It's not necessary to get 
agreement from every libc on every API - but there should be agreement 
from *some* libc that is careful about API review.  If enough people with 
good sense about libc APIs have judged some API for a new syscall 
suitable, I expect other libcs can implement it even if it's not exactly 
the API they'd come up with themselves.

(I haven't seen enough comments on libc / kernel API design from people I 
know to be associated with bionic, uclibc-ng, etc., to judge if they also 
pay similarly careful attention to working out what a good C API design 
for some interface should be.  Note that there are musl people active on 
libc-alpha, which helps everyone arrive at a consensus on better C API 
designs.)

> The right answer is a move to an approximation of the BSD model and
> bring the primary interface layer in-house.

I could equally say we should take the kernel in-house and develop it to 
better support glibc - that if the kernel doesn't provide what we want, we 
should add the features to GNU Linux-libre and say that's the supported 
kernel for use with glibc.  It's an equally absurd statement in a context 
of multiple cooperating projects.

>  There's a lot of evidence that this model works.

There's a lot of evidence that the model of separately maintained Linux 
kernel and libc works (see: the number of devices using Linux kernels with 
a range of different libc implementations that meet different needs).

-- 
Joseph S. Myers
joseph@codesourcery.com
