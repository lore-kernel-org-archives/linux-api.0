From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: trace_printk issue. Was: [PATCH bpf-next] bpf, capabilities:
 introduce CAP_BPF
Date: Thu, 3 Oct 2019 09:18:40 -0700
Message-ID: <20191003161838.7lz746aa2lzl7qi4@ast-mbp.dhcp.thefacebook.com>
References: <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home>
 <201909301129.5A1129C@keescook>
 <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
 <20191001181052.43c9fabb@gandalf.local.home>
 <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
 <20191001184731.0ec98c7a@gandalf.local.home>
 <a98725c6-a7db-1d9f-7033-5ecd96438c8d@fb.com>
 <20191002190027.4e204ea8@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191002190027.4e204ea8@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 02, 2019 at 07:00:27PM -0400, Steven Rostedt wrote:
> > >>>>
> > >>>> Both 'trace' and 'trace_pipe' have quirky side effects.
> > >>>> Like opening 'trace' file will make all parallel trace_printk() to be ignored.
> > >>>> While reading 'trace_pipe' file will clear it.
> > >>>> The point that traditional 'read' and 'write' ACLs don't map as-is
> > >>>> to tracefs, so I would be careful categorizing things into
> > >>>> confidentiality vs integrity only based on access type.  
> > >>>
> > >>> What exactly is the bpf_trace_printk() used for? I may have other ideas
> > >>> that can help.  
> > >>
> > >> It's debugging of bpf programs. Same is what printk() is used for
> > >> by kernel developers.
> > >>  
> > > 
> > > How is it extracted? Just read from the trace or trace_pipe file?  
> > 
> > yep. Just like kernel devs look at dmesg when they sprinkle printk.
> > btw, if you can fix 'trace' file issue that stops all trace_printk
> > while 'trace' file is open that would be great.
> > Some users have been bitten by this behavior. We even documented it.
> 
> The behavior is documented as well in the ftrace documentation. That's
> why we suggest the trace_pipe redirected into a file so that you don't
> lose data (unless the writer goes too fast). If you prefer a producer
> consumer where you lose newer events (like perf does), you can turn off
> overwrite mode, and it will drop events when the buffer is full (see
> options/overwrite).

I think dropping last events is just as bad. Is there a mode to overwrite old
and keep the last N (like perf does) ?
That aside having 'trace' file open should NOT drop trace_printks.
My point that bpf_trace_printk is just as important to bpf developers as
printk to kernel developers.
Imagine kernel developer losing their printk-s only because they typed
"dmesg" in another terminal?
It's completely unexpected and breaks developer trust in debugging mechanism.
Peter Wu brought this issue to my attention in
commit 55c33dfbeb83 ("bpf: clarify when bpf_trace_printk discards lines").
And later sent similar doc fix to ftrace.rst.
To be honest if I knew of this trace_printk quirk I would not have picked it
as a debugging mechanism for bpf.
I urge you to fix it.
