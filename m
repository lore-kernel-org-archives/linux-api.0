From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 10:44:09 +0100
Message-ID: <E1YbQoP-008C4F-TU@intern.SerNet.DE>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
 <20150327081822.GA28669@infradead.org>
 <20150327013516.8c6788be.akpm@linux-foundation.org>
 <20150327084833.GA7689@infradead.org>
 <20150327020159.eadd0ce1.akpm@linux-foundation.org>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150327020159.eadd0ce1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 27, 2015 at 02:01:59AM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2015 01:48:33 -0700 Christoph Hellwig <hch@infradead.o=
rg> wrote:
>=20
> > On Fri, Mar 27, 2015 at 01:35:16AM -0700, Andrew Morton wrote:
> > > fincore() doesn't have to be ugly.  Please address the design iss=
ues I
> > > raised.  How is pread2() useful to the class of applications whic=
h
> > > cannot proceed until all data is available?
> >=20
> > It actually makes them work correctly?  preadv2( ..., DONTWAIT) wil=
l
> > return -EGAIN, which causes them to bounce to the threadpool where
> > they call preadv(...).
>=20
> (I assume you mean RWF_NONBLOCK)
>=20
> That isn't how pread2() works.  If the leading one or more pages are
> uptodate, pread2() will return a partial read.  Now what?  Either the
> application reads the same data a second time via the worker thread
> (dumb, but it will usually be a rare case) or it reads the remainder =
of
> the data in the worker thread and splices the data back together.=20
> Which, as I said, will often result in a second load of the initial
> read result into CPU cache.

Sorry, but I don't have a good picture how we are supposed
to use that. I'm fine with two syscalls, but I need a way to
tell the kernel to either block or not. Or do you want Samba
to do repeated pread calls for ever shorter blocks? Right
now I don't see a way to tell pread to either give me a
short result or really block. To me that's the core of
preadv2. I'm perfectly find for a syscall to give me a short
read instead of a global EWOULDBLOCK. I need a way to tell
the kernel which behaviour I want.

Volker

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
