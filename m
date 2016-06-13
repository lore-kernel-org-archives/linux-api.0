From: Andrew Zaborowski <balrogg@googlemail.com>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Tue, 14 Jun 2016 00:16:11 +0200
Message-ID: <CAOq732J6J9b0NWuELRs7udiO7mApybfxjFaYX_UVdqHR+9Fvrw@mail.gmail.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
 <20160515041701.15888.53830.stgit@tstruk-mobl1> <alpine.OSX.2.20.1606071719170.9891@mjmartin-mac01.local>
 <6401187.24v903AfyY@tauon.atsec.com> <alpine.OSX.2.20.1606081135160.16651@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1606081135160.16651@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Stephan Mueller <smueller@chronox.de>, Tadeusz Struk <tadeusz.struk@intel.com>, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Hi,

On 8 June 2016 at 21:14, Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
> On Wed, 8 Jun 2016, Stephan Mueller wrote:
>> What is your concern?
> Userspace must allocate larger buffers than it knows are necessary for
> expected results.
>
> It looks like the software rsa implementation handles shorter output buffers
> ok (mpi_write_to_sgl will return EOVERFLOW if the the buffer is too small),
> however I see at least one hardware rsa driver that requires the output
> buffer to be the maximum size. But this inconsistency might be best
> addressed within the software cipher or drivers rather than in recvmsg.

Should the hardware drivers fix this instead?  I've looked at the qat
and caam drivers, they both require the destination buffer size to be
the key size and in both cases there would be no penalty for dropping
this requirement as far as I see.  Both do a memmove if the result
ends up being shorter than key size.  In case the caller knows it is
expecting a specific output size, the driver will have to use a self
allocated buffer + a memcpy in those same cases where it would later
use memmove instead.  Alternatively the sg passed to dma_map_sg can be
prepended with a dummy segment the right size to save the memcpy.

akcipher.h only says:
@dst_len: Size of the output buffer. It needs to be at least as big as
the expected result depending on the operation

Note that for random input data the memmove will be done about 1 in
256 times but with PKCS#1 padding the signature always has a leading
zero.

Requiring buffers bigger than needed makes the added work of dropping
the zero bytes from the sglist and potentially re-adding them in the
client difficult to justify.  RSA doing this sets a precedent for a
future pkcs1pad (or other algorithm) implementation to do the same
thing and a portable client having to always know the key size and use
key-sized buffers.

Best regards
