From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] userfaultfd: Add feature to request for a signal
 delivery
Date: Tue, 4 Jul 2017 18:40:34 +0200
Message-ID: <20170704164034.GH5738@redhat.com>
References: <20170627070643.GA28078@dhcp22.suse.cz>
 <20170627153557.GB10091@rapoport-lnx>
 <51508e99-d2dd-894f-8d8a-678e3747c1ee@oracle.com>
 <20170628131806.GD10091@rapoport-lnx>
 <3a8e0042-4c49-3ec8-c59f-9036f8e54621@oracle.com>
 <20170629080910.GC31603@dhcp22.suse.cz>
 <936bde7b-1913-5589-22f4-9bbfdb6a8dd5@oracle.com>
 <20170630094718.GE22917@dhcp22.suse.cz>
 <20170630130813.GA5738@redhat.com>
 <5956F2EC.1000805@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5956F2EC.1000805-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: prakash sangappa <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 30, 2017 at 05:55:08PM -0700, prakash sangappa wrote:
> Interesting that UFFDIO_COPY is faster then fallocate().  In the DB use case
> the page does not need to be allocated at the time a process trips on 
> the hugetlbfs
> file hole and receives SIGBUS.  fallocate() is called on the hugetlbfs file,
> when more memory needs to be allocated by a separate process.

The major difference is that with UFFDIO_COPY the hugepage will be
immediately mapped into the virtual address without requiring any
further minor fault. So it's ideal if you could arrange to call
UFFDIO_COPY from the same process that is going to touch and use the
hugetlbfs data immediately after. You would eliminate a minor fault
that way.

UFFDIO_COPY at least for anon was measured to perform better than a
regular page fault too.

> Regarding hugetlbfs mount option, one consideration is to allow mounts of
> hugetlbfs inside user namespaces's mount namespace. Which would allow
> non privileged processes to mount hugetlbfs for use inside a user 
> namespace.
> This may be needed even for the 'min_size' mount option using which an
> application could reserve huge pages and mount a filesystem for its use,
> with out the need to have privileges given the system has enough hugepages
> configured.  It seems if non privileged processes are allowed to mount 
> hugetlbfs
> filesystem, then min_size should be subject to some resource limits.
> 
> Mounting inside user namespace will be a different patch proposal later.

There's no particular reason to make UFFDIO_FEATURE_SIGBUS a
privileged op unless we want to eliminate the branch with the static
key, so it's certainly simpler than dealing with hugetlbfs min_size
reserves.

I'm positive about the UFFDIO_FEATURE_SIGBUS tradeoffs, but others
feel free to comment.

If you could make second patch to extend the selftest to exercise and
validates UFFDIO_FEATURE_SIGBUS in anon/shmem/hugetlbfs it'd be great.

Thanks,
Andrea
