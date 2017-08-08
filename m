From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/1] Add hugetlbfs support to memfd_create()
Date: Tue, 8 Aug 2017 07:33:58 +0200
Message-ID: <20170808053357.GA27790@dhcp22.suse.cz>
References: <1502149672-7759-1-git-send-email-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502149672-7759-1-git-send-email-mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,
I am one foot out of office and will be offline for two days so I
didn't get to review the patch yet but this information is an useful
information about the usecase that should be in the patch directly for
future reference.

On Mon 07-08-17 16:47:51, Mike Kravetz wrote:
> This patch came out of discussions in this e-mail thread [1].
> 
> The Oracle JVM team is developing a new garbage collection model.  This
> new model requires multiple mappings of the same anonymous memory.  One
> straight forward way to accomplish this is with memfd_create.  They can
> use the returned fd to create multiple mappings of the same memory.
> 
> The JVM today has an option to use (static hugetlb) huge pages.  If this
> option is specified, they would like to use the same garbage collection
> model requiring multiple mappings to the same memory.  Using hugetlbfs,
> it is possible to explicitly mount a filesystem and specify file paths
> in order to get an fd that can be used for multiple mappings.  However,
> this introduces additional system admin work and coordination.
> 
> Ideally they would like to get a hugetlbfs fd without requiring explicit
> mounting of a filesystem.   Today, mmap and shmget can make use of
> hugetlbfs without explicitly mounting a filesystem.  The patch adds this
> functionality to hugetlbfs.
> 
> A new flag MFD_HUGETLB is introduced to request a hugetlbfs file.  Like
> other system calls where hugetlb can be requested, the huge page size
> can be encoded in the flags argument is the non-default huge page size
> is desired.  hugetlbfs does not support sealing operations, therefore
> specifying MFD_ALLOW_SEALING with MFD_HUGETLB will result in EINVAL.
> 
> Of course, the memfd_man page would need updating if this type of
> functionality moves forward.
> 
> [1] https://lkml.org/lkml/2017/7/6/564
> 
> Mike Kravetz (1):
>   mm/shmem: add hugetlbfs support to memfd_create()
> 
>  include/uapi/linux/memfd.h | 24 ++++++++++++++++++++++++
>  mm/shmem.c                 | 37 +++++++++++++++++++++++++++++++------
>  2 files changed, 55 insertions(+), 6 deletions(-)
> 
> -- 
> 2.7.5

-- 
Michal Hocko
SUSE Labs
