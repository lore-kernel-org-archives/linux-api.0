From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v7 07/11] proc: flush task dcache entries from all procfs instances
Date: Sat, 25 Jan 2020 10:45:25 -0800
Message-ID: <CAHk-=wiGNSQCA8TYa1Akp0_GRpe=ELKDPkDX5nzM5R=oDy1U+Q@mail.gmail.com>
References: <20200125130541.450409-1-gladkov.alexey@gmail.com> <20200125130541.450409-8-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200125130541.450409-8-gladkov.alexey@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 25, 2020 at 5:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> This allows to flush dcache entries of a task on multiple procfs mounts
> per pid namespace.

>From a quick read-through, this is the only one I really react negatively to.

The locking looks odd. It only seems to protect the new proc_mounts
list, but then it's a whole big rwsem, and it's taken over all of
proc_flush_task_mnt(), and the locking is exported to all over as a
result of that - including the dummy functions for "there is no proc"
case.

And proc_flush_task_mnt() itself should need no locking over any of
it, so it's all just for the silly looping over the list.

So

 (a) this looks fishy and feels wrong - I get a very strong feeling
that the locking is wrong to begin with, and could/should have been
done differently

 (b) all the locking should have been internal to /proc, and those
wrappers shouldn't exist in a common header file (and certainly not
for the non-proc case).

Yes, (a) is just a feeling, and I don't have any great suggestions.
Maybe make it an RCU list and use a spinlock for updating it?

But (b) is pretty much a non-starter in this form. Those wrappers
shouldn't be in a globally exported core header file. No way.

               Linus
