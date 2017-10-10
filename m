From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Tue, 10 Oct 2017 10:11:51 +0100
Message-ID: <20171010091151.rfdsphstboubm7ps@sirena.co.uk>
References: <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
 <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
 <20171004101720.ob5f467tro7agpcz@sirena.co.uk>
 <CA+M3ks5ZCUdTU5qU=Xi-MXXJQS6X-x=7qqs-5Myi7zeAAi8mJg@mail.gmail.com>
 <e3f91eff-df33-e203-2ce2-1f1dc98236ef@redhat.com>
 <20171009220858.zwbguqkamzmswqcq@sirena.co.uk>
 <dda39ec7-e1d7-8a11-2470-271cb7ba66e7@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n3vr7jvy6ajpqvqm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dda39ec7-e1d7-8a11-2470-271cb7ba66e7@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>, Sandeep Patil <sspatil@google.com>, driverdevel <devel@driverdev.osuosl.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Riley Andrews <riandrews@android.com>, linux-api@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org


--n3vr7jvy6ajpqvqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 05:10:37PM -0700, Laura Abbott wrote:
> On 10/09/2017 03:08 PM, Mark Brown wrote:
> > On Mon, Oct 09, 2017 at 02:25:47PM -0700, Laura Abbott wrote:

> >> Anyway, to move this forward I think we need to see a proof of concept
> >> of using selinux to protect access to specific heaps.

> > Aren't Unix permissions enough with separate files or am I
> > misunderstanding what you're looking to see a proof of concept for?

> The goal is to be able to restrict heap access to certain services
> and selinux groups on Android so straight unix permissions aren't
> sufficient.

Oh, there's Android users for this?  The users I was aware of were
non-Android.  Though even so I'd have thought that given that SELinux is
a superset of Unix file permissions it ought to be sufficient to be able
to use them.  I'd been thinking people were suggesting SELinux as a
replacement for file permissions, using the single file and the greater
capabilities of SELinux.

--n3vr7jvy6ajpqvqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlncjtYACgkQJNaLcl1U
h9AVAgf/aCSyn9swUrbGtIuL6I4w0UCWzbpKqT5kaZUnuvaFRp80UmbB93M90BWw
vcTlqxIg6KrMiOdUnQjk2IlSlAqzncXOCvvjxWXLYQEvRvizRy4+FyxAjY09K9p8
pEb7Q1QikmTHIx7O3c92MlHaAdMslWZOf7SDKvAjXFwoV3SwvZJzDoiQn2kCUxMV
MbQt70udZ8bB95CBcKP+VnxJBEIr/zQUyJTGT0wxjhb21ZynZIzyHrwBFrtINcu1
4G3Eyujed+oq2ebg9KsgXBGV5vmaDUQYIOg+sINZW3q01G8h/g9oJBk2pza7Z38E
neyBZleeYFjurdhleb0gX9ksTtTqXw==
=eTYq
-----END PGP SIGNATURE-----

--n3vr7jvy6ajpqvqm--
