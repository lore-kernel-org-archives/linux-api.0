From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Mon, 9 Oct 2017 23:08:58 +0100
Message-ID: <20171009220858.zwbguqkamzmswqcq@sirena.co.uk>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
 <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
 <20171004101720.ob5f467tro7agpcz@sirena.co.uk>
 <CA+M3ks5ZCUdTU5qU=Xi-MXXJQS6X-x=7qqs-5Myi7zeAAi8mJg@mail.gmail.com>
 <e3f91eff-df33-e203-2ce2-1f1dc98236ef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="afp2mf522b5tahm7"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e3f91eff-df33-e203-2ce2-1f1dc98236ef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>, Sandeep Patil <sspatil@google.com>, driverdevel <devel@driverdev.osuosl.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Riley Andrews <riandrews@android.com>, linux-api@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org


--afp2mf522b5tahm7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 02:25:47PM -0700, Laura Abbott wrote:

> Anyway, to move this forward I think we need to see a proof of concept
> of using selinux to protect access to specific heaps.

Aren't Unix permissions enough with separate files or am I
misunderstanding what you're looking to see a proof of concept for?

--afp2mf522b5tahm7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnb83gACgkQJNaLcl1U
h9BQ2wf+KHEPZA0vk96NdOfEa6dMUvO4zWSbVZ4l0UeB3geCvf0XjV7jdCW95/8t
XgZdfek4kdz4dleVCpzx9QquPERyjcrVq78pf8cbQZhU4kirLTV82Z2fHXU4WlSw
SWQcYU5abvjDGqoeLPyDOew8L608Kz3KK62j+MwIbVoxbxD9seHL8KYyj/XwGK4n
+jyOZtqdcNbXrw9mqwziHUPCoJNU4W/oTC+lU5YoBdX0/oVKfPZPCdQlOmjE4pf0
gSuq8CWZ/Fl4ObXL0urk4QzPnOgACzA1jbu6xSYgOhXX9ZZTnFIq1icQyuFSufkG
vgGMHWvebUnTgtYIRtZODd4isOKdsg==
=xWic
-----END PGP SIGNATURE-----

--afp2mf522b5tahm7--
