From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: semantics of rhashtable and sysvipc
Date: Wed, 23 May 2018 11:35:55 -0700
Message-ID: <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
References: <20180523172500.anfvmjtumww65ief@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523172500.anfvmjtumww65ief@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 23, 2018 at 10:41 AM Davidlohr Bueso <dave@stgolabs.net> wrote:

> The second alternative would be to add a BUG_ON() if the initialization
fails
> and we get rid of all the tables_initialized hack.

I see absolutely no value in an early boot BUG_ON().

Either we know the allocation cannot fail - which is perfectly fine at
bootup, and is a common pattern - or it can fail and we need to handle it.

In neither case is the BUG_ON() appropriate.

So I'm perfectly fine with getting rid of 'tables_initialized'. But no, not
with a BUG_ON().

If you cannot guarantee that the allocation works (using __GFP_NOFAIL is
ok, for example - but it only works with small allocations), then you need
to handle the allocation failure.

I refuse to see more of the shit-for-brains kind of "I can't be bothered to
handle error cases" BUG_ON() stuff.

And I also am not in the least interested in "this cannot possibly happen"
BUG_ON() code.

One option is to make rhashtable_alloc() shrink the allocation and try
again if it fails, and then you *can* do __GFP_NOFAIL eventually.

In fact, it can validly be argued that rhashtable_init() is just buggy
as-is. The whole *point* olf that function is to size things appropriately,
and returning -ENOMEM obviously means that it didn't do its job.

               Linus
