From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Wed, 28 Oct 2015 00:35:30 +0100
Message-ID: <1499937.MpmApGzYrd@tauon.atsec.com>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <9859277.cZClo5B21s@tauon.atsec.com> <1445987716.3405.127.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1445987716.3405.127.camel@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 28. Oktober 2015, 08:15:16 schrieb David Woodhouse:

Hi David,
>
>Absolutely. The interface needs to support *both*.
>
>I've spent a lot of time chasing through userspace stacks, fixing
>broken assumptions that we will *always* have the actual key material
>in a file =E2=80=94 and making libraries and applications accept PKCS#=
11 URIs
>referring to keys in hardware as well as filenames.
>
>I am violently opposed to exposing an API from the kernel which makes
>that *same* fundamental mistake, and ties its users to using *only*
>software keys.
>
>FROM THE BEGINNING, users of this new API should be able to cope with
>the fact that they might not *have* the key material, and that they
>might simply be referring to a key which exists elsewhere. Such as in
>the TPM, or within an SGX software enclave.

Albeit that all sounds like the crown jewel, how do you propose that sh=
all=20
happen?

Assume that you have a web server that has a pub and priv key in its cu=
rrent=20
configuration -- I guess that is the vast majority of configs.

Can you please elaborate how the process for such a web server shall re=
ally=20
work?


Ciao
Stephan
