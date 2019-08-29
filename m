From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Thu, 29 Aug 2019 10:23:10 -0700
Message-ID: <20190829172309.xd73ax4wgsjmv6zg@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828071421.GK2332@hirez.programming.kicks-ass.net>
 <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
 <20190829093434.36540972@gandalf.local.home>
 <CALCETrWYu0XB_d-MhXFgopEmBu-pog493G1e+KsE3dS32UULgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWYu0XB_d-MhXFgopEmBu-pog493G1e+KsE3dS32UULgA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 08:43:23AM -0700, Andy Lutomirski wrote:
> 
> I can imagine splitting it into three capabilities:
> 
> CAP_TRACE_KERNEL: learn which kernel functions are called when.  This
> would allow perf profiling, for example, but not sampling of kernel
> regs.
> 
> CAP_TRACE_READ_KERNEL_DATA: allow the tracing, profiling, etc features
> that can read the kernel's data.  So you get function arguments via
> kprobe, kernel regs, and APIs that expose probe_kernel_read()
> 
> CAP_TRACE_USER: trace unrelated user processes
> 
> I'm not sure the code is written in a way that makes splitting
> CAP_TRACE_KERNEL and CAP_TRACE_READ_KERNEL_DATA, and I'm not sure that
> CAP_TRACE_KERNEL is all that useful except for plain perf record
> without CAP_TRACE_READ_KERNEL_DATA.  What do you all think?  I suppose
> it could also be:
> 
> CAP_PROFILE_KERNEL: Use perf with events that aren't kprobes or
> tracepoints.  Does not grant the ability to sample regs or the kernel
> stack directly.
> 
> CAP_TRACE_KERNEL: Use all of perf, ftrace, kprobe, etc.
> 
> CAP_TRACE_USER: Use all of perf with scope limited to user mode and uprobes.

imo that makes little sense from security pov, since
such CAP_TRACE_KERNEL (ex kprobe) can trace "unrelated user process"
just as well. Yet not letting it do cleanly via uprobe.
Sort of like giving a spare key for back door of the house and
saying no, you cannot have main door key.
