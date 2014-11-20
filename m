From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] Add supplementary UIDs, and getusers/setusers system calls
Date: Thu, 20 Nov 2014 10:18:08 -0800
Message-ID: <CALCETrXxqcJd9=9c+HNMYmO5V+pV+EpjTA0NVvC6peGv_CyWuQ@mail.gmail.com>
References: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
 <87egsxnbth.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87egsxnbth.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Nov 20, 2014 7:16 AM, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> writes:
>
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
>
> 1) user namespaces already allow you to do this.

I thought you could only map your fsuid. Can you set fsuid to a
supplementary group?

>
> 2) After having looked at the group case I am afraid this intersects in
>    an unfortunate way with user namespaces.
>
> 3) This intersects in a very unfortunate way with setresuid.
>    Applications that today know they are dropping all privileges
>    won't be dropping all privielges with this change.  Which sounds like
>    a recipe for a security exploit to me.
>
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
