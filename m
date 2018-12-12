From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v5 24/25] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Wed, 12 Dec 2018 19:00:17 +0100
Message-ID: <20181212180017.GB30309@redhat.com>
References: <20181210042352.GA6092@altlinux.org>
 <20181210043126.GX6131@altlinux.org>
 <20181210141107.GB4177@redhat.com>
 <20181210162131.GG14149@altlinux.org>
 <20181211152953.GA8504@redhat.com>
 <20181211162305.GA480@altlinux.org>
 <20181211202709.GA3839@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181211202709.GA3839@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirski <luto@kernel.org>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org, strace-devel@lists.strace.io, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12/11, Dmitry V. Levin wrote:
>
> > > Still can't understand... are you saying that without (say) __pad2[4]
> > > sizeof(ptrace_syscall_info) or offsetofend(ptrace_syscall_info, seccomp)
> > > will depend on arch? Or what? I am just curious.
> >
> > Yes, without padding these sizes will depend on architecture:
>
> > $ cat t.c
> > #include <linux/types.h>
> > int main() {
> > 	struct s {
> > 		__u64 nr;
> > 		__u64 args[6];
> > 		__u32 ret_data;
> > 	};
> > 	return sizeof(struct s);
> > }
> >
> > $ gcc -m64 -Wall -O2 t.c && ./a.out; echo $?
> > 64
> > $ gcc -m32 -Wall -O2 t.c && ./a.out; echo $?
> > 60
> >
> > This happens because __u64 has 32-bit alignment on some 32-bit
> > architectures like x86.
> >
> > There is also m68k where __u32 has 16-bit alignment.

OK, thanks,

> Said that, I think it would be better if PTRACE_GET_SYSCALL_INFO
> did not take these trailing pads into account, e.g.
>
> -       return offsetofend(struct ptrace_syscall_info, seccomp);
> +       return offsetofend(struct ptrace_syscall_info, seccomp.ret_data);
> ...
> -       return offsetofend(struct ptrace_syscall_info, exit);
> +       return offsetofend(struct ptrace_syscall_info, exit.is_error);
>
> The reason is that it would allow to fill these trailing pads with
> something useful in the future.

Agreed.

But this way everything looks even more confusing. To me it would be
better to simply remove these pads, but I won't insist.

Oleg.
