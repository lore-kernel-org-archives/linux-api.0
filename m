From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Thu, 29 Aug 2019 13:47:22 -0400
Message-ID: <20190829134722.528ecce1@gandalf.local.home>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190828071421.GK2332@hirez.programming.kicks-ass.net>
        <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
        <20190829093434.36540972@gandalf.local.home>
        <20190829171922.hkuceiurscsxk5jq@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829171922.hkuceiurscsxk5jq@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 29 Aug 2019 10:19:24 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Aug 29, 2019 at 09:34:34AM -0400, Steven Rostedt wrote:
> > 
> > As the above seems to favor the idea of CAP_TRACING allowing write
> > access to tracefs, should we have a CAP_TRACING_RO for just read access
> > and limited perf abilities?  
> 
> read only vs writeable is an attribute of the file system.
> Bringing such things into caps seem wrong to me.

So using groups then? I'm fine with that.

-- Steve
