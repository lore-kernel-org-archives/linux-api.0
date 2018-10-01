From: Bruce Fields <bfields@fieldses.org>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path
 resolution
Date: Mon, 1 Oct 2018 09:55:58 -0400
Message-ID: <20181001135558.GB25003@fieldses.org>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <20181001054246.gfinmx3api7kjhmc@ryuk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181001054246.gfinmx3api7kjhmc@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 01, 2018 at 03:44:28PM +1000, Aleksa Sarai wrote:
> On 2018-09-29, Jann Horn <jannh@google.com> wrote:
> > The problem is what happens if a folder you are walking through is
> > concurrently moved out of the chroot. Consider the following scenario:
> > 
> > You attempt to open "C/../../etc/passwd" under the root "/A/B".
> > Something else concurrently moves /A/B/C to /A/C. This can result in
> > the following:
> > 
> > 1. You start the path walk and reach /A/B/C.
> > 2. The other process moves /A/B/C to /A/C. Your path walk is now at /A/C.
> > 3. Your path walk follows the first ".." up into /A. This is outside
> > the process root, but you never actually encountered the process root,
> > so you don't notice.
> > 4. Your path walk follows the second ".." up to /. Again, this is
> > outside the process root, but you don't notice.
> > 5. Your path walk walks down to /etc/passwd, and the open completes
> > successfully. You now have an fd pointing outside your chroot.
> > 
> > If the root of your walk is below an attacker-controlled directory,
> > this of course means that you lose instantly. If you point the root of
> > the walk at a directory out of which a process in the container
> > wouldn't be able to move the file, you're probably kinda mostly fine -
> > as long as you know, for certain, that nothing else on the system
> > would ever do that. But I still wouldn't feel good about that.
> 
> Please correct me if I'm wrong here (this is the first patch I've
> written for VFS). Isn't the retry/LOOKUP_REVAL code meant to handle this

No.

...
> Speaking naively, doesn't it make sense to invalidate the walk if a path
> component was modified? Or is this something that would be far too
> costly with little benefit?

Lookups and renames can definitely proceed in parallel, and yes I
suspect it would be difficult to get good performance and guaranteed
forward progress if you required lookup of the full path to be atomic
with respect to renames.

--b.
