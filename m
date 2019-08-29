From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Thu, 29 Aug 2019 13:49:06 -0400
Message-ID: <20190829134906.7ecae4e2@gandalf.local.home>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190828071421.GK2332@hirez.programming.kicks-ass.net>
        <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
        <20190829093434.36540972@gandalf.local.home>
        <CALCETrWYu0XB_d-MhXFgopEmBu-pog493G1e+KsE3dS32UULgA@mail.gmail.com>
        <20190829172309.xd73ax4wgsjmv6zg@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829172309.xd73ax4wgsjmv6zg@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 29 Aug 2019 10:23:10 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > CAP_TRACE_KERNEL: Use all of perf, ftrace, kprobe, etc.
> > 
> > CAP_TRACE_USER: Use all of perf with scope limited to user mode and uprobes.  
> 
> imo that makes little sense from security pov, since
> such CAP_TRACE_KERNEL (ex kprobe) can trace "unrelated user process"
> just as well. Yet not letting it do cleanly via uprobe.
> Sort of like giving a spare key for back door of the house and
> saying no, you cannot have main door key.

I took it as CAP_TRACE_KERNEL as a superset of CAP_TRACE_USER. That is,
if you have CAP_TRACE_KERNEL, by default you get USER. Where as
CAP_TRACE_USER, is much more limiting.

-- Steve
