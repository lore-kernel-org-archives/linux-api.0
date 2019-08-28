From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Tue, 27 Aug 2019 21:47:34 -0700
Message-ID: <20190828044733.vvudyncwq5nffe4l@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190827192144.3b38b25a@gandalf.local.home>
 <20190828123041.c0c90c15865897461ee819a2@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190828123041.c0c90c15865897461ee819a2@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 28, 2019 at 12:30:41PM +0900, Masami Hiramatsu wrote:
> > kprobes can be created in the tracefs filesystem (which is separate from
> > debugfs, tracefs just gets automatically mounted
> > in /sys/kernel/debug/tracing when debugfs is mounted) from the
> > kprobe_events file. /sys/kernel/tracing is just the tracefs
> > directory without debugfs, and was created specifically to allow
> > tracing to be access without opening up the can of worms in debugfs.
> 
> I like the CAP_TRACING for tracefs. Can we make the tracefs itself
> check the CAP_TRACING and call file_ops? or each tracefs file-ops
> handlers must check it?

Thanks for the feedback.
I'll hack a prototype of CAP_TRACING for perf bits that I understand
and you folks will be able to use it in ftrace when initial support lands.
imo the question above is an implementation detail that you can resolve later.
I see it as a followup to initial CAP_TRACING drop.
