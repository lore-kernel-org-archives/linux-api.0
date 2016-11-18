From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available
Date: Fri, 18 Nov 2016 02:25:37 -0700
Message-ID: <4C72438D-9CD1-4D24-B58A-A089BDA17C66@dilger.ca>
References: <2D8B8AAF-2016-45BD-9D70-A532DDDB23D2@dilger.ca> <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk> <147938970382.13574.11581172952175034619.stgit@warthog.procyon.org.uk> <1479407964.4556.5.camel@redhat.com> <25517.1479459564@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3B3159B6-986F-446A-B888-405146D65507"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <25517.1479459564-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_3B3159B6-986F-446A-B888-405146D65507
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 18, 2016, at 1:59 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
>=20
>>>> If neither AT_STATX_*_SYNC flag is set, the behaviour is the =
default for
>>>> stat() on that filesystem.
>>>=20
>>> We also need to specify here what happens if both bits are set. =
Should
>>> that be -EINVAL?
>>=20
>> If that is the case, then it doesn't make sense to have two =
contradictory
>> flags.
>=20
> Yes it does.  There are actually *three* cases, not two.  Maybe, =
rather
> than a pair of flags, I should stake out a 2-bit field with three =
possible
> values.

That would probably be better in this case.

>> Pick a default behaviour (i.e. return what is known on the client),
>=20
> The default behaviour has to be what stat() does now for any =
particular
> filesystem.  statx() is likely to get used to emulate stat() so that =
stat()
> can be made to return safe timestamps.  If we make it so that statx() =
cannot
> do this, it's very likely that we'll see yet another stat() variant =
syscall
> being added.
>=20
>> and if this is 100% accurate (e.g. local filesystem or filesystem =
with
>> strong coherency)
>=20
> In a netfs, it was 100% accurate at the point the server started
> transmitting its reply.  This may no longer be true - even with =
something
> like AFS that has change notifications.

Sure, that is always true, even when running with a local filesystem.
My distinction here is "whether the client currently has a lock that
ensures its copy of the size is correct" vs. "the client has some size
that was correct at one point but may be totally incorrect now".

>> then it can optionally set the SYNC flag in the returned
>> flags.
>=20
> So you suggest putting the SYNC flag(s) in the request mask rather =
than
> sharing the AT_* flag space?

Sorry, I was conflating flags.

>> If the application needs 100% accurate size info, then it can set the =
SYNC
>> flag in the request and the filesystem may need to do extra work to =
fetch
>> accurate data from the server.
>=20
> Note that one of the things that people asked for was a
> DONT_GO_TO_THE_SERVER_AT_ALL flag.  I take it this is your suggested =
default?

Isn't that what NFS does today?

In any case, I'm not trying to rewrite NFS semantics here.  The main fix
would be to have the three-valued two-bit flag so that there aren't two
flags that mean opposite things.  That would also allow expansion to =
have
a fourth state in the future, if there was a need.

Cheers, Andreas






--Apple-Mail=_3B3159B6-986F-446A-B888-405146D65507
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWC7JEnKl2rkXzB/gAQieMRAAqwTcGeN3XvJmeYD7VkEDXhr/xm1l9fAP
5mrtb57SozU4GRcbBK1iV/lYAzwRftiRfExXXjC34eE11M2TrkZTG6MG4AVc6iio
QlA4nXjZcwGHV85g42NWBXhG+S3KmDzZB1fcqkUi5YukNs3K7yt5pvfyvvjO0+OG
0AS/B7XufD+GaZriYYE2GCrpENLThlxRtANLA+YwpJ9IjqTQqSNaVn4MxZuMyHvJ
cYCkf3+/uQ1Dyxh4gbQSxoT/2mjrRZGD8dvE6S5jpYw8sUXXebiwtuefFmcjlAX7
P6Fx4hC8vDkHIHH7Od7Pi/+iyDDHeFu767pimVWc60dz2wB6yZPtZ6vPF9IGeU/d
+CDioDBVHFvJyAdo3o5Dkg54L9urE9PuD6S59hH1+N4Ae7XYo2y06qNPRYn9qZ+Q
8BdVdRgAvcNGftKtsTkMGbgoRWPFCNOhtDPatJO59l8UPGEPXEaXc7EUbsNP5/Cv
7dlJP8OUjUirZen3Ua2g0J/9LcAuzi5CG6tSsoQsdHNViKv9Eoojg5n163nVjdx5
m+3Wla3Z7AoGnfheUcpTo2Z0uq/e4wxEtVsMiHAROPuDLfNa6TO6oHXPNF9Fr2oZ
I8YEqC30cydegqaSBXb+xdrv9yTqikpDIi7tf8f21SKDa/qhg65QRVDTm00yu6mn
D3L1tMgGRwU=
=gXpk
-----END PGP SIGNATURE-----

--Apple-Mail=_3B3159B6-986F-446A-B888-405146D65507--
