From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v9 7/8] tpm: TPM 2.0 CRB Interface
Date: Fri, 5 Dec 2014 15:10:25 +0200
Message-ID: <20141205131025.GE6993@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412042119.21493.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201412042119.21493.PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

I'll fix these (an run sparse).

/Jarkko

On Thu, Dec 04, 2014 at 09:19:21PM +0100, Peter H=FCwe wrote:
> Am Donnerstag, 4. Dezember 2014, 06:55:17 schrieb Jarkko Sakkinen:
> > tpm_crb is a driver for TPM 2.0 Command Response Buffer (CRB) Inter=
face
> > as defined in PC Client Platform TPM Profile (PTP) Specification.
> >=20
> > Only polling and single locality is supported as these are the limi=
tations
> > of the available hardware, Platform Trust Techonlogy (PTT) in Haswe=
ll
> > CPUs.
> >=20
> > The driver always applies CRB with ACPI start because PTT reports u=
sing
> > only ACPI start as start method but as a result of my testing it re=
quires
> > also CRB start.
> >=20
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>=20
> :(
>=20
>  make -C /data/data-old/linux-2.6/ M=3D$(pwd) modules C=3D1 CHECK=3Ds=
parse
> make: Entering directory '/data/data-old/linux-2.6'
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:99:5: warning: sy=
mbol 'crb_suspend' was not declared. Should it be static?
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14: warning: =
incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13: warning: =
incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19: warning: =
incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34: warning: =
incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63: warning: =
incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56: warning: =
incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27: warning: =
incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:277:22: warning: =
cast removes address space of expression
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33: warning: =
incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33:    expect=
ed void const volatile [noderef] <asn:2>*src
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33:    got un=
signed long long *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56: warning: =
incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19: warning: =
incorrect type in assignment (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19:    expect=
ed unsigned char [usertype] *cmd
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19:    got vo=
id [noderef] <asn:2>*
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33: warning: =
incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33:    expect=
ed void const volatile [noderef] <asn:2>*src
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33:    got un=
signed long long *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56: warning: =
incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56:    expect=
ed void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56:    got un=
signed int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19: warning: =
incorrect type in assignment (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19:    expect=
ed unsigned char [usertype] *rsp
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19:    got vo=
id [noderef] <asn:2>*
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:325:5: warning: s=
ymbol 'crb_acpi_remove' was not declared. Should it be static?
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.o
>=20
> :(
> Peter
