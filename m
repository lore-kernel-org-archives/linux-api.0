From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: For review: documentation of clone3() system call
Date: Tue, 29 Oct 2019 17:04:13 +0100
Message-ID: <20191029160412.jfnwlgaxhyvqpqga@wittgenstein>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <CAG48ez3q=BeNcuVTKBN79kJui4vC6nw0Bfq6xc-i0neheT17TA@mail.gmail.com>
 <20191028172143.4vnnjpdljfnexaq5@wittgenstein>
 <CAG48ez20hn8vToY+=C62nA-rbUfxh=JD6N-f7XVS3_GZOoPjxw@mail.gmail.com>
 <20191029112706.p5dd5yzpcgouo6n5@wittgenstein>
 <20191029142622.jxmssu4s4ndui7bw@wittgenstein>
 <87wocn39fu.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wocn39fu.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 29, 2019 at 03:36:37PM +0100, Florian Weimer wrote:
> * Christian Brauner:
> 
> > @Florian, do you have an opinion about always passing the stack from the
> > lowest address with clone3()?
> 
> Do you mean that the stack extends from stack to stack_size?  I guess

Specifically, that userspace doesn't need to know whether it needs to
pass stack or stack + stack_size. The kernel will just do the stack + stack_size
if the architecture has a downwards growing stack. So for _all_
architectures, ia64 or not, you'd always pass:

void *p[PAGE_SIZE];

struct clone_args args = {
	.stack = p,
	.stack_size = PAGE_SIZE,
};


> that makes sense.  What about architectures which need two stacks (I
> think ia64 is one)?

I don't think ia64 needs any special treament. ia64 requires you to pass
the lowest address of the stack and the kernel does the additon to reach
the top of the stack and the alignemnt too. So ia64 _in the kernel_
currently does:

arch/ia64/kernel/entry.S:sys_clone2()
- setup stack and stack size and call into do_fork()
  -> kernel/fork.c:do_fork()
     -> copy_thread_tls()
       -> arch/ia64/kernel/process.c:copy_thread():

	if (user_stack_base) {
		child_ptregs->r12 = user_stack_base + user_stack_size - 16;
		child_ptregs->ar_bspstore = user_stack_base;
		child_ptregs->ar_rnat = 0;
		child_ptregs->loadrs = 0;
	}

> There is also the matter whose responsibility is the alignment of the
> initial stack pointer.

Hm, probably also a detail that userspace shouldn't need to know
about?

Christian
