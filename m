From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Wed, 11 May 2016 16:02:21 -0500
Message-ID: <20160511210221.GA24015@mail.hallyn.com>
References: <1461345993-17526-2-git-send-email-serge.hallyn@ubuntu.com>
 <CAGXu5jKFNQs8oxq+yD6_Q8HcNyf+GouSHFzkxT9u9BkK=ZLQ7Q@mail.gmail.com>
 <20160426222627.GA19307@mail.hallyn.com>
 <CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
 <20160502035452.GA31837@mail.hallyn.com>
 <87h9egp2oq.fsf@x220.int.ebiederm.org>
 <CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
 <20160503051921.GA31551@mail.hallyn.com>
 <87bn4nhejj.fsf@x220.int.ebiederm.org>
 <20160507231012.GA11076@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160507231012.GA11076-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Jann Horn (jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org):
> On Tue, May 03, 2016 at 12:54:40AM -0500, Eric W. Biederman wrote:
> > "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> > 
> > > Quoting Andrew G. Morgan (morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> > >> 
> > >> I guess I'm confused how we have strayed so far that this isn't an obvious
> > >> requirement. Uid=0 as being the root of privilege was the basic problem
> > >> that capabilities were designed to change.
> > >
> > > The task executing the file can be any uid mapped into the namespace.  The
> > > file only has to be owned by the root of the user_ns.  Which I agree is
> > > unfortunate.  We can work around it by putting the root uid into the xattr
> > > itself (which still isn't orthogonal but allows the file to at least by
> > > owned by non-root), but the problem then is that a task needs to know its
> > > global root k_uid just to write the xattr.
> > 
> > The root kuid is just make_kuids(user_ns, 0) so it is easy to find.
> > 
> > It might be a hair better to use the userns->owner instead of the root
> > uid.  That would allow user namespaces without a mapped root to still
> > use file capabilities.
> 
> Please don't do that. A user might want to create multiple containers with
> isolated security properties, and in that case, it would be bad if binaries
> that are capable in one container are also automatically valid in the user's
> other containers.

But no, if the namespaces both created by uid 1000 have disjoint uid mappings,
say 100000-165535 and 200000-265536, then a file capability on a file owned
by 200000 would not be active when the exec()ing task has only 100000-165535
mapped.

If the uid mappings are not completely disjoint, then you cannot assume that
the user wanted the mappings to be disjoint.  In particular, while setting up
a rootfs for a container I'll frequently use small ad-hoc namespaces to chown
files.  For instance, my intended final container mapping may be 65536 uids
starting at 100000, but to chown a file to uid 5 in the container I may create
a ns with kuid 1000 as uid 0 and 100005 as uid 1.  Here the root uid doing the
writing is not even mapped into the final container namespace.

So a new approach might be to (a) note the kuid which created the
namespace in the xattr (magically written by the kernel at xattr write
time), then say that for the file capability to take effect, two things
must hold:

1. the kuid noted in the xattr must match the kuid which created the calling
task's user_ns (or any ancestor creator)

2. the file uid must map into the calling task's namespace

To write the filecap,

1. the task must be privileged over the uid which owns the file (in the
sense of capable_wrt_inode_uidgid)

2. the task must be privileged over his own user_ns

As Eric said, this should address Andrew Morgan's concern about requiring that
the file be owned by uid 0 in the namespace.

There's a problem though.  The above suffices to prevent an unprivileged user
in a user_ns from unsharing a user_ns to write a file capability and exploit
that capability in the ns where he is unprivileged.  With one exception, which
is the case where the unprivileged user is mapped to the same kuid which
created the namespace.  So if uid 1000 on the host creates a namespace
where uid 1000 maps to 1000 in the namespace, then 1000 in the namespace
can create a new user_ns, write the xattr, and exploit it from the
parent namespace.  This is not an uncommon case.  I'm not sure what to do about
it.

> Also, this would mean that in an owner!=root scenario, container root can't
> setcap executables and needs to ask the administrator of the surrounding system
> to do it.
> (Of course, this could be worked around using a dummy userns layer between the
> init ns and the container, but I don't like seeing new reasons for such a hack.)
