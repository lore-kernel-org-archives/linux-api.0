From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Tue, 9 Oct 2018 12:25:52 -0700
Message-ID: <CALCETrUZAYw-g+75WAijS+fmRA_DrTahpv156WrxgYuX3KX2xw@mail.gmail.com>
References: <20181009065300.11053-1-cyphar@cyphar.com> <20181009065300.11053-3-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009065300.11053-3-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 8, 2018 at 11:53 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> * AT_NO_PROCLINK: Disallows ->get_link "symlink" jumping. This is a very
>   specific restriction, and it exists because /proc/$pid/fd/...
>   "symlinks" allow for access outside nd->root and pose risk to
>   container runtimes that don't want to be tricked into accessing a host
>   path (but do want to allow no-funny-business symlink resolution).

Can you elaborate on the use case?

If I'm set up a container namespace and walk it for real (through the
outside /proc/PID/root or otherwise starting from an fd that points
into that namespace), and I walk through that namespace's /proc, I'm
going to see the same thing that the processes in the namespace would
see.  So what's the issue?

Similarly, if I somehow manage to walk into the outside /proc, then
I've pretty much lost regardless of the links.

--Andy
