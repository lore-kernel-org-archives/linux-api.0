From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 5 Dec 2014 09:17:54 +0100
Message-ID: <E1Xwo5O-00GRl4-Cc@intern.SerNet.DE>
References: <cover.1415636409.git.milosz@adfin.com>
 <20141125150101.9596a09e.akpm@linux-foundation.org>
 <CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
 <20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
 <CANP1eJGVyBOt1rQ8jA4tMrNGX5X61-UWbVy6kKj_ByeTqAEOBQ@mail.gmail.com>
 <20141204151102.2d7e11dca39f130c2dff2294@linux-foundation.org>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141204151102.2d7e11dca39f130c2dff2294@linux-foundation.org>
Sender: owner-linux-aio@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 04, 2014 at 03:11:02PM -0800, Andrew Morton wrote:
> I can see all that, but it's handwaving.  Yes, preadv2() will perform
> better in some circumstances than fincore+pread.  But how much better?=20
> Enough to justify this approach, or not?
>=20
> Alas, the only way to really settle that is to implement fincore() and
> to subject it to a decent amount of realistic quantitative testing.
>=20
> Ho hum.
>=20
> Could you please hunt down some libuv developers, see if we can solicit
> some quality input from them?  As I said, we really don't want to merge
> this then find that people don't use it for some reason, or that it
> needs changes.

All I can say from a Samba perspective is that none of the ARM based
Storage boxes I have seen so far do AIO because of the base footprint
for every read. For sequential reads kernel-level readahead could kick
in properly and we should be able to give them the best of both worlds:
No context switches in the default case but also good parallel behaviour
for other workloads.  The most important benchmark for those guys is to
read a DVD image, whether it makes sense or not.

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
