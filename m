From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Thu, 16 Jun 2016 10:05:48 +0200
Message-ID: <10863259.oUiAus9m9y@positron.chronox.de>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <1759070.fi90mrsgKn@positron.chronox.de> <CAOq732+ZyjD2Wv3Pt7x+jfurvgVq5pcUA--+G6VQM5t861n-fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <CAOq732+ZyjD2Wv3Pt7x+jfurvgVq5pcUA--+G6VQM5t861n-fQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Andrew Zaborowski <balrogg@googlemail.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Am Dienstag, 14. Juni 2016, 09:42:34 schrieb Andrew Zaborowski:

Hi Andrew,

> > 
> > I think we have agreed on dropping the length enforcement at the interface
> > level.
> 
> Separately from this there's a problem with the user being unable to
> know if the algorithm is going to fail because of destination buffer
> size != key size (including kernel users).  For RSA, the qat
> implementation will fail while the software implementation won't.  For
> pkcs1pad(...) there's currently just one implementation but the user
> can't assume that.

If I understand your issue correctly, my initial code requiring the caller to 
provide sufficient memory would have covered the issue, right? If so, we seem 
to have implementations which can handle shorter buffer sizes and some which 
do not. Should a caller really try to figure the right buffer size out? Why 
not requiring a mandatory buffer size and be done with it? I.e. what is the 
gain to allow shorter buffer sizes (as pointed out by Mat)? So, bottom line, I 
am wondering whether we should keep the algif_akcipher code to require a 
minimum buffer size.

If there is really a good argument to allow shorter buffers, then I guess we 
need an in-kernel API call (which should be reported to user space) which 
gives us the smallest usable buffer size. I guess that call would only be 
valid after a setkey operation as the output size depends on the key size. 
Instead of inventing a complete new API call, shouldn't the call 
crypto_akcipher_maxsize() be converted for this purpose? I requested that API 
call during the time the akcipher API was developed explicitly for getting the 
minimum buffer size the caller needs to provide.

Ciao
Stephan
