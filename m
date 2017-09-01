From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: introduce MAP_VALIDATE, a mechanism for for
 safely defining new mmap flags
Date: Thu, 31 Aug 2017 18:01:02 -0700
Message-ID: <CAPcyv4jvTB4Aiei1-fGybyJNopXQy9zADpnFcuRNdZCS4Mf1QQ@mail.gmail.com>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170831100359.GD21443@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831100359.GD21443-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 31, 2017 at 3:03 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>> +/*
>> + * The historical set of flags that all mmap implementations implicitly
>> + * support when file_operations.mmap_supported_mask is zero. With the
>> + * mmap3 syscall the deprecated MAP_DENYWRITE and MAP_EXECUTABLE bit
>> + * values are explicitly rejected with EOPNOTSUPP rather than being
>> + * silently accepted.
>> + */
>
> no mmap3 syscall here :)

True, that's stale.

> Do you also need to update the nommu mmap implementation?

Ugh, nommu defeats the MAP_SHARED_VALIDATE proposal from Linus.

        if ((flags & MAP_TYPE) != MAP_PRIVATE &&
            (flags & MAP_TYPE) != MAP_SHARED)
                return -EINVAL;

...parisc strikes again.
