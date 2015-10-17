From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Sat, 17 Oct 2015 16:55:01 -0500
Message-ID: <20151017215501.GA22900@mail.hallyn.com>
References: <5622700C.9090107@miglix.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5622700C.9090107-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 17, 2015 at 05:58:04PM +0200, Tobias Markus wrote:
> Add capability CAP_SYS_USER_NS.
> Tasks having CAP_SYS_USER_NS are allowed to create a new user namespace
> when calling clone or unshare with CLONE_NEWUSER.
> 
> Rationale:
> 
> Linux 3.8 saw the introduction of unpriviledged user namespaces,
> allowing unpriviledged users (without CAP_SYS_ADMIN) to be a "fake" root
> inside a separate user namespace. Before that, any namespace creation
> required CAP_SYS_ADMIN (or, in practice, the user had to be root).
> Unfortunately, there have been some security-relevant bugs in the
> meantime. Because of the fairly complex nature of user namespaces, it is
> reasonable to say that future vulnerabilties can not be excluded. Some
> distributions even wholly disable user namespaces because of this.

Fwiw I'm not in favor of this.  Debian has a patch (I believe the one
I originally wrote for Ubuntu but which Ubuntu dropped long ago) adding a
sysctl, off by default, for enabling user namespaces.

Posix capabilities are intended for privileged actions, not for
actions which explicitly should not require privilege, but which
we feel are in development.

In general, the feeling is that putting a feature like this behind a
wall will only slow down the finding of any bugs, so I think the goal
itself is questionable.  But the chosen means for achieving your goal
are definately wrong.

> Both options, user namespaces with and without CAP_SYS_ADMIN, can be
> said to represent the extreme end of the spectrum. In practice, there is
> no reason for every process to have the abilitiy to create user
> namespaces. Indeed, only very few and specialized programs require user

There is.  One of Eric's primary motivations for user namespaces was to
finally allow unprivileged users to safely do things like manipulate
their mounts tree without the risk of privileged (setuid) programs
being tricked.

-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
