From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RESEND v5 2/5] namei: O_BENEATH-style path resolution flags
Date: Sat, 9 Mar 2019 10:08:08 -0800
Message-ID: <CAHk-=whMuk-b6rzhbF2=vVNOuEZk8-opRJ1fD07a9ztQ+V97Aw@mail.gmail.com>
References: <20190306191244.8691-1-cyphar@cyphar.com> <20190306191244.8691-3-cyphar@cyphar.com>
 <CAHk-=wgGKWRTgSYKkgMEf1QOg0PZSpmBha+2LCHCBOar0e8cug@mail.gmail.com> <20190309172631.ygfdhrn4rcwkgfmk@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190309172631.ygfdhrn4rcwkgfmk@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>l
List-Id: linux-api@vger.kernel.org

On Sat, Mar 9, 2019 at 9:26 AM Christian Brauner <christian@brauner.io> wrote:
>
> Aside from that I want to point out that it is non-trivial to do this in
> user space.

Oh, absolutely agreed. It's easy to do it in the kernel, and doing it
anywhere else ends up having horrible races that the kernel has to
deal with and has long solved anyway.

I've only seen this (2/5) patch, so I won't comment on the other ones,
but this still makes sense to me.

Al, comments?

                  Linus
