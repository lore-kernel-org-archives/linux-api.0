From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
Date: Wed, 21 Jan 2015 19:14:04 +0800
Message-ID: <20150121111404.GA3804@ad.nay.redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <1421747878-30744-6-git-send-email-famz@redhat.com>
 <54BE4F1D.7090807@gmail.com>
 <20150121045903.GA2858@fam-t430.nay.redhat.com>
 <54BF5ACE.6030206@gmail.com>
 <20150121085827.GB23024@ad.nay.redhat.com>
 <54BF814F.7090703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54BF814F.7090703@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu
List-Id: linux-api@vger.kernel.org

On Wed, 01/21 11:37, Paolo Bonzini wrote:
> 
> 
> On 21/01/2015 09:58, Fam Zheng wrote:
> >> > See my comment in the earlier mail. If you split this into two 
> >> > APIs, and epoll_ctl_batch() is guaranteed to execute 'cmds' in order, 
> >> > then the return value of epoll_ctl_batch() could be used to tell
> >> > user space how many commands succeeded. Much simpler!
> > Yes it is much simpler. However the reason to add batching in the first place is
> > to make epoll faster, by reducing syscalls. Splitting makes the result
> > sub-optimal: we still need at least 2 calls instead of 1.  Each one of the three
> > proposed new call *is* a step forward, but I don't think we will have everything
> > solved even by implementing them all. Compromise needed between performance or
> > complexity.
> > 
> > My take for simplicity will be leaving epoll_ctl as-is, and my take for
> > performance will be epoll_pwait1. And I don't really like putting my time on
> > epoll_ctl_batch, thinking it as a ambivalent compromise in between.
> 
> I agree with Michael actually.  The big change is going from O(n)
> epoll_ctl calls to O(1), and epoll_ctl_batch achieves that just fine.
> Changing 2 syscalls to 1 is the icing on the cake, but we're talking of
> a fraction of a microsecond.
> 

Maybe I'm missing something, but in common cases, the set of fds for epoll_wait
doesn't change that radically from one iteration to another, does it?

Fam
