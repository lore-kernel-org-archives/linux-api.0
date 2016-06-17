From: Andrew Zaborowski <balrogg@googlemail.com>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Fri, 17 Jun 2016 02:39:39 +0200
Message-ID: <CAOq732Lgh=Nca4_7QaN4F1ddSg-AX919_un4wSxyv5gU0PvqQw@mail.gmail.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
 <10863259.oUiAus9m9y@positron.chronox.de> <CAOq732KFLoeBz2-fkEbbW1ixf9rAQEJcWh3WK_mbB5jQGYYe6w@mail.gmail.com>
 <1696434.oCKeAI3Bfp@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1696434.oCKeAI3Bfp@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-api@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Hi Stephan,

On 16 June 2016 at 17:38, Stephan Mueller <smueller@chronox.de> wrote:
>> This isn't an issue with AF_ALG, I should have changed the subject
>> line perhaps.  In this case it's an inconsistency between some
>> implementations and the documentation (header comment).  It affects
>> users accessing the cipher through AF_ALG but also directly.
>
> As I want to send a new version of the algif_akcipher shortly now (hoping for
> an inclusion into 4.8), is there anything you see that I should prepare for
> regarding this issue? I.e. do you forsee a potential fix that would change the
> API or ABI of algif_akcipher?

No, as far as I understand algif_akcipher will do the right thing now
if the algorithm does the right thing.  It's only the two RSA drivers
that would need to align with the software RSA in what buffer length
they accept.

Best regards
