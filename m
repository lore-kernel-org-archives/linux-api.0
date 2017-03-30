From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: Re: [PATCH RFC 0/4] proc: support multiple separate proc instances
 per pidnamespace
Date: Fri, 31 Mar 2017 00:16:49 +0200
Message-ID: <20170330221649.GB13761@comp-core-i7-2640m-0182e6>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, ebiederm@xmission.com, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, kirill@shutemov.name, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 05:22:55PM +0200, Djalal Harouni wrote:
> Hi,
> 
> This RFC can be applied on top of Linus' tree 89970a04d7
> 
> This RFC implements support for multiple separate proc instances inside
> the same pid namespace. This allows to solve lot of problems that
> today's use case face.
> 
> Historically procfs was tied to pid namespaces, and mount options were
> propagated to all other procfs instances in the same pid namespace. This
> solved several use cases in that time. However today we face new
> problems, there are mutliple container implementations there, some of
> them want to hide pid entries, others want to hide non-pid entries,
> others want to have sysctlfs, others want to share pid namespace with
> private procfs mounts. All these with current implementation won't work
> since all options will be propagated to all procfs mounts.
> 
> This series allow to have new instances of procfs per pid namespace where
> each instance can have its own mount option inside the same pid namespace.
> This was also suggested by Andy Lutomirski.
> 
> 
> Now:
> $ sudo mount -t proc -o unshare,hidepid=2 none /test
> 
> The option 'unshare' will allow to mount a new instance of procfs inside
> the same pid namespace.
> 
> Before:
> $ stat /proc/slabinfo
> 
>   File: ‘/proc/slabinfo’
>   Size: 0         	Blocks: 0          IO Block: 1024   regular empty file
> Device: 4h/4d	Inode: 4026532046  Links: 1
> 
> $ stat /test3/slabinfo
> 
>   File: ‘/test3/slabinfo’
>   Size: 0         	Blocks: 0          IO Block: 1024   regular empty file
> Device: 4h/4d	Inode: 4026532046  Links: 1
> 
> 
> After:
> $ stat /proc/slabinfo
> 
>   File: ‘/proc/slabinfo’
>   Size: 0         	Blocks: 0          IO Block: 1024   regular empty file
> Device: 4h/4d	Inode: 4026532046  Links: 1
> 
> $ stat /test3/slabinfo
> 
>   File: ‘/test3/slabinfo’
>   Size: 0         	Blocks: 0          IO Block: 1024   regular empty file
> Device: 31h/49d	Inode: 4026532046  Links: 1
> 
> 
> Any better name for the option 'unshare' ? suggestions ?
> 
> I was going to use 'version=2' but then this may sound more like a
> proc2 fs which currently impossible to implement since it will share
> locks with the old proc.
> 
> 
> Al, Eric any comments please ?

Multiple mnt_root's lead us to significant memory costs for storing dentry
of tasks. I mean what we will get as many copies of the tasks dentry as many
times we have mounted the procfs with 'unshare' flag. No?

-- 
Rgrds, legion
