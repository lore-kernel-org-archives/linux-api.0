From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Thu, 15 Nov 2018 17:14:54 +0000
Message-ID: <alpine.DEB.2.21.1811151710490.27351@digraph.polyomino.org.uk>
References: <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com> <CAKOZuesta_V=doXsVLc2E6WCQvywdur3F+u2pFKaPN+CEQd+ZQ@mail.gmail.com>
 <alpine.DEB.2.21.1811141741000.16571@digraph.polyomino.org.uk> <CAKOZuetCGCfNdJ2QM0phu3_3Q29f5Yeh=NHiM_A9MhHsCjK48A@mail.gmail.com> <alpine.DEB.2.21.1811141840140.16571@digraph.polyomino.org.uk> <20181115053026.GA20617@thunk.org>
 <alpine.DEB.2.21.1811151628490.27351@digraph.polyomino.org.uk> <20181115170807.GB20617@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181115170807.GB20617@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Daniel Colascione <dancol@google.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Thu, 15 Nov 2018, Theodore Y. Ts'o wrote:

> On Thu, Nov 15, 2018 at 04:29:43PM +0000, Joseph Myers wrote:
> > On Thu, 15 Nov 2018, Theodore Y. Ts'o wrote:
> > 
> > > That's great.  But is it or is it not true (either de jure or de
> > > facto) that "a single active glibc developer" can block a system call
> > > from being supported by glibc by objecting?  And if not, under what is
> > > the process by resolving a conflict?
> > 
> > We use a consensus-building process as described at 
> > <https://sourceware.org/glibc/wiki/Consensus>.
> 
> So can a single glibc developer can block Consensus?

If it's a sustained objection - it still works an awful lot better than 
how things worked before 2011/12.  (See my suggestion of having a process 
involving a supermajority vote of the GNU maintainers for glibc in the 
rare cases where a consensus cannot be reached - but those are rare enough 
that actually agreeing a process for such cases has never been a 
priority.)

-- 
Joseph S. Myers
joseph@codesourcery.com
