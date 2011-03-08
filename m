From: "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC] introduce sys_syncfs to sync a single file system (v2)
Date: Tue, 08 Mar 2011 10:57:00 +0530
Message-ID: <8762ruchcr.fsf@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <20110303072223.GA28133@elie> <87bp1sziqn.fsf@linux.vnet.ibm.com> <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1103071515070.11152-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 7 Mar 2011 15:17:57 -0800 (PST), Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> wrote:
> Changes:
>  v1->v2: Rename, simplify to just take an fd.
> 
> It is frequently useful to sync a single file system, instead of all
> mounted file systems via sync(2):
> 
>  - On machines with many mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).
>  - Some applications write lots of data to the file system and then
>    want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.
> 
> There are currently two ways (that I know of) to sync a single super_block:
> 
>  - BLKFLSBUF ioctl on the block device: That also invalidates the bdev
>    mapping, which isn't usually desirable, and doesn't work for non-block
>    file systems.
>  - 'mount -o remount,rw' will call sync_filesystem as an artifact of the
>    current implemention.  Relying on this little-known side effect for
>    something like data safety sounds foolish.
> 
> Both of these approaches require root privileges, which some applications
> do not have (nor should they need?) given that sync(2) is an unprivileged
> operation.
> 
> This patch introduces a new system call syncfs(2) that takes an fd and
> syncs only the file system it references.  Maybe someday we can even
> 
>  $ sync /some/path
> 
> and not get
> 
>  sync: ignoring all arguments
> 
> The syscall is motivated by comments by Al and Christoph at the last LSF.
> syncfs(2) seems like an appropriate name given statfs(2).
> 
> A similar ioctl was also proposed a while back, see
> 	http://marc.info/?l=linux-fsdevel&m=127970513829285&w=2
> 
> Signed-off-by: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
> ---
>  arch/x86/ia32/ia32entry.S          |    1 +
>  arch/x86/include/asm/unistd_32.h   |    3 ++-
>  arch/x86/include/asm/unistd_64.h   |    2 ++
>  arch/x86/kernel/syscall_table_32.S |    1 +
>  fs/sync.c                          |   24 ++++++++++++++++++++++++
>  5 files changed, 30 insertions(+), 1 deletions(-)


include/asm-generic/unistd.h may also need an update.


-aneesh
