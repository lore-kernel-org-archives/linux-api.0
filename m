From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v3 4/7] crypto: AF_ALG: add AEAD support
Date: Tue, 25 Nov 2014 16:08:35 +0100
Message-ID: <3914952.bO8PzptSEc@tauon>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de> <5492722.Cc6uZ9OM2L@tauon> <20141125145850.GD8541@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141125145850.GD8541-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml - Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Dienstag, 25. November 2014, 22:58:50 schrieb Herbert Xu:

Hi Herbert,

>On Mon, Nov 24, 2014 at 03:58:34PM +0100, Stephan Mueller wrote:
>> Ok. But in the code you see that skcipher is a 100% subset of AEAD.
>> For AEAD, all we need to do in addition to normal symmetric ciphers
>> is to select the AEAD kernel crypto API calls, to locate and use the
>> AD and to ensure we have the right memory size to process the tag.
>
>There is still one fundamental difference between AEAD and ciphers.
>Namely that ciphers can operate as you go while AEAD requests must
>be done in one lot.  So that should make the AEAD code simpler vs.
>ciphers.

Yes, that is a key difference.
>
>I think the best course of action for now is to start with sharing
>no code and then chop bits off as we see fit.

Ok, I will create a new patch set with a separate algif_aead.c. I guess 
the entire sgl handling logic will be gone in AEAD.
>
>Cheers,


Ciao
Stephan
