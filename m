From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v5 24/25] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Tue, 11 Dec 2018 16:29:54 +0100
Message-ID: <20181211152953.GA8504@redhat.com>
References: <20181210042352.GA6092@altlinux.org>
 <20181210043126.GX6131@altlinux.org>
 <20181210141107.GB4177@redhat.com>
 <20181210162131.GG14149@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181210162131.GG14149@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirski <luto@kernel.org>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org, strace-devel@lists.strace.io, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12/10, Dmitry V. Levin wrote:
>
> On Mon, Dec 10, 2018 at 03:11:07PM +0100, Oleg Nesterov wrote:
> > On 12/10, Dmitry V. Levin wrote:
> > >
> > > +struct ptrace_syscall_info {
> > > +	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
> > > +	__u8 __pad0[3];
> > > +	__u32 arch;
> > > +	__u64 instruction_pointer;
> > > +	__u64 stack_pointer;
> > > +	__u64 frame_pointer;
> > > +	union {
> > > +		struct {
> > > +			__u64 nr;
> > > +			__u64 args[6];
> > > +		} entry;
> > > +		struct {
> > > +			__s64 rval;
> > > +			__u8 is_error;
> > > +			__u8 __pad1[7];
> > > +		} exit;
> > > +		struct {
> > > +			__u64 nr;
> > > +			__u64 args[6];
> > > +			__u32 ret_data;
> > > +			__u8 __pad2[4];
> > > +		} seccomp;
> > > +	};
> > > +};
> >
> > Could you explain why ptrace_syscall_info needs __pad{0,1,2} ? I simply can't
> > understand why...
>
> I suppose the idea behind the use of these pads was to make the structure
> arch-independent.

Still can't understand... are you saying that without (say) __pad2[4]
sizeof(ptrace_syscall_info) or offsetofend(ptrace_syscall_info, seccomp)
will depend on arch? Or what? I am just curious.

> I don't think we really need to keep it exactly the same on all
> architectures - the only practical requirement is to avoid any compat
> issues, but I don't mind keeping the structure arch-independent.

OK, but may be you can add a short comment to explain these pads.

Oleg.
