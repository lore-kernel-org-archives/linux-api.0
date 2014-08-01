From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Thu, 31 Jul 2014 23:45:36 -0700
Message-ID: <53DB3790.7020600@infradead.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-api@vger.kernel.org, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/31/14 17:30, Eric W. Biederman wrote:
> 
> This patchset implements /proc/thread-self a magic symlink that
> solves a couple of problems.
> 
> - It makes it easy to get to a specific threads directory in /proc
>   with gettid() not being exported in glibc this is currently a pain.
> 
> - It allows fixing the problem present in /proc/mounts and /proc/net
>   that when the thread group leader exits but the entire thread group
>   remains /proc/self/net and /proc/self/mounts and thus /proc/mounts and
>   /proc/net become empty.
> 
> - As mount and network namespaces are per thread it allows /proc/net and
>   /proc/mounts to reflect this.

Hi Eric,

Any changes/additions to Documentation/ ?

Thanks.

> This is small chance changing /proc/net and /proc/mounts will cause
> userspace regressions (although nothing has shown up in my testing) if
> that happens we can just point the change that moves them from
> /proc/self/... to /proc/thread-self/...
> 
> Eric W. Biederman (4):
>       proc: Have net show up under /proc/<tgid>/task/<tid>
>       proc: Implement /proc/thread-self to point at the directory of the current thread
>       proc: Point /proc/net at /proc/thread-self/net instead of /proc/self/net
>       proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts
> 
>  fs/proc/Makefile              |  1 +
>  fs/proc/base.c                | 18 ++++++---
>  fs/proc/inode.c               |  7 +++-
>  fs/proc/internal.h            |  6 +++
>  fs/proc/proc_net.c            |  2 +-
>  fs/proc/root.c                |  5 ++-
>  fs/proc/thread_self.c         | 85 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pid_namespace.h |  1 +
>  8 files changed, 117 insertions(+), 8 deletions(-)


-- 
~Randy
