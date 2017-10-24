From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 01/17] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Date: Tue, 24 Oct 2017 15:21:19 -0600
Message-ID: <20171024212119.GB1611@linux.intel.com>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171024152415.22864-2-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 24, 2017 at 05:23:58PM +0200, Jan Kara wrote:
> From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
> unknown flags. However, proposals like MAP_SYNC need a mechanism to
> define new behavior that is known to fail on older kernels without the
> support. Define a new MAP_SHARED_VALIDATE flag pattern that is
> guaranteed to fail on all legacy mmap implementations.
> 
> It is worth noting that the original proposal was for a standalone
> MAP_VALIDATE flag. However, when that  could not be supported by all
> archs Linus observed:
> 
>     I see why you *think* you want a bitmap. You think you want
>     a bitmap because you want to make MAP_VALIDATE be part of MAP_SYNC
>     etc, so that people can do
> 
>     ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED
> 		    | MAP_SYNC, fd, 0);
> 
>     and "know" that MAP_SYNC actually takes.
> 
>     And I'm saying that whole wish is bogus. You're fundamentally
>     depending on special semantics, just make it explicit. It's already
>     not portable, so don't try to make it so.
> 
>     Rename that MAP_VALIDATE as MAP_SHARED_VALIDATE, make it have a value
>     of 0x3, and make people do
> 
>     ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED_VALIDATE
> 		    | MAP_SYNC, fd, 0);
> 
>     and then the kernel side is easier too (none of that random garbage
>     playing games with looking at the "MAP_VALIDATE bit", but just another
>     case statement in that map type thing.
> 
>     Boom. Done.
> 
> Similar to ->fallocate() we also want the ability to validate the
> support for new flags on a per ->mmap() 'struct file_operations'
> instance basis.  Towards that end arrange for flags to be generically
> validated against a mmap_supported_flags exported by 'struct
> file_operations'. By default all existing flags are implicitly
> supported, but new flags require MAP_SHARED_VALIDATE and
> per-instance-opt-in.
> 
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Suggested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Suggested-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks great.

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
