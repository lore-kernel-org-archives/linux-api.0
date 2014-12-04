From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v8 0/8] TPM 2.0 support
Date: Thu, 4 Dec 2014 07:52:35 +0200
Message-ID: <20141204055235.GA4194@intel.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412030016.20268.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201412030016.20268.PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 03, 2014 at 12:16:19AM +0100, Peter H=FCwe wrote:
> [SNIP]
>=20
> When applying to linux-v3.18-rc6 I get this new coccinelle warning:
> drivers/char/tpm/tpm_i2c_nuvoton.c:607:1-3: WARNING: end returns can =
be=20
> simpified
>=20
>=20
> make -C ../../../linux/ M=3D$(pwd) coccicheck

Not a huge problem but I've been only been able to run coccicheck
globally to the whole kernel tree. If I try what you put, it will
just print the usage information of spatch couple of times...

> Peter

/Jarkko
