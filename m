From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs
 instances
Date: Wed, 12 Feb 2020 20:41:24 +0000
Message-ID: <20200212204124.GR23230@ZenIV.linux.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200212203833.GQ23230@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 12, 2020 at 08:38:33PM +0000, Al Viro wrote:
> On Wed, Feb 12, 2020 at 12:35:04PM -0800, Linus Torvalds wrote:
> > On Wed, Feb 12, 2020 at 12:03 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > What's to prevent racing with fs shutdown while you are doing the second part?
> > 
> > I was thinking that only the proc_flush_task() code would do this.
> > 
> > And that holds a ref to the vfsmount through upid->ns.
> > 
> > So I wasn't suggesting doing this in general - just splitting up the
> > implementation of d_invalidate() so that proc_flush_task_mnt() could
> > delay the complex part to after having traversed the RCU-protected
> > list.
> > 
> > But hey - I missed this part of the problem originally, so maybe I'm
> > just missing something else this time. Wouldn't be the first time.
> 
> Wait, I thought the whole point of that had been to allow multiple
> procfs instances for the same userns?  Confused...

s/userns/pidns/, sorry
