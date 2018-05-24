From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: semantics of rhashtable and sysvipc
Date: Thu, 24 May 2018 11:51:55 -0700
Message-ID: <20180524185155.3bx4ujgz5f5g3epi@linux-n805>
References: <20180523172500.anfvmjtumww65ief@linux-n805>
 <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
 <20180524170700.wblnybinjzx5rwky@linux-n805>
 <CA+55aFwhkOnHngHpQ3wif5iy7PtOAVdjTcwce=kgBq0TCgmfJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwhkOnHngHpQ3wif5iy7PtOAVdjTcwce=kgBq0TCgmfJA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 24 May 2018, Linus Torvalds wrote:

>This doesn't seem to be taking 'param->min_size' into account.

It was in that rounded_hashtable_size() does, however, after more
thought I think we can do better by taking it much more into account.

>
>I'm not sure that matters, but right now, if you have nelem_hint set and a
>min_size, the min_size is honored (if you have just min_size it's already
>ignored because the rhashtable always starts with HASH_DEFAULT_SIZE). So I
>could imagine that somebody uses it to guarantee something. The docs say
>that "min_size" is the minimum size for *shrinking* not for initializing,
>so I guess it's debatable.
>
>Also, wouldn't it make sense to make this all be a while loop? Or are you
>just depending on the knowledge that HASH_DEFAULT_SIZE / 2 is already
>guaranteed to be so small that there's no point? A comment to that effect
>would be good, perhaps.

Yes, this is why I didn't loop. With the default size of 64 buckets, we
allocate 640 + 128 = 768 bytes for the tbl and the lock array, respectively.
By halving this, upon retrying, I was relying on it being to "small to fail".

However, after how about the resize being based on HASH_MIN_SIZE instead of
HASH_DEFAULT_SIZE? That way the initial table would be a _lot_ smaller and
aid the allocator that much more; which is why we're here in the first place.
Any performance costs of collisions would be completely unimportant in this
scenario.

Considering that some users set p.min_size to be rather large-ish (up to 1024
buckets afaict), we'd need the following:

	size = min(ht->p.min_size, HASH_MIN_SIZE);

Which takes into account the min_size = max(ht->p.min_size, HASH_MIN_SIZE)
which came before, thus p.min_size == 0 is already taken into account.

Thanks,
Davidlohr
