From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Date: Sat, 15 Nov 2014 21:07:15 -0800
Message-ID: <20141116050715.GC18880@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org>
 <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin>
 <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
 <87vbmfq1uw.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87vbmfq1uw.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 15, 2014 at 09:08:07PM -0600, Eric W. Biederman wrote:
> Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> writes:
> > On November 15, 2014 6:05:11 PM PST, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> >>On Sat, Nov 15, 2014 at 12:20:42PM -0800, Josh Triplett wrote:
> >>> > However, sudoers seems to allow negative group matches.  So maybe
> >>> > allowing this only with no_new_privs already set would make sense.
> >>> 
> >>> Sigh, bad sudo.  Sure, restricting this to no_new_privs only seems
> >>fine.
> >>> I'll do that in v2, and document that in the manpage.
> >>
> >>I've also seen use cases (generally back in the bad old days of big
> >>timesharing VAX 750's :-) where the system admin might assign someone
> >>to the "games-abusers" group, and then set /usr/games to mode 705
> >>root:games-abusers --- presumably because it's easier to add a few
> >>people to the deny list rather than having to add all of the EECS
> >>department to the games group minus the abusers.
> >>
> >>So arbitrarily anyone to drop groups from their supplemental group
> >>list will result in a change from both existing practice and legacy
> >>Unix systems, and it could potentially lead to a security exposure.
> >
> > As Andy pointed out, you can already do that with a user namespace,
> 
> That may be a bug with the user namespace permission check.  Perhaps we
> shouldn't allow dropping groups that aren't mapped in the user
> namespace.

Changing that would break containers for users on many common Linux
distributions, which put users in various supplementary groups by
default.

I do actually have another patch planned, to allow users to set up gid
maps for groups they currently have permission for, not just for their
primary group.  But even with that change, breaking the ability for
container-root to use setgroups to drop all its supplementary groups
seems very wrong, and seems highly likely to break real-world software
running in containers.

> To add to the discussion there are also sg and newgroup, though I don't
> think they touch supplementary groups.

Both sg and newgrp do prove a different point, though: an unprivileged
user should be able to change their gid to one of their supplementary
groups.  That's another patch I planned to submit after this one:
allow setgid/setresgid/etc to a supplementary group ID.

> > for any case not involving a setuid or setgid (or otherwise
> > privilege-gaining) program.  And requiring no_new_privs handles that.
> 
> Frankly adding a no_new_privs check to allow something/anything scares
> me.  That converts no_new_privs from something simple and easy to
> understand to something much more complicated.

no_new_privs already exists in large part to support such use cases,
such as setting seccomp filters, which would be dangerous for
privilege-escalating programs to inherit.

> > Given the combination of those two things, do you still see any
> > problematic cases?
> 
> Josh I think it is time to stop and make certain you understand how
> unix groups work in the large.
>
> It seems to me that either supplementary groups can be dropped or
> supplementary groups can not be dropped.  If they can be dropped we
> shouldn't need complicated checks to allow them to be dropped in some
> circumstances but not others.
> 
> Unix groups are an old interface and they have been used in a lot of
> ways over the years.  We need to be careful any change we make is good
> and truly backwards compatible and that we do our darndest not to
> introduce security holes.

Seeking the decades-old precedents and corner cases that might
contradict the most obvious semantics is a large part of what I'm
looking for out of this thread.

However, I don't necessarily think that we must permit unprivileged
setgroups in *all* cases if we permit it in *any*; it may well make
sense to reduce the surface area of the change by limiting the
circumstances in which you can do this.  Whether it does end up making
sense to do so depends on the outcome of this discussion.

I added the no_new_privs check at Andy's suggestion, since the use case
I had in mind will work just fine with that restriction.  I'm also open
to just allowing setgroups in all cases, if that semantic seems
preferable, or to adding some separate check specific to this case if
that really seems necessary.

- Josh Triplett
