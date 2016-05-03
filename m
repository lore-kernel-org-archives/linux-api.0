From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Tue, 3 May 2016 00:19:21 -0500
Message-ID: <20160503051921.GA31551@mail.hallyn.com>
References: <1461345993-17526-1-git-send-email-serge.hallyn@ubuntu.com>
 <1461345993-17526-2-git-send-email-serge.hallyn@ubuntu.com>
 <CAGXu5jKFNQs8oxq+yD6_Q8HcNyf+GouSHFzkxT9u9BkK=ZLQ7Q@mail.gmail.com>
 <20160426222627.GA19307@mail.hallyn.com>
 <CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
 <20160502035452.GA31837@mail.hallyn.com>
 <87h9egp2oq.fsf@x220.int.ebiederm.org>
 <CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Andrew G. Morgan (morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> On 2 May 2016 6:04 p.m., "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> >
> > "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> >
> > > On Tue, Apr 26, 2016 at 03:39:54PM -0700, Kees Cook wrote:
> > >> On Tue, Apr 26, 2016 at 3:26 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> wrote:
> > >> > Quoting Kees Cook (keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org):
> > >> >> On Fri, Apr 22, 2016 at 10:26 AM,  <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > >> >> > From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> > > ...
> > >> >> This looks like userspace must knowingly be aware that it is in a
> > >> >> namespace and to DTRT instead of it being translated by the kernel
> > >> >> when setxattr is called under !init_user_ns?
> > >> >
> > >> > Yes - my libcap2 patch checks /proc/self/uid_map to decide that.  If
> that
> > >> > shows you are in init_user_ns then it uses security.capability,
> otherwise
> > >> > it uses security.nscapability.
> > >> >
> > >> > I've occasionally considered having the xattr code do the quiet
> > >> > substitution if need be.
> > >> >
> > >> > In fact, much of this structure comes from when I was still trying to
> > >> > do multiple values per xattr.  Given what we're doing here, we could
> > >> > keep the xattr contents exactly the same, just changing the name.
> > >> > So userspace could just get and set security.capability;  if you are
> > >> > in a non-init user_ns, if security.capability is set then you cannot
> > >> > set it;  if security.capability is not set, then the kernel writes
> > >> > security.nscapability instead and returns success.
> > >> >
> > >> > I don't like magic, but this might be just straightforward enough
> > >> > to not be offensive.  Thoughts?
> > >>
> > >> Yeah, I think it might be better to have the magic in this case, since
> > >> it seems weird to just reject setxattr if a tool didn't realize it was
> > >> in a namespace. I'm not sure -- it is also nice to have an explicit
> > >> API here.
> > >>
> > >> I would defer to Eric or Michael on that. I keep going back and forth,
> > >> though I suspect it's probably best to do what you already have
> > >> (explicit API).
> > >
> > > Michael, Eric, what do you think?  The choice we're making here is
> > > whether we should
> > >
> > > 1. Keep a nice simple separate pair of xattrs, the pre-existing
> > > security.capability which can only be written from init_user_ns,
> > > and the new (in this patch) security.nscapability which you can
> > > write to any file where you are privileged wrt the file.
> > >
> > > 2. Make security.capability somewhat 'magic' - if someone in a
> > > non-initial user ns tries to write it and has privilege wrt the
> > > file, then the kernel silently writes security.nscapability instead.
> > >
> > > The biggest drawback of (1) would be any tar-like program trying
> > > to restore a file which had security.capability, needing to know
> > > to detect its userns and write the security.nscapability instead.
> > > The drawback of (2) is ~\o/~ magic.
> >
> > Apologies for not having followed this more closely before.
> >
> > I don't like either option.  I think we will be in much better shape if
> > we upgrade the capability xattr.  It seems totally wrong or at least
> > confusing for a file to have both capability xattrs.
> >
> > Just using security.capability allows us to confront any weird issues
> > with mixing both the old semantics and the new semantics.
> >
> > We had previously discussioned extending the capbility a little and
> > adding a uid who needed to be the root uid in a user namespace, to be
> > valid.  Using the owner of the file seems simpler, and even a little
> > more transparent as this makes the security.capability xattr a limited
> > form of setuid (which it semantically is).
> >
> > So I believe the new semantics in general are an improvement.
> >
> >
> > Given the expected use case let me ask as simple question: Are there any
> > known cases where the owner of a setcap exectuable is not root?
> >
> > I expect the pile of setcap exectuables is small enough we can go
> > through the top distros and look at all of the setcap executlables.
> >
> >
> > If there is not a need to support setcap executables owned by non-root,
> > I suspect the right play is to just change the semantics to always treat
> > the security.capability attribute this way.
> >
> 
> I guess I'm confused how we have strayed so far that this isn't an obvious
> requirement. Uid=0 as being the root of privilege was the basic problem
> that capabilities were designed to change.

The task executing the file can be any uid mapped into the namespace.  The
file only has to be owned by the root of the user_ns.  Which I agree is
unfortunate.  We can work around it by putting the root uid into the xattr
itself (which still isn't orthogonal but allows the file to at least by
owned by non-root), but the problem then is that a task needs to know its
global root k_uid just to write the xattr.

> Uid is an acl concept. Capabilities are supposed to be independent of that.
> 
> If we want to support NS file capabilities I would look at replacing the
> xattr syscall with a dedicated file capabilities modification syscall. Then

That was one ofthe possibilities I'd mentioned in my earlier proposal,
fwiw.  The problem is if we want tar to still work unmodified then
simple xattr operations still have to work.

Maybe there's workable semantics there though.  Worth thinking about.

> namespace partitioning and file capabilities can be managed in the kernel
> with respect to the prevailing namespace, and not by some hybrid userspace
> kernel convention.
> 
> Cheers
> 
> Andrew
> 
> > If there is a need to support setcap exectualbes owned by non-root,
> > then the current implementation is most likely unacceptable.  As that
> > problem case can not work in a container.
> >
> >
> >
> > My guess is that we can just reinterpret the current security.capable to
> > only be valid when root owns the file in the initial user namespace.  At
> > which point backwards compatibility becomes trivial as the
> > security.capable does not change, just the rules for setting it, and
> > interpreting it.
> >
> >
> > We should also ensure that the gid of the file is mapped into the user
> > namespace where the uid is the root of the user namespace.  So that we
> > are effectively testing capable_wrtuid_and_gid on execute as well a
> > read/write of the the xattr.
> >
> > Eric
