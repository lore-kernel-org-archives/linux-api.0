From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs
 instances
Date: Mon, 10 Feb 2020 19:23:02 +0000
Message-ID: <20200210192302.GI23230@ZenIV.linux.org.uk>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-8-gladkov.alexey@gmail.com>
 <CAHk-=wh05FniF0xJYqcFrmGeCvOJUqR0UL4jTC-_LvpsfNCkNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wh05FniF0xJYqcFrmGeCvOJUqR0UL4jTC-_LvpsfNCkNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 10, 2020 at 09:46:26AM -0800, Linus Torvalds wrote:
> On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > This allows to flush dcache entries of a task on multiple procfs mounts
> > per pid namespace.
> >
> > The RCU lock is used because the number of reads at the task exit time
> > is much larger than the number of procfs mounts.
> 
> Ok, this looks better to me than the previous version.
> 
> But that may be the "pee-in-the-snow" effect, and I _really_ want
> others to take a good look at the whole series.
> 
> The right people seem to be cc'd, but this is pretty core, and /proc
> has a tendency to cause interesting issues because of how it's
> involved in a lot of areas indirectly.
> 
> Al, Oleg, Andy, Eric?

Will check tonight (ears-deep in sorting out the old branches right now)
