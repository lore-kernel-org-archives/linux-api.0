From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH] Add supplementary UIDs, and getusers/setusers system
 calls
Date: Thu, 20 Nov 2014 09:59:03 -0800
Message-ID: <20141120175903.GA23186@cloud>
References: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
 <87egsxnbth.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87egsxnbth.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2014 at 09:14:50AM -0600, Eric W. Biederman wrote:
> Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> writes:
> > Analogous to the supplementary GID list, the supplementary UID list
> > provides a set of additional user credentials that a process can act as.
> > A process with CAP_SETUID can set its UID list arbitrarily; a process
> > without CAP_SETUID can only reduce its UID list.
> >
> > This allows each user to have a set of UIDs that they can then use to
> > further sandbox individual child processes without first escalating to
> > root to change UIDs.  For instance, a PAM module could give each user a
> > block of UIDs to work with.
> 
> A couple of quick comments on this patch.

Thanks for your feedback; I'll make sure that the patch description in
v2 provides more detail on use cases and security implications.

> 1) user namespaces already allow you to do this.

No, user namespaces don't handle this case.  User namespaces let you
invent an entirely *new* set of UIDs, all of which map to your one and
only UID on the host.  Only root can map other UIDs on the host to UIDs
in the user namespace.

I wrote this patch in large part *because* of user namespaces; this will
serve as infrastructure that will allow unprivileged users to set up UID
maps, and set up containers whose filesystem doesn't live on a separate
device.  (In the future, this infrastructure will also support
dynamically allocated users and user-mounted filesystems that
distinguish between multiple UIDs, using a filesystem UID map.)

Today, if I have a chroot filesystem containing multiple distinct UIDs
that need to remain distinct (for instance, my Chrome OS build chroot),
I have a few choices, none of them optimal.  Either I hide the
filesystem inside a container and *never* access it from the host, or I
use root to set it up and enter it.  And many approaches interact poorly
with some home directory policies, such as forcing home directory mounts
to only contain files owned by the user.

With this change, together with a change to user namespaces to allow
using supplementary UIDs in a UID map, I could set up and run a build
chroot *entirely* as an unprivileged user.

> 2) After having looked at the group case I am afraid this intersects in
>    an unfortunate way with user namespaces.

In some specific way, or as a general concern that this will need
careful review?

> 3) This intersects in a very unfortunate way with setresuid.
>    Applications that today know they are dropping all privileges
>    won't be dropping all privielges with this change.  Which sounds like
>    a recipe for a security exploit to me.

Root has to hand a user a set of UIDs in the first place, by calling
setusers().  Once it does so, the user can act as any of those UIDs.  If
the user wants to limit permissions to a single UID, they need to switch
to that UID and drop the rest; otherwise, they're handing on all their
UIDs to a child process.  That doesn't seem like an exploit; that seems
like "I've given you some UIDs so you have those UIDs".

That said, given that the use cases this infrastructure supports would
involve new tools that understand supplementary users, I could live with
adding a new setresuid2() system call with a "keep supplementary UIDs"
flag, and if you don't pass that flag (or you use the existing
setuid/setresuid/etc calls) the call will automatically drop all
supplementary UIDs.  Then, if a process that doesn't know about
supplementary UIDs changes its UID, it'll lose all supplementary UIDs.
Would that address your concern?

- Josh Triplett
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
