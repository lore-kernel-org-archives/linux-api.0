From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
Date: Thu, 22 Jan 2015 13:12:59 -0800
Message-ID: <CALCETrWwuJpFK+38mBxxTQCu7Oig22Nr+mAuO++Y+0CdAhfzkw@mail.gmail.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <1421747878-30744-6-git-send-email-famz@redhat.com> <54BE4F1D.7090807@gmail.com>
 <20150121045903.GA2858@fam-t430.nay.redhat.com> <54BF5ACE.6030206@gmail.com>
 <20150121085827.GB23024@ad.nay.redhat.com> <54BF814F.7090703@redhat.com>
 <20150121111404.GA3804@ad.nay.redhat.com> <54BF9294.3070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54BF9294.3070902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fam Zheng <famz@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hugh>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 21, 2015 at 3:50 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 21/01/2015 12:14, Fam Zheng wrote:
>> > My take for simplicity will be leaving epoll_ctl as-is, and my take for
>> > performance will be epoll_pwait1. And I don't really like putting my time on
>> > epoll_ctl_batch, thinking it as a ambivalent compromise in between.
>>
>> > I agree with Michael actually.  The big change is going from O(n)
>> > epoll_ctl calls to O(1), and epoll_ctl_batch achieves that just fine.
>> > Changing 2 syscalls to 1 is the icing on the cake, but we're talking of
>> > a fraction of a microsecond.
>>
>> Maybe I'm missing something, but in common cases, the set of fds for epoll_wait
>> doesn't change that radically from one iteration to another, does it?
>
> That depends on the application.

In my application, the set of fds almost never changes, but the set of
events I want changes all the time.  The main thing that changes is
whether I care about EPOLLOUT.  If I'm ready to send something, then I
want EPOLLOUT.  If I'm not ready, then I don't want EPOLLOUT.

--Andy
