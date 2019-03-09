From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RESEND v5 2/5] namei: O_BENEATH-style path resolution flags
Date: Sat, 9 Mar 2019 09:00:58 -0800
Message-ID: <CAHk-=wgGKWRTgSYKkgMEf1QOg0PZSpmBha+2LCHCBOar0e8cug@mail.gmail.com>
References: <20190306191244.8691-1-cyphar@cyphar.com> <20190306191244.8691-3-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306191244.8691-3-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 6, 2019 at 11:14 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> This is a refresh of Al's AT_NO_JUMPS patchset[1] (which was a variation
> on David Drysdale's O_BENEATH patchset[2], which in turn was based on
> the Capsicum project[3]). Input from Linus and Andy in the AT_NO_JUMPS
> thread[4] determined most of the API changes made in this refresh.

So I still think this is likely a good idea...  BUT.

The absolutely huge BUT here is "are user space people actually
interested in using it, or do they already have other solutions to
this anyway?"

The intent is obviously to make it easy and cheap to to the simple
pathname lookup in a controlled manner, and then let user space fall
back to "let's check things much more carefully" for paths that look
iffy.

But maybe the people who care already have their own solutions, and/or
need something more anyway (ie samba looking up all names in user
space first _anyway_ due to ICASE issues or whatever)?

So this is easy and straightforward to do in the kernel, and it
_feels_ like something that can be useful, and I'm not all that
concerned about the maintenance overhead either because of the trivial
semantics.

But I'd still like to actually have some user space person say "yeah,
we'd actually use this" since quite often non-portable solutions don't
really end up being used simply because it's not worth the maintenance
headache in user space..

                     Linus
