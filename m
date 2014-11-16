From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Date: Sat, 15 Nov 2014 21:05:11 -0500
Message-ID: <20141116020511.GB5507@thunk.org>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org>
 <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141115202042.GA20900@thin>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 15, 2014 at 12:20:42PM -0800, Josh Triplett wrote:
> > However, sudoers seems to allow negative group matches.  So maybe
> > allowing this only with no_new_privs already set would make sense.
> 
> Sigh, bad sudo.  Sure, restricting this to no_new_privs only seems fine.
> I'll do that in v2, and document that in the manpage.

I've also seen use cases (generally back in the bad old days of big
timesharing VAX 750's :-) where the system admin might assign someone
to the "games-abusers" group, and then set /usr/games to mode 705
root:games-abusers --- presumably because it's easier to add a few
people to the deny list rather than having to add all of the EECS
department to the games group minus the abusers.

So arbitrarily anyone to drop groups from their supplemental group
list will result in a change from both existing practice and legacy
Unix systems, and it could potentially lead to a security exposure.

Cheers,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
