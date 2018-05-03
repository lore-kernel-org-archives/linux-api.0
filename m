From: Christian Brauner <christian.brauner@canonical.com>
Subject: Re: [PATCH 0/6 resend] statfs: handle mount propagation
Date: Thu, 3 May 2018 15:04:36 +0200
Message-ID: <CAPP7u0VPyWAsL_kkb4JnJHMmK=kM0m4zRjVjst1iHDd6V=t0mQ@mail.gmail.com>
References: <20180502154239.14013-1-christian.brauner@ubuntu.com> <20180502160939.GU30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502160939.GU30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hch@infradead.org, tglx@linutronix.de, kstewart@linuxfoundation.org, Greg KH <gregkh@linuxfoundation.org>, pombredanne@nexb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 02, 2018 at 05:09:39PM +0100, Al Viro wrote:
> On Wed, May 02, 2018 at 05:42:33PM +0200, Christian Brauner wrote:
> > Hey,
> >
> > This is the second resend of this patchset. I'm not sure whether it has
> > simply been overlooked but the number of people get_maintainer.pl was
> > rather small and seemed a little random so I added Linus and Christoph,
> > two people I know that do look at VFS stuff at least from time to time,
> > although they weren't listed by get_maintainer.pl. I hope that's ok.
> >
> > This little series
> > - unifies the definition of constants in statfs.h and fs.h
> >   *Note, that Andreas has expressed doubts whether this unification is
> >   useful. Please see https://lkml.org/lkml/2018/4/13/571 . I still think
> >   it is but I'm happy to drop these two patches if others agree.*
> > - extends statfs to handle mount propagation. This will let userspace
> >   easily query a given mountpoint for MS_UNBINDABLE, MS_SHARED,
> >   MS_PRIVATE and MS_SLAVE without always having to do costly parsing of
> >   /proc/<pid>/mountinfo.
> >   To this end the flags:
> >   - ST_UNBINDABLE
> >   - ST_SHARED
> >   - ST_PRIVATE
> >   - ST_SLAVE
> >   are added. They have the same value as their MS_* counterparts.
>
> How about some rationale for that in the first place?  statfs() looks like
> a bad match for that - not to mention anything else, there's no way to
> get anything beyond "it is a peer of something", not even "do these two
> get propagation between them".  What would be using that, what would the
> userland side of users look like, etc...

Ok, sorry if I wasn't detailed enough.

>From a userspace perspective we often run into the case where we simply
want to know whether a given mountpoint is MS_SHARED or is MS_SLAVE.
If it is we remount it as MS_PRIVATE to prevent any propagation from
happening. We don't care about the peer relationship or how the
propagation is exactly setup. We only want to prevent any propagation
from happening.

The above case is what I see most often. A more specific use-case is to
differentiate between MS_SLAVE and MS_SHARED mountpoints.
Mountpoints that are MS_SLAVE are kept intact and mountpoints that are
MS_SHARED are made MS_PRIVATE.

For both cases the only way to do this right now is by parsing
/proc/<pid>/mountinfo. Yes, it is doable but still it is somewhat costly
and annoying as e.g. those mount propagation fields are optional.

Another problem are scenarios where propagation matters but /proc is not
mounted.

Here are three concrete use-cases I run into frequently:
- (*buzzword alarm*) container runtimes:
  They do usually clone(CLONE_NEWNS) and inherit the mount table but
  want to remount specific mountpoints to prevent propagation.
  Again the specifics of propagation don't matter in this case usually.

- Sharing shared mountpoints:
  Sometimes it is desirable to share shared mountpoints between
  namespaces.
  Say, the first process sets up the shared mountpoint on the host and
  all the other ones want to know "Did someone already make this rshared
  or do i need to set this up?". It would be very helpful if you could
  just check a mount by using the statvfs() syscall.

- I want to know whether a mountpoint is unbindable to e.g. skip it if
  it is or remount it.

About how this would work what I simply expect and tested with this
patch was e.g. this:

int ret;
char *s = "/some/path";
struct statvfs sb;

ret = statvfs(s, &sb);
if (ret < 0)
        return false;

if (sb.f_flag & ST_SHARED) {
        ret = mount("", s, NULL, MS_SLAVE | MS_REC, NULL);
        if (ret < 0)
                return -1;
}

>
> And in any case linux-api should've been Cc'd.  I'm not saying that this

Ah, thanks! Sorry I missed this.

> (or something similar) would be an inherently bad idea, but the question
> "why this way?" deserves a bit more than "parsing is costly"...

I hope some of the above helped to clarify this.

Thanks!
Christian
