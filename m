From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: semantics of rhashtable and sysvipc
Date: Wed, 23 May 2018 11:52:25 -0700
Message-ID: <CA+55aFwJtj5ucfx3T-g9VnNgWG7EqHS9+oFMSv8oyv11Yaa2UQ@mail.gmail.com>
References: <20180523172500.anfvmjtumww65ief@linux-n805> <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
 <20180523183103.cdgv4slom62y56wi@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523183103.cdgv4slom62y56wi@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 23, 2018 at 11:47 AM Davidlohr Bueso <dave@stgolabs.net> wrote:

> Note that even if the allocation was guaranteed, there are still param
validations
> and rhashtable_init() can return -EINVAL.

So?

It's not going to happen, because you're not going to give garbage
parameters.

Why would you add a BUG_ON() for something that cannot happen? You might as
well sprinkle them randomly in every damn place.

And even if somebody screws up the parameters because they are being
stupid, then SO WHAT? rhashtable_init() won't initialize the pointers, and
we'll get a NULL pointer dereference.

And hey, we'll probably get it later during boot, once the system is
actually up and running, and that NULL pointer dereference might even get
logged in the system logs now because the machine booted successfully, and
mnaybe it will even get sent to a distro and debugged.

So at what point was there _any_ advantage in doing a BUG_ON() for a crazy
case?

Really.

                Linus
