From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 06:41:25 +0100
Message-ID: <E1YbN1J-0084qO-3s@intern.SerNet.DE>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150326202824.65d03787.akpm@linux-foundation.org>
Sender: owner-linux-aio@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 08:28:24PM -0700, Andrew Morton wrote:
> A thing which bugs me about pread2() is that it is specifically
> tailored to applications which are able to use a partial read result.=20
> ie, by sending it over the network.

Can you explain what you mean by this? Samba gets a pread
request from a client for some bytes. The client will be
confused when we send less than requested although the file
is long enough to satisfy all.

> And of course fincore could be used by Samba etc to avoid blocking on
> reads.  It wouldn't perform quite as well as pread2(), but I bet it's
> good enough.
>=20
> Bottom line: with pread2() there's still a need for fincore(), but with
> fincore() there probably isn't a need for pread2().

fincore would be a second syscall per pread, and it is not
atomic. I've had discussions with MIPS based vendors who
are worried about every single syscall. This is the #1
hottest code path in Samba.

> And I'm doubtful about claims that it absolutely has to be non-blocking
> 100% of the time.  I bet that 99.99% is good enough.  A fincore()
> option to run mark_page_accessed() against present pages would help
> with the race-with-reclaim situation.

If you can make sure that after an fincore the pages remain
in memory for x milliseconds the atomicity concern might go
away.

Volker

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=3Dmailto:"aart@kvack.org">aart@kvack.org</a>
