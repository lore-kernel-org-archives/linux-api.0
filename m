From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH RESEND v5 0/5] namei: vfs flags to restrict path
 resolution
Date: Tue, 23 Apr 2019 22:24:06 +0200
Message-ID: <20190423202405.wzs7lkjqgrlzwyu5@brauner.io>
References: <20190320143717.2523-1-cyphar@cyphar.com>
 <CALCETrV-Q4qZXGeavBPQbF6-VVz7hqvjRkbhFeYmbGiQgu5Omg@mail.gmail.com>
 <20190325130429.dbrgjxnvq3w5cpb3@yavin>
 <CAGXu5jKPrarixQkWWXOBCu6kRRpQd0aaJsPJbvsAyh0Wvc620A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKPrarixQkWWXOBCu6kRRpQd0aaJsPJbvsAyh0Wvc620A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, David Drysdale <drysdale@google.com>, Tycho Andersen <tycho@tycho.ws>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 23, 2019 at 01:13:52PM -0700, Kees Cook wrote:
> On Mon, Mar 25, 2019 at 6:05 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >
> > On 2019-03-21, Andy Lutomirski <luto@kernel.org> wrote:
> > > On Wed, Mar 20, 2019 at 7:38 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > > > Now that the holiday break is over, it's time to re-send this patch
> > > > series (with a few additions, due to new information we got from
> > > > CVE-2019-5736 -- which this patchset mostly protected against but had
> > > > some holes with regards to #!-style scripts).
> > >
> > > I generally like this, but, as Linus pointed out, it will be
> > > unfortunate if application authors see this as just another
> > > non-portable weird Linux API and don't use it.  Would it be worthwhile
> > > to put some thought into making it an API that other OSes might be
> > > willing to implement?  As it stands, the openat(2) flags are getting
> > > rather crazy in this patch set.
> 
> I think many of the issues are specific to Linux (and Linux containers
> especially), so I'm not sure this should get blocked because we want
> something more portable.
> 
> This series provides solutions to so many different race and confusion
> issues, I'd really like to see it land. What's the next step here? Is
> this planned to go directly to Linus for v5.2, or is it going to live
> in -mm for a while? I'd really like to see this moving forward.

Yeah, it would be good to move this forward. But since this is pretty
much core-vfs we really need Al to take a look at this.

Christian
