From: Daniel Micay <danielmicay@gmail.com>
Subject: Re: [PATCH v2 01/13] mm: support madvise(MADV_FREE)
Date: Thu, 5 Nov 2015 15:13:09 -0500
Message-ID: <563BB855.6020304@gmail.com>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <1446600367-7976-2-git-send-email-minchan@kernel.org>
 <CALCETrUuNs=26UQtkU88cKPomx_Bik9mbgUUF9q7Nmh1pQJ4qg@mail.gmail.com>
 <56399CA5.8090101@gmail.com>
 <CALCETrU5P-mmjf+8QuS3-pm__R02j2nnRc5B1gQkeC013XWNvA@mail.gmail.com>
 <563A813B.9080903@gmail.com> <20151105181726.GA63566@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ClqICLLTDgILX9WnJ236tnF4v7NNE29Gh"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151105181726.GA63566@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux API <linux-api@vger.kernel.org>, Jason Evans <je@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, yalin wang <yalin.wang2010@gmail.com>, Mel Gorman <mgorman@suse.de>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ClqICLLTDgILX9WnJ236tnF4v7NNE29Gh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> I posted a patch doing exactly iovec madvise. Doesn't support MADV_FREE=
 yet
> though, but should be easy to do it.
>=20
> http://marc.info/?l=3Dlinux-mm&m=3D144615663522661&w=3D2

I think that would be a great way to deal with this. It keeps the nice
property of still being able to drop pages in allocations that have been
handed out but not yet touched. The allocator just needs to be designed
to do lots of purging in one go (i.e. something like an 8:1 active:clean
ratio triggers purging and it goes all the way to 16:1).


--ClqICLLTDgILX9WnJ236tnF4v7NNE29Gh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWO7hZAAoJEPnnEuWa9fIq5usQAI/qFzkBpBjxnmiLTb8sPPzm
OUZp6yZi5bjcreflXXxsvufHbOZ1zqkVFe8JnxGn+Pg1chYSEm4xRUyK/9LCchqR
1Be3avsVfUPJGuiRrHnrY6Qq46Vmk2Iu6HaY8vgkmN/c/qMifY8PgADPQ+RPJ7Du
yNkm1kpBoxoYnKu5X2QCfQU6G8TJGCUA+nuqalvNPSqySHAfl5slAXvLJUFc42gg
CENG0PWWsPQXbPQGYP3CAuKxMW+hNw7YnG5J2SYyncjnviVfjdoo1aIgINkRokY9
z5CtxU3EEI7B5H8qPWiRe6i/2/JLUMlnixEVsTyh4Nr1yLNYP43jCeH+/+CKIiQK
ABOcnjPBfqEiHbzF5V1DOOUbzOBDiM0TonVgfUPhX3+IY7Dbm73d+ErX98fJmPI2
EufQaD6ZN+KcUj8lWR1pBACzC7wUUn86HJYLuHFv3hbmMqVKDlOiV5C7KIpJ0+nD
foQeyiwxoIJNiSAkIv/Y764IVrWo6S3z7U8sTHUeF+E3YMnl6uOngySG/Arwiynl
PeswqHKYi/LDF2sEYlFGYeQRF+yCQ2cTqiVZcl1mhkDJjhZt2goiY0pzxb36/XZo
HKwGEAruCW+aDAt5aXzjylzU6kPkWiuwZh8BBZ/Ya7bMrPcgxV0AqZGWvnTb3m4/
+dwvdZaiiHv8o6jEcXy+
=X40y
-----END PGP SIGNATURE-----

--ClqICLLTDgILX9WnJ236tnF4v7NNE29Gh--
