From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: introduce MAP_VALIDATE, a mechanism for for
 safely defining new mmap flags
Date: Fri, 1 Sep 2017 00:34:02 -0700
Message-ID: <20170901073402.GA19080@infradead.org>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170831100359.GD21443@lst.de>
 <CAPcyv4jvTB4Aiei1-fGybyJNopXQy9zADpnFcuRNdZCS4Mf1QQ@mail.gmail.com>
 <CA+55aFwsfUj1f41w8hqt9LN3-ajmJ=2AB1Nb6ZzwHgE1OKxGOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwsfUj1f41w8hqt9LN3-ajmJ=2AB1Nb6ZzwHgE1OKxGOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 31, 2017 at 06:27:31PM -0700, Linus Torvalds wrote:
> Why? That's no different from the case statement for the mmu case,
> just written differently.

Yes.

> You *want* existing kernels to fail, since they don't test the bits
> you want to test.
> 
> So you just want to rewrite these all as
> 
>     switch (flags & MAP_TYPE) {
>     case MAP_SHARED_VALIDATE:
>         .. validate the other bits...
>         /* fallhtough */
>     case MAP_SHARED:
>         .. do the shared case ..
>     case MAP_PRIVATE:
>         .. do the private case ..
>     default:
>         return -EINVAL;
>     }

Btw, at least my original idea was to make MAP_VALIDATE a flag
instead of another mapping type, that is take it out of MAP_TYPE.

That being said this version is ok with me too - the chances of
needing a new type of private mappings probably isn't too big.
