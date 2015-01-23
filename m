From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
Date: Fri, 23 Jan 2015 14:20:50 +0800
Message-ID: <20150123062050.GA7071@ad.nay.redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <1421747878-30744-6-git-send-email-famz@redhat.com>
 <54BE4F1D.7090807@gmail.com>
 <20150121045903.GA2858@fam-t430.nay.redhat.com>
 <54BF5ACE.6030206@gmail.com>
 <20150121085827.GB23024@ad.nay.redhat.com>
 <54BF814F.7090703@redhat.com>
 <20150121111404.GA3804@ad.nay.redhat.com>
 <54BF9294.3070902@redhat.com>
 <CALCETrWwuJpFK+38mBxxTQCu7Oig22Nr+mAuO++Y+0CdAhfzkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWwuJpFK+38mBxxTQCu7Oig22Nr+mAuO++Y+0CdAhfzkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh
List-Id: linux-api@vger.kernel.org

On Thu, 01/22 13:12, Andy Lutomirski wrote:
> On Wed, Jan 21, 2015 at 3:50 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >
> > On 21/01/2015 12:14, Fam Zheng wrote:
> >> > My take for simplicity will be leaving epoll_ctl as-is, and my take for
> >> > performance will be epoll_pwait1. And I don't really like putting my time on
> >> > epoll_ctl_batch, thinking it as a ambivalent compromise in between.
> >>
> >> > I agree with Michael actually.  The big change is going from O(n)
> >> > epoll_ctl calls to O(1), and epoll_ctl_batch achieves that just fine.
> >> > Changing 2 syscalls to 1 is the icing on the cake, but we're talking of
> >> > a fraction of a microsecond.
> >>
> >> Maybe I'm missing something, but in common cases, the set of fds for epoll_wait
> >> doesn't change that radically from one iteration to another, does it?
> >
> > That depends on the application.
> 
> In my application, the set of fds almost never changes, but the set of
> events I want changes all the time.  The main thing that changes is
> whether I care about EPOLLOUT.  If I'm ready to send something, then I
> want EPOLLOUT.  If I'm not ready, then I don't want EPOLLOUT.
> 

OK, I'll split it to epoll_ctl_batch and epoll_pwait1 as Micheal suggested in
v2.

Fam
