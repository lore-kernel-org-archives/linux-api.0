From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Tue, 27 Aug 2019 19:00:40 -0700
Message-ID: <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com>
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com> <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> On Aug 27, 2019, at 5:55 PM, Andy Lutomirski <luto@kernel.org> wrote:
>
> On Tue, Aug 27, 2019 at 5:34 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>

> From the previous discussion, you want to make progress toward solving
> a lot of problems with CAP_BPF.  One of them was making BPF
> firewalling more generally useful. By making CAP_BPF grant the ability
> to read kernel memory, you will make administrators much more nervous
> to grant CAP_BPF.  Similarly, and correct me if I'm wrong, most of
> these capabilities are primarily or only useful for tracing, so I
> don't see why users without CAP_TRACING should get them.
> bpf_trace_printk(), in particular, even has "trace" in its name :)
>
> Also, if a task has CAP_TRACING, it's expected to be able to trace the
> system -- that's the whole point.  Why shouldn't it be able to use BPF
> to trace the system better?

Let me put this a bit differently. Part of the point is that
CAP_TRACING should allow a user or program to trace without being able
to corrupt the system. CAP_BPF as you=E2=80=99ve proposed it *can* likely
crash the system.  For example, CAP_BPF allows bpf_map_get_fd_by_id()
in your patch.  If the system uses a BPF firewall that stores some of
its rules in maps, then bpf_map_get_fd_by_id() can be used to get a
writable fd to the map, which can be used to change the map, thus
preventing network access.  This means that no combination of
CAP_TRACING and CAP_BPF ends up allowing tracing without granting the
ability to reconfigure or otherwise corrupt the system.
