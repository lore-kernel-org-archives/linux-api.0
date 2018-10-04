From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path
 resolution
Date: Thu, 4 Oct 2018 19:27:34 +0200
Message-ID: <20181004172733.x75nmwqan2iu3kyv@brauner.io>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <20181001054246.gfinmx3api7kjhmc@ryuk>
 <CAG48ez3ApZC5cGzTxyt1ej0CyhYPD4PUEf5nbkqPmNbO+daOXQ@mail.gmail.com>
 <20181001161833.sg5iy6gk7n7crcvy@ryuk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181001161833.sg5iy6gk7n7crcvy@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 02, 2018 at 02:18:33AM +1000, Aleksa Sarai wrote:
> On 2018-10-01, Jann Horn <jannh@google.com> wrote:
> > > If this is an issue for AT_THIS_ROOT, I believe this might also be an
> > > issue for AT_BENEATH since they are effectively both using the same
> > > nd->root trick (so you could similarly trick AT_BENEATH to not error
> > > out). So we'd need to figure out how to solve this problem in order for
> > > AT_BENEATH to be safe.
> > 
> > Oh, wait, what? I think I didn't notice that the semantics of
> > AT_BENEATH changed like that since the original posting of David
> > Drysdale's O_BENEATH_ONLY patch
> > (https://lore.kernel.org/lkml/1439458366-8223-2-git-send-email-drysdale@google.com/).
> > David's patch had nice, straightforward semantics, blocking any form
> > of upwards traversal. Why was that changed? Does anyone actually want
> > to use paths that contain ".." with AT_BENEATH? I would strongly
> > prefer something that blocks any use of "..".
> > 
> > @Al: It looks like this already changed back when you posted
> > https://lore.kernel.org/lkml/20170429220414.GT29622@ZenIV.linux.org.uk/
> > ?
> 
> Yes, I copied the semantics from Al's patchset. I don't know why he felt
> strongly that this was the best idea, but in my opinion allowing paths
> like "a/../b/../c" seems like it's quite useful because otherwise you
> wouldn't be able to operate on most distribution root filesystems (many
> have symlinks that have ".." components). Looking at my own (openSUSE)
> machine there are something like 100k such symlinks (~37% of symlinks on
> my machine).
> 
> While I do understand that the easiest way of solving this problem is to
> disallow ".." entirely with AT_BENEATH, given that support ".." has
> utility, I would like to know whether it's actually not possible to have
> this work safely.
> 
> > > Speaking naively, doesn't it make sense to invalidate the walk if a path
> > > component was modified? Or is this something that would be far too
> > > costly with little benefit? What if we do more aggressive nd->root
> > > checks when resolving with AT_BENEATH or AT_THIS_ROOT (or if nd->root !=
> > > current->mnt_ns->root)?
> > 
> > It seems to me like doing that would basically require looking at each
> > node in the path walk twice? And it'd be difficult to guarantee
> > forward progress unless you're willing to do some fairly heavy
> > locking.
> 
> I had another idea since I wrote my previous mail -- since the issue (at
> least the way I understand it) is that ".." can "skip" over nd->root
> because of the rename, what if we had some sort of is_descendant() check
> within follow_dotdot()? (FWIW, ".." already has some pretty interesting
> "hand-over-hand" locking semantics.) This should be effectively similar
> to how prepend_path() deals with a path that is not reachable from @root
> (I'm not sure if the locking is acceptable for the namei path though).
> 
> Since ".." with AT_THIS_ROOT (or AT_BENEATH) is not going to be the most
> common component type (and we only need to do these checks for those
> flags), I would think that the extra cost would not be _that_ awful.
> 
> Would this work?
> 
> > > You're right about this -- for C runtimes. In Go we cannot do a raw
> > > clone() or fork() (if you do it manually with RawSyscall you'll end with
> > > broken runtime state). So you're forced to do fork+exec (which then
> > > means that you can't use CLONE_FILES and must use SCM_RIGHTS). Same goes
> > > for CLONE_VFORK.
> > 
> > If you insist on implementing every last bit of your code in Go, I guess.
> 
> Fair enough, though I believe this would affect most multi-threaded
> programs as well (regardless of the language they're written in).

(Depends on whether you do any explicit locking and have atfork handlers
for your locks and so on. If you do a clone syscall directly to avoid
having libc running any additional atfork handlers (flushing streams
etc.) it's doable though not ideal.)
