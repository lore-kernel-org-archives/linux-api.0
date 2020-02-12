From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
Date: Wed, 12 Feb 2020 11:49:58 -0800
Message-ID: <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-8-gladkov.alexey@gmail.com> <87v9odlxbr.fsf@x220.int.ebiederm.org>
 <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
 <87tv3vkg1a.fsf@x220.int.ebiederm.org> <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
 <87v9obipk9.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87v9obipk9.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>Ke
List-Id: linux-api@vger.kernel.org

On Wed, Feb 12, 2020 at 11:18 AM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> > So it's just fs_info that needs to be rcu-delayed because it contains
> > that list. Or is there something else?
>
> The fundamental dcache thing we are playing with is:
>
>         dentry = d_hash_and_lookup(proc_root, &name);
>         if (dentry) {
>                 d_invalidate(dentry);
>                 dput(dentry);
>         }

Ahh. And we can't do that part under the RCU read lock. So it's not
the freeing, it's the list traversal itself.

Fair enough.

Hmm.

I wonder if we could split up d_invalidate(). It already ends up being
two phases: first the unhashing under the d_lock, and then the
recursive shrinking of parents and children.

The recursive shrinking of the parent isn't actually interesting for
the proc shrinking case: we just looked up one child, after all. So we
only care about the d_walk of the children.

So if we only did the first part under the RCU lock, and just
collected the dentries (can we perhaps then re-use the hash list to
collect them to another list?) and then did the child d_walk
afterwards?

             Linus
