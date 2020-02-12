From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
Date: Wed, 12 Feb 2020 15:46:29 -0600
Message-ID: <87lfp7h422.fsf@x220.int.ebiederm.org>
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
        <87v9odlxbr.fsf@x220.int.ebiederm.org>
        <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
        <87tv3vkg1a.fsf@x220.int.ebiederm.org>
        <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
        <87v9obipk9.fsf@x220.int.ebiederm.org>
        <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
        <20200212200335.GO23230@ZenIV.linux.org.uk>
        <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
        <20200212203833.GQ23230@ZenIV.linux.org.uk>
        <20200212204124.GR23230@ZenIV.linux.org.uk>
        <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 12 Feb 2020 13:02:40 -0800")
Sender: owner-linux-security-module@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, Kees
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Feb 12, 2020 at 12:41 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> On Wed, Feb 12, 2020 at 08:38:33PM +0000, Al Viro wrote:
>> >
>> > Wait, I thought the whole point of that had been to allow multiple
>> > procfs instances for the same userns?  Confused...
>>
>> s/userns/pidns/, sorry
>
> Right, but we still hold the ref to it here...
>
> [ Looks more ]
>
> Oooh. No we don't. Exactly because we don't hold the lock, only the
> rcu lifetime, the ref can go away from under us. I see what your
> concern is.
>
> Ouch, this is more painful than I expected - the code flow looked so
> simple. I really wanted to avoid a new lock during process shutdown,
> because that has always been somewhat painful.

The good news is proc_flush_task isn't exactly called from process exit.
proc_flush_task is called during zombie clean up. AKA release_task.

So proc_flush_task isn't called with any locks held, and it is
called in a context where it can sleep.

Further after proc_flush_task does it's thing the code goes
and does "write_lock_irq(&task_list_lock);"

So the code is definitely serialized to one processor already.

What would be downside of having a mutex for a list of proc superblocks?
A mutex that is taken for both reading and writing the list.

Eric
