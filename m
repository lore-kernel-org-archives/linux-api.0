From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Mon, 29 Feb 2016 15:38:20 -0600
Message-ID: <20160229213820.GA1215@mail.hallyn.com>
References: <20151130224356.GA27972@mail.hallyn.com>
 <87two3w0el.fsf@x220.int.ebiederm.org>
 <20151204202116.GA4809@mail.hallyn.com>
 <20160120124816.GB32379@pc.thejh.net>
 <20160127160815.GA28787@mail.hallyn.com>
 <20160127172225.GA7967@pc.thejh.net>
 <CALCETrV_McoPAFvXbZAOfWPpj6rMbYFZvrusVi9_yXsBXHkN0A@mail.gmail.com>
 <20160129073151.GA23156@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160129073151.GA23156-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christian Brauner <christian.brauner-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 29, 2016 at 01:31:51AM -0600, Serge E. Hallyn wrote:
> On Wed, Jan 27, 2016 at 04:36:02PM -0800, Andy Lutomirski wrote:
> > On Wed, Jan 27, 2016 at 9:22 AM, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org> wrote:
> > > I think it sounds good from a security perspective.
> > 
> > I'm a bit late to the game, but I have a question: why should this be
> > keyed to the *root* uid of the namespace in particular?  Certainly if
> > user foo trusts the cap bits on some file, then user foo might trust
> > those caps to be exerted over any namespace that user foo owns, since
> > user foo owns the namespace.
> 
> ...  Tying it to a kuid which represents the userns->owner of any
> namespace in which the capability will be honored might be fine
> with me.  Is that what you mean?  So if uid 1000 creates a userns
> mapping uids 100000-200000, and 100000 in that container puts X=pe
> on /bin/foo, uid 101000 in that container runs /bin/foo with privilege
> X.  Uid 101000 in someone else's container does not.
> 
> Although, if I create two containers and provide them different
> uidmaps, it may well be because I want them segragated and want
> to minimize the changes of one container breaking out into the
> other.  This risks breaking that.

Thinking differently now...  I really want it to "just work" to tar
and untar these.  So I'm thinking of simply using the file owner
as the uid.  So to write a security.ns_capability xattr, you must
be uid 0 in the inode's namespace, the file must be owned by uid 0,
and the capabilities in the xattr will be honored for any namespace
where in that uid_t 0 is root.

Does that sound overly restrictive?  I expect file capabilities to
be used on files owned by root but not setuid-root, so I think it
is ok.

-serge
