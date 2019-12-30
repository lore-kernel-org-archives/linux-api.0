From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC 1/1] mount: universally disallow mounting over symlinks
Date: Sun, 29 Dec 2019 23:34:48 -0800
Message-ID: <CAHk-=wjHPCQsMeK5bFOJQnrGPfVDXTAFQK4VsBZPj5u=ZgS-QA@mail.gmail.com>
References: <20191230052036.8765-1-cyphar@cyphar.com> <20191230052036.8765-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191230052036.8765-2-cyphar@cyphar.com>
Sender: stable-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 29, 2019 at 9:21 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> +       if (d_is_symlink(mp->m_dentry) ||
> +           d_is_symlink(mnt->mnt.mnt_root))
> +               return -EINVAL;

So I don't hate this kind of check in general - overmounting a symlink
sounds odd, but at the same time I get the feeling that the real issue
is that something went wrong earlier.

Yeah, the mount target kind of _is_ a path, but at the same time, we
most definitely want to have the permission to really open the
directory in question, don't we, and I don't see that we should accept
a O_PATH file descriptor.

I feel like the only valid use of "O_PATH" files is to then use them
as the base for an openat() and friends (ie fchmodat/execveat() etc).

But maybe I'm completely wrong, and people really do want O_PATH
handling exactly for mounting too. It does sound a bit odd. By
definition, mounting wants permissions to the mount-point, so what's
the point of using O_PATH?

So instead of saying "don't overmount symlinks", I would feel like
it's the mount system call that should use a proper file descriptor
that isn't FMODE_PATH.

Is it really the symlink that is the issue? Because if it's the
symlink that is the issue then I feel like O_NOFOLLOW should have
triggered it, but your other email seems to say that you really need
O_PATH | O_SYMLINK.

So I'm not sayng that this patch is wrong, but it really smells a bit
like it's papering over the more fundamental issue.

For example, is the problem that when you do a proper

  fd = open("somepath", O_PATH);

in one process, and then another thread does

   fd = open("/proc/<pid>/fd/<opathfd>", O_RDWR);

then we get confused and do bad things on that *second* open? Because
now the second open doesn't have O_PATH, and doesn't ghet marked
FMODE_PATH, but the underlying file descriptor is one of those limited
"is really only useful for openat() and friends".

I dunno. I haven't thought through the whole thing. But the oopses you
quote seem like we're really doing something wrong, and it really does
feel like your patch in no way _fixes_ the wrong thing we're doing,
it's just hiding the symptoms.

               Linus
