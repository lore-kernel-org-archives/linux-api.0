From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFC v3 0/7] epoll: Introduce new syscalls,
 epoll_ctl_batch and epoll_pwait1
Date: Wed, 18 Feb 2015 19:49:34 +0100
Message-ID: <20150218184934.GA7493@gmail.com>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
 <20150215150011.0340686c@lwn.net>
 <20150216010224.GA32421@ad.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150216010224.GA32421@ad.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@effi>
List-Id: linux-api@vger.kernel.org


* Fam Zheng <famz@redhat.com> wrote:

> On Sun, 02/15 15:00, Jonathan Corbet wrote:
> > On Fri, 13 Feb 2015 17:03:56 +0800
> > Fam Zheng <famz@redhat.com> wrote:
> > 
> > > SYNOPSIS
> > > 
> > >        #include <sys/epoll.h>
> > > 
> > >        int epoll_pwait1(int epfd, int flags,
> > >                         struct epoll_event *events,
> > >                         int maxevents,
> > >                         struct epoll_wait_params *params);
> > 
> > Quick, possibly dumb question: might it make sense to also pass in 
> > sizeof(struct epoll_wait_params)?  That way, when somebody wants to add
> > another parameter in the future, the kernel can tell which version is in
> > use and they won't have to do an epoll_pwait2()?
> > 
> 
> Flags can be used for that, if the change is not 
> radically different.

Passing in size is generally better than flags, because 
that way an extension of the ABI (new field[s]) 
automatically signals towards the kernel what to do with 
old binaries - while extending the functionality of new 
binaries, without sacrificing functionality.

With flags you are either limited to the same structure 
size - or have to decode a 'size' value from the flags 
value - which is fragile (and in which case a real 'size' 
parameter is better).

in the perf ABI we use something like that: there's a 
perf_attr.size parameter that iterates the ABI forward, 
while still being binary compatible with older software.

If old binaries pass in a smaller structure to a newer 
kernel then the kernel pads the new fields with zero by 
default - that way the kernel internals are never burdened 
with compatibility details and data format versions.

If new user-space passes in a large structure than the 
kernel can handle then the kernel returns an error - this 
way user-space can transparently support conditional 
features and fallback logic.

It works really well, we've done literally a hundred perf 
ABI extensions this way in the last 4+ years, in a pretty 
natural fashion, without littering the kernel (or 
user-space) with version legacies and without breaking 
existing perf tooling.

Other syscall ABIs already get painful when trying to 
handle 2-3 data structure versions, so people either give 
up, or add flags kludges or go to new syscall entries: 
which is painful in its own fashion and adds unnecessary 
latency to feature introduction as well.

Thanks,

	Ingo
