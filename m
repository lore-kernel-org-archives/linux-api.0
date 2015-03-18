From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCHv3 xfstests 2/3] generic: test openat and new O_BENEATH
 flag
Date: Wed, 18 Mar 2015 13:52:38 +1100
Message-ID: <20150318025238.GC10105@dastard>
References: <1425909612-28034-1-git-send-email-drysdale@google.com>
 <1425909612-28034-3-git-send-email-drysdale@google.com>
 <20150316232434.GJ28557@dastard>
 <CAGXu5jLfrGrVO=9sF6=TK0QQHq4SWRjL0urGu-e+e1H8gk9Y3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLfrGrVO=9sF6=TK0QQHq4SWRjL0urGu-e+e1H8gk9Y3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 17, 2015 at 08:33:27AM -0700, Kees Cook wrote:
> On Mon, Mar 16, 2015 at 4:24 PM, Dave Chinner
> <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> > On Mon, Mar 09, 2015 at 02:00:11PM +0000, David Drysdale wrote:
> >> Test basic openat(2) behaviour.
> >>
> >> Test that if O_BENEATH flag is set, openat() will only open
> >> paths that have no .. component and do not start with /.
> >> Symlinks are also checked for the same restrictions.
> >>
> >> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> ---
> >> .gitignore            |   1 + common/openat         |  61
> >> ++++++++++++++++++++++++++++++ src/Makefile          |   3 +-
> >> src/openat.c          | 100
> >> +++++++++++++++++++++++++++++++++++++++++++++++++
> >
> > This strikes me as something that shoul dbe added to xfs_io for
> > testing, as it already supports a heap of other open flags and
> > xfstests is already dependent on it.
> 
> While I don't see a problem adding this to xfs_io, I'd still like
> to see this test live in the kernel tree too.

You can do whatever you want with the kernel tree - it doesn't
concern me at all.

> Having it in the
> same source means more testing, IMO.

That's complete bunk, though.  This helper binary is a limited use,
one shot test that can't be combined with anything else.  "sharing"
the source code across multiple different test suites doesn't change
that. However, putting support into xfs_io means it will get more
testing because we can *easily* use the functionality in many, many
different ways.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
