From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: semantics of rhashtable and sysvipc
Date: Thu, 24 May 2018 10:53:26 -0700
Message-ID: <CA+55aFwhkOnHngHpQ3wif5iy7PtOAVdjTcwce=kgBq0TCgmfJA@mail.gmail.com>
References: <20180523172500.anfvmjtumww65ief@linux-n805> <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
 <20180524170700.wblnybinjzx5rwky@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524170700.wblnybinjzx5rwky@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 24, 2018 at 10:23 AM Davidlohr Bueso <dave@stgolabs.net> wrote:

>          tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
> -       if (tbl == NULL)
> -               return -ENOMEM;
> +       if (unlikely(tbl == NULL)) {
> +               size = min(size, HASH_DEFAULT_SIZE) / 2;
> +
> +               tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
> +               if (tbl == NULL)
> +                       tbl = bucket_table_alloc_retry(ht, size,
GFP_KERNEL);
> +       }

This doesn't seem to be taking 'param->min_size' into account.

I'm not sure that matters, but right now, if you have nelem_hint set and a
min_size, the min_size is honored (if you have just min_size it's already
ignored because the rhashtable always starts with HASH_DEFAULT_SIZE). So I
could imagine that somebody uses it to guarantee something. The docs say
that "min_size" is the minimum size for *shrinking* not for initializing,
so I guess it's debatable.

Also, wouldn't it make sense to make this all be a while loop? Or are you
just depending on the knowledge that HASH_DEFAULT_SIZE / 2 is already
guaranteed to be so small that there's no point? A comment to that effect
would be good, perhaps.

                    Linus
