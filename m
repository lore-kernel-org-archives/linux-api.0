From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/6] lib/bucket_locks: use kvmalloc_array()
Date: Tue, 29 May 2018 15:46:25 -0500
Message-ID: <CA+55aFxoC0+hKBQ_TmbXM_X60fnP8JKC3aVvGc=8bKh2oxL12g@mail.gmail.com>
References: <20180524211135.27760-1-dave@stgolabs.net> <20180524211135.27760-4-dave@stgolabs.net>
 <CA+55aFxvNCEBQsxfr=yL3jgxiC8M8wY2MHwVBH+T8qSWyP-WPg@mail.gmail.com>
 <20180529144317.GA20910@dhcp22.suse.cz> <20180529145106.GV27180@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529145106.GV27180@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Tue, May 29, 2018 at 9:51 AM Michal Hocko <mhocko@kernel.org> wrote:

> In other words, what about the following?

> +       WARN_ON_ONCE((flags & (__GFP_FS|__GFP_IO)) !=
(__GFP_FS|__GFP_IO));

I  still don't understand the point of this warning.

It's only stupid. It basically says "this function is garbage, so let me
warn about the fact that I'm a moron".

If we all needed to warn about ourselves being morons, there would be a
hell of a lot of big blinking signs everywhere.

And the *ONLY* thing that warning has ever caused is  just stupid code that
does

     if (flags == GFP_KERNEL)
         .. do kvmalloc ..
     else
         .. do kmalloc() ..

which is a *STUPID* pattern.

In other words, the WARN_ON() is bogus garbage. It's bogus exactly because
NOBODY CARES and all everybody will ever do is to just avoid it by writing
worse code.

The whole and ONLY point of "kvmalloc()" and friends is to make it easy to
write code and _not_ have those idiotic "let's do kmalloc or kvmalloc
depending on the phase of the moon" garbage. So the warning has literally
destroyed the only value that function has!

> +       if (!gfpflags_allow_blocking(flags))
> +               return NULL;
> +

And no. Now all the code *above* this check is just wrong. All the code
that modifies the gfp_flags with the intention of falling back on vmalloc()
is just wrong, since we're not falling back on vmalloc any more.

So I really think the semantics should be simple:

  - if we don't allow GFP_KERNEL, then the code becomes just "kmalloc()",
since there is no valid fallback to vmalloc. vmalloc does GFP_KERNEL.

  - otherwise, we do what we used to do (except now the warning is gone,
because we already handled the case it warned about).

Nothing else. No stupid other cases. The *only* thing that function should
ask itself is "can I fall back on vmalloc or not", and if it can't then it
should just be a kmalloc.

Because otherwise we'll continue to have people that just check in the
caller instead.

         Linus
