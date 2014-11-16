From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Date: Sat, 15 Nov 2014 20:52:32 -0800
Message-ID: <20141116045232.GB18880@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org>
 <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin>
 <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
 <20141116034005.GC5507@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141116034005.GC5507-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 15, 2014 at 10:40:06PM -0500, Theodore Ts'o wrote:
> On Sat, Nov 15, 2014 at 06:35:05PM -0800, Josh Triplett wrote:
> > >So arbitrarily anyone to drop groups from their supplemental group
> > >list will result in a change from both existing practice and legacy
> > >Unix systems, and it could potentially lead to a security exposure.
> > 
> > As Andy pointed out, you can already do that with a user namespace,
> > for any case not involving a setuid or setgid (or otherwise
> > privilege-gaining) program.  And requiring no_new_privs handles
> > that.
> 
> Well, it's no worse than what we can do already with the user
> namespace, yes.  I'm still worried it's going to come as a surprise
> for some configurations because it's a change from what was allowed
> historically.  Then again, pretty much all of the tripwire and rootkit
> scanners won't notice a "setuid" program that uses capabilities
> instead of the traditional setuid bit, and most sysadmins won't think
> to check for an executable with a forced capability mask, so this
> isn't exactly a new problem....

We certainly have introduced orthogonal APIs in various areas before,
such that applications written prior to those APIs may interact
interestingly with them; we don't allow *breaking* those applications,
or introducing security holes, but the existence of applications
designed to block one particular way to do something doesn't
*automatically* rule out the possibility of adding another way to do it.
It does require some careful thought, though.

When we introduced seccomp filters for syscalls, we tied them to
no_new_privs to prevent any possible security holes caused by selective
syscall denial/filtration.

In this case, I'm indifferent about whether unprivileged setgroups works
without no_new_privs; if people are comfortable with that, fine, and if
people would prefer no_new_privs (or for that matter a sysctl, a
compile-time option, or any other means of making the behavior
optional), I can do that too.  The security model of "having a group
gives you less privilege than not having it" seems crazy, but
nonetheless I can see a couple of easy ways that we can avoid breaking
that pattern, no_new_privs being one of them.  I'd like to make sure
that nobody sees any other real-world corner case that unprivileged
setgroups would break.

- Josh Triplett
