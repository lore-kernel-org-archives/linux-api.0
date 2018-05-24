From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: semantics of rhashtable and sysvipc
Date: Thu, 24 May 2018 12:17:48 -0700
Message-ID: <CA+55aFzfEsC9op0UzYte7OaWnvv9Czqr-0owFo0FGDqPcfGiKQ@mail.gmail.com>
References: <20180523172500.anfvmjtumww65ief@linux-n805> <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
 <20180524170700.wblnybinjzx5rwky@linux-n805> <CA+55aFwhkOnHngHpQ3wif5iy7PtOAVdjTcwce=kgBq0TCgmfJA@mail.gmail.com>
 <20180524185155.3bx4ujgz5f5g3epi@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524185155.3bx4ujgz5f5g3epi@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 24, 2018 at 12:08 PM Davidlohr Bueso <dave@stgolabs.net> wrote:


> However, after how about the resize being based on HASH_MIN_SIZE instead
of
> HASH_DEFAULT_SIZE?

I think that sounds reasonable. We wouldn't expect this to ever happen in
practice, and as you say, if it *does* happen, the size of the hash array
is the last of our problems.

> Considering that some users set p.min_size to be rather large-ish (up to
1024
> buckets afaict), we'd need the following:

>          size = min(ht->p.min_size, HASH_MIN_SIZE);

Bah, let's just go for simplicity, and just make it HASH_MIN_SIZE
unconditionally, and just have a single fallback: if the first "normal"
allocation fails, do one single unconditional allocation with HASH_MIN_SIZE
and GFP_NOFAIL.

I think that should work fine.

                Linus
