From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Mon, 27 Nov 2017 16:30:32 +0000
Message-ID: <20171127163032.zp5aobbqksuh7w7v@sirena.org.uk>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <1e7fc718-825c-1028-1c28-a75a7320103f@redhat.com>
 <CA+M3ks6vP+W77QBzbczxzcV7YZCoBusC=wgjZPUNLrCYFFDARA@mail.gmail.com>
 <20171127114357.GB3710@kroah.com>
 <20171127161222.oig34dt2uc4lzpk2@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o6cytfpocheuc6jw"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171127161222.oig34dt2uc4lzpk2@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, driverdevel <devel@driverdev.osuosl.org>, linux-api@vger.kernel.org, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Riley Andrews <riandrews@android.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org


--o6cytfpocheuc6jw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 27, 2017 at 05:12:23PM +0100, Daniel Vetter wrote:

> commit model ftw, we have 400+ patches for 4.16 already merged and tested
> and all ready, right when -rc1 gets tagged. Makes the merge window the
> most relaxed time of all, because all the other maintainers are drowning
> and wont pester you.

> Just saying, this is an entirely fixable problem :-P

Or even just pre-review things and flag them in a mailbox if you want to
wait for -rc1 before applying things.

--o6cytfpocheuc6jw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlocPagACgkQJNaLcl1U
h9Ct/wf/fbBPp83rL0jLelWTh/f5TQiZATLH2BsgCrBNhvkJzqsiYVOHJrv4dHWr
vdrVJsbLi/py04ixZCgvOa32SC4UZoQ7XSNOd6K7QlfbsadzfAlrCv48MFaLc347
trWNbyW0L0VKdOz23CLRH7BD8Nn3JN74/69Buo24ERkbXD1veH0AaI5aU/Rgf0li
rDxnrQ3RITk342A5vuBtBSGATCZK+7nD7mB8lOwx6AhxGjx0XLSVmRvyi+0XaE+4
yClx9GBzoM3iqehdgyTTOpV00TOefX0WPsHjKoGAVO2qQgylevWURq5MQDMMagf1
f7sBELS6c2zphDa6mfMA9EhTF39rbg==
=xxIO
-----END PGP SIGNATURE-----

--o6cytfpocheuc6jw--
