From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] mm: introduce bmap_walk()
Date: Sat, 17 Jun 2017 05:29:23 -0700
Message-ID: <CAPcyv4g=x+Af1C8_q=+euwNw_Fwk3Wwe45XibtYR5=kbOcmgfg@mail.gmail.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766212976.22552.11210067224152823950.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170617052212.GA8246@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170617052212.GA8246-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 16, 2017 at 10:22 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Fri, Jun 16, 2017 at 06:15:29PM -0700, Dan Williams wrote:
>> Refactor the core of generic_swapfile_activate() into bmap_walk() so
>> that it can be used by a new daxfile_activate() helper (to be added).
>
> No way in hell!  generic_swapfile_activate needs to day and no new users
> of ->bmap over my dead body.  It's a guaranteed to fuck up your data left,
> right and center.

Certainly you're not saying that existing swapfiles are broken, so I
wonder what bugs you're talking about?

Unless you had plans to go remove bmap() I don't see how this gets in
your way at all. That said, I think "please don't add a new bmap()
user, use iomap instead" is a fair comment. You know me well enough to
know that would be all it takes to redirect my work, I can do without
the bluster.
