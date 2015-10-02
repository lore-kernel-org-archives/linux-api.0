From: Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v4 2/4] mm, proc: account for shmem swap in
 /proc/pid/smaps
Date: Fri, 2 Oct 2015 17:00:21 +0200
Message-ID: <560E9C05.2030807@redhat.com>
References: <1443792951-13944-1-git-send-email-vbabka@suse.cz>
 <1443792951-13944-3-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1u0lcuBlVInXJWOwELmlikb1anvCAvrGl"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1443792951-13944-3-git-send-email-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1u0lcuBlVInXJWOwELmlikb1anvCAvrGl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/02/2015 03:35 PM, Vlastimil Babka wrote:
> Currently, /proc/pid/smaps will always show "Swap: 0 kB" for shmem-back=
ed
> mappings, even if the mapped portion does contain pages that were swapp=
ed out.
> This is because unlike private anonymous mappings, shmem does not chang=
e pte
> to swap entry, but pte_none when swapping the page out. In the smaps pa=
ge
> walk, such page thus looks like it was never faulted in.
>=20
> This patch changes smaps_pte_entry() to determine the swap status for s=
uch
> pte_none entries for shmem mappings, similarly to how mincore_page() do=
es it.
> Swapped out pages are thus accounted for.
>=20
> The accounting is arguably still not as precise as for private anonymou=
s
> mappings, since now we will count also pages that the process in questi=
on never
> accessed, but only another process populated them and then let them bec=
ome
> swapped out. I believe it is still less confusing and subtle than not s=
howing
> any swap usage by shmem mappings at all. Also, swapped out pages only b=
ecomee a
> performance issue for future accesses, and we cannot predict those for =
neither
> kind of mapping.

Agreed, this is much better than the current situation. I don't think
there is such a thing as a perfect accounting of shared pages anyway.

>=20
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Acked-by: Jerome Marchand <jmarchan@redhat.com>




--1u0lcuBlVInXJWOwELmlikb1anvCAvrGl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWDpwFAAoJEHTzHJCtsuoCTXEIAKZfIObBQ8Z0CI/KQ+DDVYh+
5miYBipTa7OtygOj2MqZijOBq4Clb0laZKImXBsdvC3bBTcRcc/w3wv0KOO+isVd
nciL6CDeonlDyM7ZFkcHuK0XbEVLD4npknbqjG7jhRAoyvsUoPI7BwYDKrBdA1vf
gPSVlX4ralcMseKO7lAIvEHy9HhtTP0u8U9uUpNAyIDzc4L1sONWWD3o262rW8Xx
esZJhJxh6rP9YoICBOMl5e6/j0XKoeIEnEfFFbGhbZzfIhGpz7pO/uTZzSZBgYpz
G1lOFjgnYnXVGwnT1/TQ68TB7wJBN0Ka2EtDL9L3yQ61NdVaFHz8bC1nO2nLfTM=
=PbMz
-----END PGP SIGNATURE-----

--1u0lcuBlVInXJWOwELmlikb1anvCAvrGl--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
