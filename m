From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Wed, 3 Dec 2014 10:10:43 +0100
Message-ID: <E1Xw5xg-00EfRs-CM@intern.SerNet.DE>
References: <cover.1415636409.git.milosz@adfin.com>
 <20141125150101.9596a09e.akpm@linux-foundation.org>
 <CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
 <20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
Sender: owner-linux-aio@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 02, 2014 at 02:42:00PM -0800, Andrew Morton wrote:
> The question is whether a simpler approach such as fincore() will be
> sufficient.

For many use cases in Samba, fincore will probably be
enough. But Windows clients become more and more
multi-threaded, so Samba sees multiple parallel active read
requests. Samba's core SMB processing engine is single
threaded, and if due to that race we get blocked, more than
one data stream will be affected. We might make it an option
to use the fincore alternative, but I don't see it as a
default. The default will be the strict threadpool.

With best regards,

Volker Lendecke

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
