From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm, tpm_tis: fix TPM 2.0 probing
Date: Tue, 10 Feb 2015 07:16:32 -0500
Message-ID: <54D9F6A0.9010905@linux.vnet.ibm.com>
References: <1423059669-31734-1-git-send-email-jarkko.sakkinen@linux.intel.com> <201502090008.47986.PeterHuewe@gmx.de> <20150209083947.GC29987@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150209083947.GC29987-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?windows-1252?Q?Peter_H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/09/2015 03:39 AM, Jarkko Sakkinen wrote:
> On Mon, Feb 09, 2015 at 12:08:46AM +0100, Peter H=FCwe wrote:
>> Am Mittwoch, 4. Februar 2015, 15:21:09 schrieb Jarkko Sakkinen:
>>> If during transmission system error was returned, the logic was to
>>> incorrectly deduce that chip is a TPM 1.x chip. This patch fixes th=
is
>>> issue. Also, this patch changes probing so that message tag is used=
 as the
>>> measure for TPM 2.x, which should be much more stable.
>> Is it aware that some TPMs may respond with 0x00C1 as TAG for TPM1.2=
 commands?
> I guess none of the TPM 1.2 command answer with the tag 0x8002?


=46YI: pdf page 26 , section 6.1 explains the predictable return value =
for=20
a TPM1.2 command seen by a TPM2

http://www.trustedcomputinggroup.org/files/static_page_files/8C68ADA8-1=
A4B-B294-D0FC06D3773F7DAA/TPM%20Rev%202.0%20Part%203%20-%20Commands%200=
1.16-code.pdf

=46ollowing this:

Sending a TPM1.2 command to a TPM2 should return a TPM1.2 header (tag =3D=
=20
0xc4) and error code (TPM_BADTAG =3D 0x1e)

Sending a TPM 2 command to a TPM 2 will give a TPM 2 tag in the header.
Sending a TPM 2 command to a TPM 1.2 will give a TPM 1.2 tag in the=20
header and an error code.


    Stefan
