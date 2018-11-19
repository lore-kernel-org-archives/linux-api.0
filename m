From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 20:31:31 +0100
Message-ID: <20181119193128.hv7z4j52ajrue2jr@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <CAKOZueshQ2DAwUYp+dLpmfYG6FtvCqeRQxH41SjNS+WqY3e0Fw@mail.gmail.com>
 <20181119182902.fadw6qiu3eepndm3@brauner.io>
 <87o9ak28nl.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87o9ak28nl.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 01:02:06PM -0600, Eric W. Biederman wrote:
> Christian Brauner <christian@brauner.io> writes:
> 
> > On Mon, Nov 19, 2018 at 07:59:24AM -0800, Daniel Colascione wrote:
> >> You never addressed my comment on the previous patch about your use of
> >
> > Sorry, that thread exploded so quickly that I might have missed it.
> >
> >> private_data here. Why can't you use the struct pid reference that's
> >> already in the inode?
> >
> > If that's what people prefer we can probably use that. There was
> > precedent for stashing away such data in fs/proc/base.c already for
> > various other things including user namespaces and struct mm so I
> > followed this model. A prior version of my patch (I didn't send out) did
> > retrive the inode via proc_pid() in .open() took an additional reference
> > via get_pid() and dropped it in .release(). Do we prefer that?
> 
> If you are using proc/<pid>/ directories as your file descriptors, you
> don't need to add an open or a release method at all.  The existing file
> descriptors hold a reference to the inode which holds a reference the
> the struct pid.
> 
> The only time you need to get a reference is when you need a task
> and kill_pid_info already performs that work for you.

Oh, I see what you and Andy are saying now. Sweet, that means we can
trim down the patch even more. Less code, less headache.

Thanks!

> 
> So using proc_pid is all you need to do to get the pid from the existing
> file descriptors.
> 
> Eric
> 
