From: Andrew Zaborowski <balrogg-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Tue, 14 Jun 2016 09:42:34 +0200
Message-ID: <CAOq732+ZyjD2Wv3Pt7x+jfurvgVq5pcUA--+G6VQM5t861n-fQ@mail.gmail.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
 <alpine.OSX.2.20.1606081135160.16651@mjmartin-mac01.local>
 <CAOq732J6J9b0NWuELRs7udiO7mApybfxjFaYX_UVdqHR+9Fvrw@mail.gmail.com> <1759070.fi90mrsgKn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1759070.fi90mrsgKn-jJGQKZiSfeo1haGO/jJMPxvVK+yQ3ZXh@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Crypto Mailing List <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Stephan,

On 14 June 2016 at 07:12, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org> wrote:
> Am Dienstag, 14. Juni 2016, 00:16:11 schrieb Andrew Zaborowski:
>> On 8 June 2016 at 21:14, Mat Martineau
>>
>> <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> > On Wed, 8 Jun 2016, Stephan Mueller wrote:
>> >> What is your concern?
>> >
>> > Userspace must allocate larger buffers than it knows are necessary for
>> > expected results.
>> >
>> > It looks like the software rsa implementation handles shorter output
>> > buffers ok (mpi_write_to_sgl will return EOVERFLOW if the the buffer is
>> > too small), however I see at least one hardware rsa driver that requires
>> > the output buffer to be the maximum size. But this inconsistency might be
>> > best addressed within the software cipher or drivers rather than in
>> > recvmsg.
>> Should the hardware drivers fix this instead?  I've looked at the qat
>> and caam drivers, they both require the destination buffer size to be
>> the key size and in both cases there would be no penalty for dropping
>> this requirement as far as I see.  Both do a memmove if the result
>> ends up being shorter than key size.  In case the caller knows it is
>> expecting a specific output size, the driver will have to use a self
>> allocated buffer + a memcpy in those same cases where it would later
>> use memmove instead.  Alternatively the sg passed to dma_map_sg can be
>> prepended with a dummy segment the right size to save the memcpy.
>>
>> akcipher.h only says:
>> @dst_len: Size of the output buffer. It needs to be at least as big as
>> the expected result depending on the operation
>>
>> Note that for random input data the memmove will be done about 1 in
>> 256 times but with PKCS#1 padding the signature always has a leading
>> zero.
>>
>> Requiring buffers bigger than needed makes the added work of dropping
>> the zero bytes from the sglist and potentially re-adding them in the
>> client difficult to justify.  RSA doing this sets a precedent for a
>> future pkcs1pad (or other algorithm) implementation to do the same
>> thing and a portable client having to always know the key size and use
>> key-sized buffers.
>
> I think we have agreed on dropping the length enforcement at the interface
> level.

Separately from this there's a problem with the user being unable to
know if the algorithm is going to fail because of destination buffer
size != key size (including kernel users).  For RSA, the qat
implementation will fail while the software implementation won't.  For
pkcs1pad(...) there's currently just one implementation but the user
can't assume that.

Best regards
