From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Official Linux system wrapper library?
Date: Thu, 15 Nov 2018 00:30:26 -0500
Message-ID: <20181115053026.GA20617@thunk.org>
References: <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com>
 <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com>
 <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
 <CAKOZuesta_V=doXsVLc2E6WCQvywdur3F+u2pFKaPN+CEQd+ZQ@mail.gmail.com>
 <alpine.DEB.2.21.1811141741000.16571@digraph.polyomino.org.uk>
 <CAKOZuetCGCfNdJ2QM0phu3_3Q29f5Yeh=NHiM_A9MhHsCjK48A@mail.gmail.com>
 <alpine.DEB.2.21.1811141840140.16571@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1811141840140.16571@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Daniel Colascione <dancol@google.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 14, 2018 at 06:47:57PM +0000, Joseph Myers wrote:
> On Wed, 14 Nov 2018, Daniel Colascione wrote:
> 
> > A good demonstration of a new commitment to pragmatism would be
> > merging the trivial wrappers for gettid(2).
> 
> I support the addition of gettid (for use with those syscalls that take 
> tids, and with appropriate documentation explaining the properties of 
> tids) - and, generally, wrappers for all non-obsolescent 
> architecture-independent Linux kernel syscalls, including ones that are 
> very Linux-specific, except maybe for a few interfaces fundamentally 
> inconsistent with glibc managing TLS etc. - they are, at least, no worse 
> as a source of APIs than all the old BSD / SVID interfaces we have from 
> when those were used as sources of APIs.

That's great.  But is it or is it not true (either de jure or de
facto) that "a single active glibc developer" can block a system call
from being supported by glibc by objecting?  And if not, under what is
the process by resolving a conflict?

						- Ted
