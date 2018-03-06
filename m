From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Tue, 6 Mar 2018 20:01:21 +0000
Message-ID: <CALCETrVO6dc6Fzf2VPjLF1Z+YHU=di_fh53+EhcRqt3V+wQDuA@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306013457.1955486-1-ast@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 6, 2018 at 1:34 AM, Alexei Starovoitov <ast@kernel.org> wrote:
> As the first step in development of bpfilter project [1] the request_module()
> code is extended to allow user mode helpers to be invoked. Idea is that
> user mode helpers are built as part of the kernel build and installed as
> traditional kernel modules with .ko file extension into distro specified
> location, such that from a distribution point of view, they are no different
> than regular kernel modules. Thus, allow request_module() logic to load such
> user mode helper (umh) modules via:
>
>   request_module("foo") ->
>     call_umh("modprobe foo") ->
>       sys_finit_module(FD of /lib/modules/.../foo.ko) ->
>         call_umh(struct file)
>

I assume I'm missing some context here, but why does this need to be
handled by the kernel rather than, say, a change to how modprobe
works?  I imagine that usermode tooling needs to change regardless
because the existing tools may get rather confused if a .ko "module"
is really a dynamically liked program.  I notice that you're using
ET_EXEC in your example, and that will probably avoid problems, but I
imagine that some distros would much rather use ET_DYN.
