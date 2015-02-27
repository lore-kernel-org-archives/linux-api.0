From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v12 1/2] crypto: AF_ALG: add AEAD support
Date: Fri, 27 Feb 2015 11:26:32 +0100
Message-ID: <2021530.t7zNty0mPn@tauon>
References: <1681008.mocmysOoQU@tachyon.chronox.de> <7821728.KTX1G67VgF@tachyon.chronox.de> <20150227094944.GA29071@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227094944.GA29071-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Linux API' <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Freitag, 27. Februar 2015, 22:49:44 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Feb 05, 2015 at 04:10:58PM +0100, Stephan Mueller wrote:
>> Am Donnerstag, 29. Januar 2015, 21:24:45 schrieb Stephan Mueller:
>> 
>> Hi Herbert,
>> 
>> > This patch adds the AEAD support for AF_ALG.
>> > 
>> > The implementation is based on algif_skcipher, but contains heavy
>> > modifications to streamline the interface for AEAD uses.
>> > 
>> > To use AEAD, the user space consumer has to use the salg_type named
>> > "aead".
>> 
>> I just saw Al Viro's patch to use the iov_iter API in
>> algif_skcipher.c. I looked at it but lacked documentation for using
>> it properly. Now I have a template that I will incorporate into
>> algif_aead.c
>
>Please resubmit once you have done this.

I have done that, but as indicated with an email to Al, I cannot get his 
patch for skcipher and hash to work. Similarly, my modification for the 
AEAD does not work either. So, I do not see that Al's patch can be 
merged as is.

Therefore, I have not submitted my patch as Al mentioned he wanted to 
look into his patchset.
>
>Thanks,


Ciao
Stephan
