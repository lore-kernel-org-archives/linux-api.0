From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/1] ipc,mqueue: Delete bogus overflow check
Date: Fri, 10 Jul 2015 22:59:06 -0400
Message-ID: <55A0867A.1060202@redhat.com>
References: <20150622222546.GA32432@ramsey.localdomain> <1435211229.11852.23.camel@stgolabs.net> <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com> <1435256484.11852.30.camel@stgolabs.net> <20150706154928.GA19828@ramsey.localdomain> <1436575691.27924.53.camel@stgolabs.net> <20150711020300.GH17109@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fqpFLwmo1NmRrIGXGPPPXMJ9GrE463b1L"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150711020300.GH17109-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fqpFLwmo1NmRrIGXGPPPXMJ9GrE463b1L
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/10/2015 10:03 PM, Al Viro wrote:
> On Fri, Jul 10, 2015 at 05:48:11PM -0700, Davidlohr Bueso wrote:
>> Mathematically, returning -EOVERFLOW in mq_attr_ok()
>> cannot occur under this condition:
>>
>>        mq_treesize =3D attr->mq_maxmsg * sizeof(struct msg_msg) +
>> 	       min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
>> 	       sizeof(struct posix_msg_tree_node);
>>        total_size =3D attr->mq_maxmsg * attr->mq_msgsize;
>>        if (total_size + mq_treesize < total_size)
>> 	       return -EOVERFLOW;
>=20
> A proof would be nice.  More detailed one than "cannot occur", that is.=

>=20
> 	Condition in question is basically mq_treesize < 0 or
> total_size + mq_treesize (in natural numbers) > 2^BITS_PER_LONG.
> Now, the maximal values of ->mq_maxmsg and ->mq_msgsize are 2^16 and
> 2^24 resp. and we are guaranteed that their product is below 2^BITS_PER=
_LONG.
> For mq_treesize we are guaranteed that it's below 2^31.  Now, on a 64bi=
t
> box that would suffice to avoid overflow - the product is at most 2^40 =
and
> its sum with mq_treesize can't wrap around.
>=20
> For 32bit system, though...  Suppose attr->mq_maxmsg =3D=3D 65535 and
> attr->mq_msgsize =3D=3D 65537.  Their product *is* below 2^BITS_PER_LON=
G - it's
> exactly 1 less than that.  _Any_ non-zero value for mq_tresize (and it
> will be non-zero in the above) will lead to wraparound.
>=20
> Looks like a counterexample to your assertion above...
>=20

I'm pretty sure you're right.  The above looks like an example of "Gee,
we need to protect against signed wrap around.  Wait, it's unsigned, no
worries." when in fact unsigned will wrap around too if the total
exceeds the maximum (it just wraps to a small positive value instead of
a large negative value).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--fqpFLwmo1NmRrIGXGPPPXMJ9GrE463b1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVoIZ6AAoJELgmozMOVy/d01kP/3GLwmtZAaBt+PtNVOeszV3W
4Mm4XpWqUQ7G5vMfsGNa+r+Y7WfHdOFTAGTu+e88JXkf0i+xDIkMhVjnhT8gsYnl
CpyZyYSzgBC646jTXX3efuFeAxb/NonnJq+/rBV3gWdJnvdxrknIfHm7skg/0fZs
+cJZdSnAZ02GfwEw+ibjSjdF65q2jpOmD3mMsnvbAXZMnqsFVCoATyaMz+SxUqMj
qsMbh2S2CMgWdYDkvQj7R1DAlTmhrb4jG5FCb90QKGviQig7DhNTCWtd2ZRNDp4C
vYbA9yo3+VLhdbzEZWtP4YVg2/oFBBJk3IVtia8WLSeuJYPliFBA1r8efmD9qMnk
q3IkOdpyFto12gc+zpBHi85jUSKeA/2zBDjymY2bVImkiWQWlgOCkl9E6ZbHd55z
k6KJ8u+BePtLJmsj6v9ANUR2s/dmDEv9m0qmOzPUnmk9XEFBoBw5TSrJvzbRWbRs
YKIXRUiWZn/OqYrjsWyP4OpqRgngKNRIAjLkq3DUUiG7sgeFoNJweTTGiGa2NsiP
rYlvqq/LM75+EfPEuw89ONxlLYxGCSqeTYC7Z3wEWkd//rYe5Si/tf2Oond5IKDY
+52h0cAnvHfX2lz1WLePnlYEXUXjJc60vZnzQWpr7lnyhbWtbsZbkR77RlF6Y7Dh
Os5xl7DzOeFrr/v1E6dF
=oDAF
-----END PGP SIGNATURE-----

--fqpFLwmo1NmRrIGXGPPPXMJ9GrE463b1L--
