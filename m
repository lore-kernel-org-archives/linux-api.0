From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v10 8/8] tpm: TPM 2.0 FIFO Interface
Date: Sun, 14 Dec 2014 09:48:26 -0500
Message-ID: <548DA33A.4010300@linux.vnet.ibm.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1418413600-5400-9-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418413600-5400-9-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> Detect TPM 2.0 by sending idempotent TPM 2.x command. Ordinals for
> TPM 2.0 are higher than TPM 1.x commands so this should be fail-safe.
> Using STS3 is unreliable because some chips just report 0xff and not
> what the spec says.

TPM TIS 1.2 can report either 0xff or 0x00 for sts3 since that part of 
register was not defined for this version but only for a later version. 
So, unless the TIS 1.3 for TPM 2.0 is broken, it should report a bit 
_pattern_ (not plain 0x00 or 0xff) that you could apply the suggested 
mask to and check then.

     Stefan
