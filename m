From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH RESEND v5 2/5] namei: O_BENEATH-style path resolution
 flags
Date: Sat, 9 Mar 2019 18:26:32 +0100
Message-ID: <20190309172631.ygfdhrn4rcwkgfmk@brauner.io>
References: <20190306191244.8691-1-cyphar@cyphar.com>
 <20190306191244.8691-3-cyphar@cyphar.com>
 <CAHk-=wgGKWRTgSYKkgMEf1QOg0PZSpmBha+2LCHCBOar0e8cug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgGKWRTgSYKkgMEf1QOg0PZSpmBha+2LCHCBOar0e8cug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>l
List-Id: linux-api@vger.kernel.org

On Sat, Mar 09, 2019 at 09:00:58AM -0800, Linus Torvalds wrote:
> On Wed, Mar 6, 2019 at 11:14 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >
> > This is a refresh of Al's AT_NO_JUMPS patchset[1] (which was a variation
> > on David Drysdale's O_BENEATH patchset[2], which in turn was based on
> > the Capsicum project[3]). Input from Linus and Andy in the AT_NO_JUMPS
> > thread[4] determined most of the API changes made in this refresh.
> 
> So I still think this is likely a good idea...  BUT.
> 
> The absolutely huge BUT here is "are user space people actually
> interested in using it, or do they already have other solutions to
> this anyway?"
> 
> The intent is obviously to make it easy and cheap to to the simple
> pathname lookup in a controlled manner, and then let user space fall
> back to "let's check things much more carefully" for paths that look
> iffy.
> 
> But maybe the people who care already have their own solutions, and/or
> need something more anyway (ie samba looking up all names in user
> space first _anyway_ due to ICASE issues or whatever)?
> 
> So this is easy and straightforward to do in the kernel, and it
> _feels_ like something that can be useful, and I'm not all that
> concerned about the maintenance overhead either because of the trivial
> semantics.
> 
> But I'd still like to actually have some user space person say "yeah,
> we'd actually use this" since quite often non-portable solutions don't

So if I may put my user space hat on. I maintain a container runtime LXC
and Aleksa maintains runC another container runtime. We both have
(horrible) code in our respective projects that tries to ensure that a
given path doesn't escape a given dirfd. Symlink resolution, and then
using crazy things such as mounting through /proc/<pid>/fd/<nr> etc. pp.
It works and we have been living with this state for a long time. But we
would both definitely use this feature. We've been discussing this and
had this on our wishlist for quite a long time and it would be good to
have this patchset.
Aside from that I want to point out that it is non-trivial to do this in
user space. The original code for restricted path resolution in our
codebase was done and is maintained by people like Serge and myself who
are involved in kernel development and it honestly required some pretty
intricate knowledge. I think having this feature work out of the box in
the kernel is a great win for quite a lot projects. Definitely for LXC
and runC.

Christian
