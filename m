From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: semantics of rhashtable and sysvipc
Date: Wed, 23 May 2018 11:31:03 -0700
Message-ID: <20180523183103.cdgv4slom62y56wi@linux-n805>
References: <20180523172500.anfvmjtumww65ief@linux-n805>
 <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 23 May 2018, Linus Torvalds wrote:

>So I'm perfectly fine with getting rid of 'tables_initialized'. But no, not
>with a BUG_ON().
>
>If you cannot guarantee that the allocation works (using __GFP_NOFAIL is
>ok, for example - but it only works with small allocations), then you need
>to handle the allocation failure.

Note that even if the allocation was guaranteed, there are still param validations
and rhashtable_init() can return -EINVAL.
