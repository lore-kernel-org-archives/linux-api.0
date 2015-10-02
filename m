From: Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v4 1/4] mm, documentation: clarify /proc/pid/status VmSwap
 limitations
Date: Fri, 2 Oct 2015 16:56:49 +0200
Message-ID: <560E9B31.6070208@redhat.com>
References: <1443792951-13944-1-git-send-email-vbabka@suse.cz>
 <1443792951-13944-2-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7KP3ftr3XiO8Js2rOWKgRIuJF9CDO4qWg"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443792951-13944-2-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7KP3ftr3XiO8Js2rOWKgRIuJF9CDO4qWg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/02/2015 03:35 PM, Vlastimil Babka wrote:
> The documentation for /proc/pid/status does not mention that the value =
of
> VmSwap counts only swapped out anonymous private pages and not shmem. T=
his is
> not obvious, so document this limitation.
>=20
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Jerome Marchand <jmarchan@redhat.com>




--7KP3ftr3XiO8Js2rOWKgRIuJF9CDO4qWg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWDpsxAAoJEHTzHJCtsuoCt/IIAKHif77cU7ZjriV3cY6EfsAA
32SWUYj0gRvBsEi5Ig4HTG7RRwux95f6U4TQIaqqPWh8jaOx7bx8MyCf5NrMtY9D
zbI9oSbvvByWx185CIQ/uVavqWErxRJFJhNbkKj3nDo7XfOfN1HmBGOfb+8xLvgp
G7YjYq9MdDczx4FdiJM6F6/Z+Joz+AMZCQLICs5grjtgGB/9Yd3RSiWQtD1spoeU
Kbq8MW6Pv0vVSFFQATipyFJZykUKhqrDCqV7WUj+xOdQYi0oIYjNQRzOGuHzJv0c
zBAayqkmbGHruzIzk3JEOyUSk2h7vVdDl0bez3RNPodKWpvIE5RUIvtpBlpcOxo=
=HE6n
-----END PGP SIGNATURE-----

--7KP3ftr3XiO8Js2rOWKgRIuJF9CDO4qWg--
