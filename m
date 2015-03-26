From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Wed, 25 Mar 2015 23:24:54 -0400
Message-ID: <55137C06.9020608@gmail.com>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com> <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org> <550A5FF8.90504@gmail.com> <CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com> <550E6D9D.1060507@gmail.com> <5512E0C0.6060406@suse.cz> <55131F70.7020503@gmail.com> <alpine.DEB.2.10.1503251710400.31453@chino.kir.corp.google.com> <551351CA.3090803@gmail.com> <alpine.DEB.2.10.1503251914260.16714@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oR20fIOVQhEga68KfGXn2R1PPE7wOXKqr"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1503251914260.16714-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oR20fIOVQhEga68KfGXn2R1PPE7wOXKqr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

It's all well and good to say that you shouldn't do that, but it's the
basis of the design in jemalloc and other zone-based arena allocators.

There's a chosen chunk size and chunks are naturally aligned. An
allocation is either a span of chunks (chunk-aligned) or has metadata
stored in the chunk header. This also means chunks can be assigned to
arenas for a high level of concurrency. Thread caching is then only
necessary for batching operations to amortize the cost of locking rather
than to reduce contention. Per-CPU arenas can be implemented quite well
by using sched_getcpu() to move threads around whenever it detects that
another thread allocated from the arena.

With >=3D 2M chunks, madvise purging works very well at the chunk level
but there's also fine-grained purging within chunks and it completely
breaks down from THP page faults.

The allocator packs memory towards low addresses (address-ordered
best-fit and first-fit can both be done in O(log n) time) so swings in
memory usage will tend to clear large spans of memory which will then
fault in huge pages no matter how it was mapped. Once MADV_FREE can be
used rather than MADV_DONTNEED, this would only happen after memory
pressure... but that's not very comforting.

I don't find it acceptable that programs can have huge (up to ~30% in
real programs) amounts of memory leaked over time due to THP page
faults. This is a very real problem impacting projects like Redis,
MariaDB and Firefox because they all use jemalloc.

https://shk.io/2015/03/22/transparent-huge-pages/
https://www.percona.com/blog/2014/07/23/why-tokudb-hates-transparent-huge=
pages/
http://dev.nuodb.com/techblog/linux-transparent-huge-pages-jemalloc-and-n=
uodb
https://bugzilla.mozilla.org/show_bug.cgi?id=3D770612

Bionic (Android's libc) switched over to jemalloc too.

The only reason you don't hear about this with glibc is because it
doesn't have aggressive, fine-grained purging and a low fragmentation
design in the first place.


--oR20fIOVQhEga68KfGXn2R1PPE7wOXKqr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVE3wGAAoJEPnnEuWa9fIqSV8P/29XSFavaqyeKaD+HjVzjgY4
WP97K4PpxvxcYQif3FNlpS4N8j7L4dutdJoyhkjkD6R+1TVulVibbwOvQ9QNxq7E
rJL+qIcC8Y01SQEaEFQzjgxugJjq+N4t7NL+etkytsLtirSN7cJkJ70CAM6baCq8
7zHziRo5ti3tUhw12PSJeQ4gTIG+RkZmvUaIwD7WdE1J2l5XCXAQIwor2OaCuAkk
DuRUH3JBN/DzAcIB6/xnm3AIsZZ1I0T/rcqYUF8WsP9aaYpH3F58Uk9GdZ5nFUer
x3tsWsjvuSySQsCR3oMFCVRGoY/dsk4fEmwH6AgxQRuT6mNCqwUiSLkw22xgOx0W
z/DTJXTyAV8SDAAYDHnUJvt/bcp/ES5ani15v+kjT0q64eT0B3CADeqXy/hih+Qg
gJ40c22lRUo/jFKN7hanmV5nMofc88qnKepUmRPGucSG/ALQ9go/NB7vpeVqowB0
J7fqMS1Ss7M1uDE/pbu3AikNN3Xh4wJaAVv2QJqDpM8QJg46OGdJKWsUAmLUvbrX
6k3EOhAav3GM1l3fCk6/dvZvyTbLpFBvW5Fs9WC2nnBvceiqE4Og+yFdJfJv4ZMg
VNgbYlll0QfM8Ht2N+KKJynxD/YRZDWxEAStXpAG5s7wjygS0NFJx/0FL2o+3zb7
pOEW5E7IIl9fBBUdtEFn
=AX0U
-----END PGP SIGNATURE-----

--oR20fIOVQhEga68KfGXn2R1PPE7wOXKqr--
