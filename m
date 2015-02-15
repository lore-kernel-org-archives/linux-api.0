From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH RFC v3 0/7] epoll: Introduce new syscalls,
 epoll_ctl_batch and epoll_pwait1
Date: Sun, 15 Feb 2015 15:00:11 -0700
Message-ID: <20150215150011.0340686c@lwn.net>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1423818243-15410-1-git-send-email-famz@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

On Fri, 13 Feb 2015 17:03:56 +0800
Fam Zheng <famz@redhat.com> wrote:

> SYNOPSIS
> 
>        #include <sys/epoll.h>
> 
>        int epoll_pwait1(int epfd, int flags,
>                         struct epoll_event *events,
>                         int maxevents,
>                         struct epoll_wait_params *params);

Quick, possibly dumb question: might it make sense to also pass in 
sizeof(struct epoll_wait_params)?  That way, when somebody wants to add
another parameter in the future, the kernel can tell which version is in
use and they won't have to do an epoll_pwait2()?

Thanks,

jon
