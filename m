From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
Date: Wed, 3 Dec 2014 01:03:43 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1412030101400.16275@nanos>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <201412030016.20268.PeterHuewe@gmx.de> <201412030021.07882.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-758534258-1417565024=:16275"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201412030021.07882.PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-758534258-1417565024=:16275
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 3 Dec 2014, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
> Date: Wed, 3 Dec 2014 00:18:52 +0100
> Subject: [PATCH] tpm:tpm_i2c_nuvoton: simpyl return statements

simpyl?
 
> if !rc evals to false it is 0
> -> we can return rc in both cases

Why assigning rc and returning it when you can return the result of
tpm_chip_register() right away?
 
Thanks,

	tglx
--8323329-758534258-1417565024=:16275--
