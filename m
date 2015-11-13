From: Daniel Micay <danielmicay@gmail.com>
Subject: Re: [PATCH v3 01/17] mm: support madvise(MADV_FREE)
Date: Fri, 13 Nov 2015 01:45:52 -0500
Message-ID: <56458720.4010400@gmail.com>
References: <1447302793-5376-1-git-send-email-minchan@kernel.org>
 <1447302793-5376-2-git-send-email-minchan@kernel.org>
 <CALCETrWA6aZC_3LPM3niN+2HFjGEm_65m9hiEdpBtEZMn0JhwQ@mail.gmail.com>
 <564421DA.9060809@gmail.com> <20151113061511.GB5235@bbox>
 <56458056.8020105@gmail.com> <20151113063802.GF5235@bbox>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WPFUm5Gj72Qb6xXvdVJKIAmvmmpJe2WhO"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151113063802.GF5235@bbox>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, yalin wang <yalin.wang2010@gmail.com>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WPFUm5Gj72Qb6xXvdVJKIAmvmmpJe2WhO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> And now I am thinking if we use access bit, we could implment MADV_FREE=
_UNDO
> easily when we need it. Maybe, that's what you want. Right?

Yes, but why the access bit instead of the dirty bit for that? It could
always be made more strict (i.e. access bit) in the future, while going
the other way won't be possible. So I think the dirty bit is really the
more conservative choice since if it turns out to be a mistake it can be
fixed without a backwards incompatible change.


--WPFUm5Gj72Qb6xXvdVJKIAmvmmpJe2WhO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWRYcgAAoJEPnnEuWa9fIqh34P/Ag7Y9sG5+idtmJvxE+JI4AN
XLkBfKB5BGcUO80XUs65tXm5y2Qvyom1lUCMjZJvjNFMxr36wReHWe+kbC4sngY0
pGSHCTmWmzzy8GrlBlHv+VmvpkojhNO3FEkQWgIBkDdX4ildyo/Y8aH7HTKIBqxq
OfqJPCmInu3dpoGJ0msj8hVp4yxvq+QfExnZ9O2Ys9WanG+m5H+nnxTuVS6RjGDN
IcgzrEezTXMc87LEzPTny8sni8yLV87piEygepKS3MBiAEnkeB6MnaMm5iufp45h
2JygXJenjk4spr9LZ2L6DjjyIGfkmf5TnmJMLP2RhsikWt+cRKNlEtBWDSWEhHLg
KIoL+QN9QMRqXe+OdfcQVT8rVQRzpiXINA4qJPxcyChr0Vnw5a50EOIZEJjvPOL/
7zdukf541LMVGXeLWGpJ4tyiSQCdgyFqHchkNCltlF4S9EWJNHFVPrrGHWq0PpzK
ducLhHLsLnB7gPEVOn2jwdz8AB/r1xshq8dhsBrYvdHty753oebKWQfwUBRYuG9A
fotX/N/Xdlxx1V9oR3WRR5MJ5Pcch3zUiCqmTntVaVYBK09YNB1P3739Fncu3tOA
N8xtDwfX1FrFGIpcZUUqeJ+5i7f34FG8GT6U95EniCyAOM9eY8TvRAdgt7wFUfKS
UA/u0RHtwXtTQA2TkjBa
=xVCM
-----END PGP SIGNATURE-----

--WPFUm5Gj72Qb6xXvdVJKIAmvmmpJe2WhO--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
