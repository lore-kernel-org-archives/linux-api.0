From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Fri, 29 Jan 2016 01:31:51 -0600
Message-ID: <20160129073151.GA23156@mail.hallyn.com>
References: <20151130224356.GA27972@mail.hallyn.com>
 <87two3w0el.fsf@x220.int.ebiederm.org>
 <20151204202116.GA4809@mail.hallyn.com>
 <20160120124816.GB32379@pc.thejh.net>
 <20160127160815.GA28787@mail.hallyn.com>
 <20160127172225.GA7967@pc.thejh.net>
 <CALCETrV_McoPAFvXbZAOfWPpj6rMbYFZvrusVi9_yXsBXHkN0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV_McoPAFvXbZAOfWPpj6rMbYFZvrusVi9_yXsBXHkN0A@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jann@thejh.net>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>, LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>, Richard Weinberger <richard@nod.at>, LSM <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 27, 2016 at 04:36:02PM -0800, Andy Lutomirski wrote:
> On Wed, Jan 27, 2016 at 9:22 AM, Jann Horn <jann@thejh.net> wrote:
> > I think it sounds good from a security perspective.
> 
> I'm a bit late to the game, but I have a question: why should this be
> keyed to the *root* uid of the namespace in particular?  Certainly if
> user foo trusts the cap bits on some file, then user foo might trust
> those caps to be exerted over any namespace that user foo owns, since
> user foo owns the namespace.

...  Tying it to a kuid which represents the userns->owner of any
namespace in which the capability will be honored might be fine
with me.  Is that what you mean?  So if uid 1000 creates a userns
mapping uids 100000-200000, and 100000 in that container puts X=pe
on /bin/foo, uid 101000 in that container runs /bin/foo with privilege
X.  Uid 101000 in someone else's container does not.

Although, if I create two containers and provide them different
uidmaps, it may well be because I want them segragated and want
to minimize the changes of one container breaking out into the
other.  This risks breaking that.

> But another option would be to include a list of uids and gids such
> that the cap bits on the file are trusted by any namespace that maps
> only uids and gids in the list.  After all, the existence of a
> namespace with root user foo that also maps bar and baz along with a
> file with caps set means that, if baz can get to the file and
> permissions are set appropriately, then baz now owns bar (via any
> number of fs-related capabilities).  So maybe bar and baz should have
> to be listed as well.
> 
> But maybe this doesn't matter.
> 
> In any event, at the end of the day, the right answer to all of this
> is to stop using setuid and stop using cap bits too and start using
> privileged daemons or other things that don't use the eternally
> fragile grant-privilege-on-execve mechanisms.

Heh, that's why I wrote a p9auth driver a few years ago, but it
was too early for such a thing.
