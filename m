From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Tue, 6 Mar 2018 12:26:56 -0800
Message-ID: <CA+55aFzog9eAgkrLF20zXKu7zq3k9Oz6zg0ekiwXZjZZEWLCNA@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CALCETrVO6dc6Fzf2VPjLF1Z+YHU=di_fh53+EhcRqt3V+wQDuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVO6dc6Fzf2VPjLF1Z+YHU=di_fh53+EhcRqt3V+wQDuA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 6, 2018 at 12:01 PM, Andy Lutomirski <luto@kernel.org> wrote:
>
> I assume I'm missing some context here, but why does this need to be
> handled by the kernel rather than, say, a change to how modprobe
> works?

Honestly, the less we have to mess with user-mode tooling, the better.

We've been *so* much better off moving most of the module loading
logic to the kernel, we should not go back in the old broken
direction.

I do *not* want the kmod project that is then taken over by systemd,
and breaks it the same way they broke firmware loading.

Keep modprobe doing one thing, and one thing only: track dependencies
and mindlessly just load the modules. Do *not* ask for it to do
anything else.

Right now kmod is a nice simple project. Lots of testsuite stuff, and
a very clear goal. Let's keep kmod doing one thing, and not even have
to care about internal kernel decisions like "oh, this module might
not be a module, but an executable".

If anything, I think we want to keep our options open, in the case we
need or want to ever consider short-circuiting things and allowing
direct loading of the simple cases and bypassing modprobe entirely.

               Linus
