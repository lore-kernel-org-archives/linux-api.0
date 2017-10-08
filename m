From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 2/2] IB/core: use MAP_DIRECT to fix / enable RDMA to
 DAX mappings
Date: Sun, 8 Oct 2017 08:49:33 -0700
Message-ID: <CAPcyv4iJTkDDNHsAyZCyh5E2X_68RsYkOKP3bXtEzgUrvLh2ew@mail.gmail.com>
References: <150743537023.13602.3520782942682280917.stgit@dwillia2-desk3.amr.corp.intel.com>
 <201710081447.sQSonloO%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201710081447.sQSonloO%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hal
List-Id: linux-api@vger.kernel.org

On Sat, Oct 7, 2017 at 11:45 PM, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi Dan,
>
> [auto build test ERROR on rdma/master]
> [also build test ERROR on v4.14-rc3 next-20170929]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

This was a fixed up resend of patch [v7 11/12]. It's not clear how to
teach the kbuild robot to be aware of patch-replies to individual
patches in the series. I.e. reworked patches without resending the
complete series?

> url:    https://github.com/0day-ci/linux/commits/Dan-Williams/iommu-up-level-sg_num_pages-from-amd-iommu/20171008-133505
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git master
> config: i386-randconfig-n0-201741 (attached as .config)
> compiler: gcc-4.8 (Debian 4.8.4-1) 4.8.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>>> drivers/infiniband/core/umem.c:39:29: fatal error: linux/mapdirect.h: No such file or directory
>     #include <linux/mapdirect.h>

mapdirect.h indeed does not exist when missing the earlier patches in
the series. It would be slick if the 0day-robot read the the
"in-reply-to" header and auto replaced a patch in a series, but that
would be a feature approaching magic.

>    compilation terminated.
>
> vim +39 drivers/infiniband/core/umem.c
>
>   > 39  #include <linux/mapdirect.h>
>     40  #include <linux/export.h>
>     41  #include <linux/hugetlb.h>
>     42  #include <linux/slab.h>
>     43  #include <rdma/ib_umem_odp.h>
>     44
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
