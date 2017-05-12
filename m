From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch v4 resend 2/2] kcmp: Add KCMP_EPOLL_TFD mode to compare
 epoll target files
Date: Fri, 12 May 2017 15:00:18 -0700
Message-ID: <20170512150018.b931c7f5295dd7484845fcec@linux-foundation.org>
References: <20170424154423.511592110@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424154423.511592110-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 24 Apr 2017 18:39:28 +0300 Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> With current epoll architecture target files are addressed
> with file_struct and file descriptor number, where the last
> is not unique. Moreover files can be transferred from another
> process via unix socket, added into queue and closed then
> so we won't find this descriptor in the task fdinfo list.
> 
> Thus to checkpoint and restore such processes CRIU needs to
> find out where exactly the target file is present to add it into
> epoll queue. For this sake one can use kcmp call where
> some particular target file from the queue is compared with
> arbitrary file passed as an argument.
> 
> Because epoll target files can have same file descriptor
> number but different file_struct a caller should explicitly
> specify the offset within.
> 
> To test if some particular file is matching entry inside
> epoll one have to
> 
>  - fill kcmp_epoll_slot structure with epoll file descriptor,
>    target file number and target file offset (in case if only
>    one target is present then it should be 0)
> 
>  - call kcmp as kcmp(pid1, pid2, KCMP_EPOLL_TFD, fd, &kcmp_epoll_slot)
>     - the kernel fetch file pointer matching file descriptor @fd of pid1
>     - lookups for file struct in epoll queue of pid2 and returns traditional
>       0,1,2 result for sorting purpose

That's quite a bit more code.  Is there a neat way of making it depend
on a new CONFIG_foo, then select CONFIG_foo if
CONFIG_CHECKPOINT_RESTORE?
