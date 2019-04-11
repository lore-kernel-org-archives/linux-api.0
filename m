From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC PATCH] fork: add CLONE_PIDFD
Date: Wed, 10 Apr 2019 17:12:00 -0700
Message-ID: <CAKOZuevU8Ke1jmnmdzzSEjb0GXfaCd_YVAm7ezGc5hy6xM8bxg@mail.gmail.com>
References: <20190410234045.29846-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410234045.29846-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Joel
List-Id: linux-api@vger.kernel.org

Thanks for trying it both ways.

On Wed, Apr 10, 2019 at 4:43 PM Christian Brauner <christian@brauner.io> wrote:
>
> Hey Linus,
>
> This is an RFC for adding a new CLONE_PIDFD flag to clone() as
> previously discussed.
> While implementing this Jann and I ran into additional complexity that
> prompted us to send out an initial RFC patchset to make sure we still
> think going forward with the current implementation is a good idea and
> also provide an alternative approach:
>
> RFC-1:
> This is an RFC for the implementation of pidfds as /proc/<pid> file
> descriptors.
> The tricky part here is that we need to retrieve a file descriptor for
> /proc/<pid> before clone's point of no return. Otherwise, we need to fail
> the creation of a process that has already passed all barriers and is
> visible in userspace. Getting that file descriptor then becomes a rather
> intricate dance including allocating a detached dentry that we need to
> commit once attach_pid() has been called.
> Note that this RFC only includes the logic we think is needed to return
> /proc/<pid> file descriptors from clone. It does *not* yet include the even
> more complex logic needed to restrict procfs itself. And the additional
> logic needed to prevent attacks such as openat(pidfd, "..", ...) and access
> to /proc/<pid>/net/ on top of the procfs restriction.

Why would filtering proc be all that complicated? Wouldn't it just be
adding a "sensitive" flag to struct pid_entry and skipping entries
with that flag when constructing proc entries?

> There are a couple of reasons why we stopped short of this and decided to
> sent out an RFC first:
> - Even the initial part of getting file descriptors from /proc/<pid> out
>   of clone() required rather complex code that struck us as very
>   inelegant and heavy (which granted, might partially caused by not seeing
>   a cleaner way to implement this). Thus, it felt like we needed to see
>   whether this is even remotely considered acceptable.
> - While discussing further aspects of this approach with Al we received
>   rather substantiated opposition to exposing even more codepaths to
>   procfs.
> - Restricting access to procfs properly requires a lot of invasive work
>   even touching core vfs functions such as
>   follow_dotdot()/follow_dotdot_rcu() which also caused 2.

Wasn't an internal bind mount supposed to take care of the parent
traversal problem?
