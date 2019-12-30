From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over symlinks
Date: Sun, 29 Dec 2019 23:53:47 -0800
Message-ID: <CAHk-=whxNw7hYT6bJn9mVrB_a=7Y-irmpaPsp1R4xbHHkicv7g@mail.gmail.com>
References: <20191230052036.8765-1-cyphar@cyphar.com> <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com> <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 29, 2019 at 11:30 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
>     BUG: kernel NULL pointer dereference, address: 0000000000000000

Would you mind building with debug info, and then running the oops through

 scripts/decode_stacktrace.sh

which makes those addresses much more legible.

>     #PF: supervisor instruction fetch in kernel mode
>     #PF: error_code(0x0010) - not-present page

Somebody jumped through a NULL pointer.

>     RAX: 0000000000000000 RBX: ffff906d0cc3bb40 RCX: 0000000000000abc
>     RDX: 0000000000000089 RSI: ffff906d74623cc0 RDI: ffff906d74475df0
>     RBP: ffff906d74475df0 R08: ffffd70b7fb24c20 R09: ffff906d066a5000
>     R10: 0000000000000000 R11: 8080807fffffffff R12: ffff906d74623cc0
>     R13: 0000000000000089 R14: ffffb70b82963dc0 R15: 0000000000000080
>     FS:  00007fbc2a8f0540(0000) GS:ffff906dcf500000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: ffffffffffffffd6 CR3: 00000003c68f8001 CR4: 00000000003606e0
>     Call Trace:
>      __lookup_slow+0x94/0x160

And "__lookup_slow()" has two indirect calls (they aren't obvious with
retpoline, but look for something  like

        call __x86_indirect_thunk_rax

which is the modern sad way of doing "call *%rax"). One is for
revalidatinging an old dentry, but the one I _suspect_ you trigger is
this one:

                old = inode->i_op->lookup(inode, dentry, flags);

but I thought we only could get here if we know it's a directory.

How did we miss the "d_can_lookup()", which is what should check that
yes, we can call that ->lookup() routine.

This is why I have that suspicion that it's somehow that O_PATH fd
opened in another process without O_PATH causes confusion...

So what I think has happened is that because of the O_PATH thing,
we've ended up with an inode that has never been truly opened (because
O_PATH skips that part), but then with the /proc/<pid>/fd/xyz open, we
now have a file descriptor that _looks_ like it is valid, and we're
treating that inode as if it can be used.

But I'm handwaving.

             Linus
