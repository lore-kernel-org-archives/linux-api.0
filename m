From: Andrew Zaborowski <balrogg@googlemail.com>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Thu, 16 Jun 2016 16:59:01 +0200
Message-ID: <CAOq732KFLoeBz2-fkEbbW1ixf9rAQEJcWh3WK_mbB5jQGYYe6w@mail.gmail.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
 <1759070.fi90mrsgKn@positron.chronox.de> <CAOq732+ZyjD2Wv3Pt7x+jfurvgVq5pcUA--+G6VQM5t861n-fQ@mail.gmail.com>
 <10863259.oUiAus9m9y@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <10863259.oUiAus9m9y@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-api@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Hi Stephan,

On 16 June 2016 at 10:05, Stephan Mueller <smueller@chronox.de> wrote:
> Am Dienstag, 14. Juni 2016, 09:42:34 schrieb Andrew Zaborowski:
>
> Hi Andrew,
>
>> >
>> > I think we have agreed on dropping the length enforcement at the interface
>> > level.
>>
>> Separately from this there's a problem with the user being unable to
>> know if the algorithm is going to fail because of destination buffer
>> size != key size (including kernel users).  For RSA, the qat
>> implementation will fail while the software implementation won't.  For
>> pkcs1pad(...) there's currently just one implementation but the user
>> can't assume that.
>
> If I understand your issue correctly, my initial code requiring the caller to
> provide sufficient memory would have covered the issue, right?

This isn't an issue with AF_ALG, I should have changed the subject
line perhaps.  In this case it's an inconsistency between some
implementations and the documentation (header comment).  It affects
users accessing the cipher through AF_ALG but also directly.

> If so, we seem
> to have implementations which can handle shorter buffer sizes and some which
> do not. Should a caller really try to figure the right buffer size out? Why
> not requiring a mandatory buffer size and be done with it? I.e. what is the
> gain to allow shorter buffer sizes (as pointed out by Mat)?

It's that client code doesn't need an intermediate layer with an
additional buffer and a memcpy to provide a sensible API.  If the code
wants to decrypt a 32-byte Digest Info structure with a given key or a
reference to a key it makes no sense, logically or in terms of
performance, for it to provide a key-sized buffer.

In the case of the userspace interface I think it's also rare for a
recv() or read() on Linux to require a buffer larger than it's going
to use, correct me if i'm wrong.  (I.e. fail if given a 32-byte
buffer, return 32 bytes of data anyway)  Turning your questino around
is there a gain from requiring larger buffers?

Best regards
