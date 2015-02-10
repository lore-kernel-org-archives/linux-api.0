From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm, tpm_tis: fix TPM 2.0 probing
Date: Tue, 10 Feb 2015 14:50:37 +0200
Message-ID: <20150210125037.GB4313@intel.com>
References: <1423059669-31734-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201502090008.47986.PeterHuewe@gmx.de>
 <20150209083947.GC29987@intel.com>
 <54D9F6A0.9010905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54D9F6A0.9010905-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 10, 2015 at 07:16:32AM -0500, Stefan Berger wrote:
> On 02/09/2015 03:39 AM, Jarkko Sakkinen wrote:
> >On Mon, Feb 09, 2015 at 12:08:46AM +0100, Peter H=FCwe wrote:
> >>Am Mittwoch, 4. Februar 2015, 15:21:09 schrieb Jarkko Sakkinen:
> >>>If during transmission system error was returned, the logic was to
> >>>incorrectly deduce that chip is a TPM 1.x chip. This patch fixes t=
his
> >>>issue. Also, this patch changes probing so that message tag is use=
d as the
> >>>measure for TPM 2.x, which should be much more stable.
> >>Is it aware that some TPMs may respond with 0x00C1 as TAG for TPM1.=
2 commands?
> >I guess none of the TPM 1.2 command answer with the tag 0x8002?
>=20
>=20
> FYI: pdf page 26 , section 6.1 explains the predictable return value =
for a
> TPM1.2 command seen by a TPM2
>=20
> http://www.trustedcomputinggroup.org/files/static_page_files/8C68ADA8=
-1A4B-B294-D0FC06D3773F7DAA/TPM%20Rev%202.0%20Part%203%20-%20Commands%2=
001.16-code.pdf
>=20
> Following this:
>=20
> Sending a TPM1.2 command to a TPM2 should return a TPM1.2 header (tag=
 =3D
> 0xc4) and error code (TPM_BADTAG =3D 0x1e)
>=20
> Sending a TPM 2 command to a TPM 2 will give a TPM 2 tag in the heade=
r.
> Sending a TPM 2 command to a TPM 1.2 will give a TPM 1.2 tag in the h=
eader
> and an error code.

Thank you for the information. Do you think that for some reason
tpm2_probe() shoould instead check that value is not this error
instead of checking that tag is 0x80002?

>    Stefan

/Jarkko
