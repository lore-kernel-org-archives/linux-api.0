From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 09:02:51 +0100
Message-ID: <E1YbPEF-0088HN-S8@intern.SerNet.DE>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
 <E1YbN1J-0084qO-3s@intern.SerNet.DE>
 <20150326230833.4ccfaebb.akpm@linux-foundation.org>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150326230833.4ccfaebb.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 11:08:33PM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2015 06:41:25 +0100 Volker Lendecke <Volker.Lendecke@s=
ernet.de> wrote:
>=20
> > On Thu, Mar 26, 2015 at 08:28:24PM -0700, Andrew Morton wrote:
> > > A thing which bugs me about pread2() is that it is specifically
> > > tailored to applications which are able to use a partial read res=
ult.=20
> > > ie, by sending it over the network.
> >=20
> > Can you explain what you mean by this? Samba gets a pread
> > request from a client for some bytes. The client will be
> > confused when we send less than requested although the file
> > is long enough to satisfy all.
>=20
> Well it was my assumption that samba would be able to do something
> useful with a partial read - pread() is allowed to return less than r=
equested.

No, this is not the case. Maybe my whole understanding of
pread is wrong: I always thought that it won't return short
if the file spans the pread range. EINTR nonwithstanding.

> 	if (it's all in cache)

I know I'm repeating myself: We have a race condition here.
A small one, but it is racy. I've seen loaded systems where
we spend seconds between becoming re-scheduled. In these
systems, it will be the norm to block in later reads. And we
don't have a good way to detect this situation afterwards
and turn to threads as a precaution next time.

> 		read it all now
> 	else
> 		ask a worker thread to read it all
>=20

> Bear in mind that these operations involve physical IO and large
> memcpy's.  Yes, a fincore() approach will consume more CPU but the
> additional overhead will be relatively small.

We have to pay this price for every single chunk. Without
oplocks we get 10-byte read requests. This is hard to
swallow for many vendors with small CPUs.

With best regards,

Volker Lendecke

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
