From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v12 1/2] crypto: AF_ALG: add AEAD support
Date: Fri, 27 Feb 2015 10:34:37 -0800
Message-ID: <54F0B8BD.30600@intel.com>
References: <1681008.mocmysOoQU@tachyon.chronox.de> <7821728.KTX1G67VgF@tachyon.chronox.de> <20150227094944.GA29071@gondor.apana.org.au> <2021530.t7zNty0mPn@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2021530.t7zNty0mPn@tauon>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: 'Quentin Gouchet' <quentin.gouchet@gmail.com>, Daniel Borkmann <dborkman@redhat.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, 'Linux API' <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 02/27/2015 02:26 AM, Stephan Mueller wrote:
>>>> This patch adds the AEAD support for AF_ALG.
>>>> >> > 
>>>> >> > The implementation is based on algif_skcipher, but contains heavy
>>>> >> > modifications to streamline the interface for AEAD uses.
>>>> >> > 
>>>> >> > To use AEAD, the user space consumer has to use the salg_type named
>>>> >> > "aead".
>>> >> 
>>> >> I just saw Al Viro's patch to use the iov_iter API in
>>> >> algif_skcipher.c. I looked at it but lacked documentation for using
>>> >> it properly. Now I have a template that I will incorporate into
>>> >> algif_aead.c
>> >
>> >Please resubmit once you have done this.
> I have done that, but as indicated with an email to Al, I cannot get his 
> patch for skcipher and hash to work. Similarly, my modification for the 
> AEAD does not work either. So, I do not see that Al's patch can be 
> merged as is.
> 
> Therefore, I have not submitted my patch as Al mentioned he wanted to 
> look into his patchset.

Hi Stephan,
There was a problem with the iov_iter changes, but it has been fixed on netdev during merging window.
The algif_skcipher works fine for me on the latest (4.0.0-rc1+) cryptodev.

Regards,
Tadeusz
