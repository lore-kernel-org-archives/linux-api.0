From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Tue, 27 Aug 2019 22:22:36 -0400
Message-ID: <20190827222236.297855a1@oasis.local.home>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190827192144.3b38b25a@gandalf.local.home>
        <CALCETrUOHRMkBRJi_s30CjZdOLDGtdMOEgqfgPf+q0x+Fw7LtQ@mail.gmail.com>
        <20190827204433.3af91faf@gandalf.local.home>
        <A95DA1BC-E2A1-4CC3-B17F-36C494FB7540@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <A95DA1BC-E2A1-4CC3-B17F-36C494FB7540@amacapital.net>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Aug 2019 18:12:59 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

> Too many slashes :/
> 
> A group could work for v1.  Maybe all the tools should get updated to use this path?

trace-cmd now does. In fact, if run as root, it will first check if
tracefs is mounted, and if not, it will try to mount it at this
location.

-- Steve
