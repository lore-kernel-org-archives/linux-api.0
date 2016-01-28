From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Wed, 27 Jan 2016 16:36:02 -0800
Message-ID: <CALCETrV_McoPAFvXbZAOfWPpj6rMbYFZvrusVi9_yXsBXHkN0A@mail.gmail.com>
References: <20151130224356.GA27972@mail.hallyn.com> <87two3w0el.fsf@x220.int.ebiederm.org>
 <20151204202116.GA4809@mail.hallyn.com> <20160120124816.GB32379@pc.thejh.net>
 <20160127160815.GA28787@mail.hallyn.com> <20160127172225.GA7967@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160127172225.GA7967-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 27, 2016 at 9:22 AM, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org> wrote:
> I think it sounds good from a security perspective.

I'm a bit late to the game, but I have a question: why should this be
keyed to the *root* uid of the namespace in particular?  Certainly if
user foo trusts the cap bits on some file, then user foo might trust
those caps to be exerted over any namespace that user foo owns, since
user foo owns the namespace.

But another option would be to include a list of uids and gids such
that the cap bits on the file are trusted by any namespace that maps
only uids and gids in the list.  After all, the existence of a
namespace with root user foo that also maps bar and baz along with a
file with caps set means that, if baz can get to the file and
permissions are set appropriately, then baz now owns bar (via any
number of fs-related capabilities).  So maybe bar and baz should have
to be listed as well.

But maybe this doesn't matter.

In any event, at the end of the day, the right answer to all of this
is to stop using setuid and stop using cap bits too and start using
privileged daemons or other things that don't use the eternally
fragile grant-privilege-on-execve mechanisms.

--Andy
