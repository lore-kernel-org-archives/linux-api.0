From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Thu, 11 Oct 2018 18:12:01 -0700
Message-ID: <CALCETrX_T9CF=UHHiTnb9b06R_uDt4XnZ2sSej-c82ptZ3Lbjw@mail.gmail.com>
References: <20181009065300.11053-1-cyphar@cyphar.com> <20181009065300.11053-3-cyphar@cyphar.com>
 <CALCETrUZAYw-g+75WAijS+fmRA_DrTahpv156WrxgYuX3KX2xw@mail.gmail.com> <20181010070747.byi2itbi4j42gynq@ryuk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010070747.byi2itbi4j42gynq@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 10, 2018 at 12:08 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> On 2018-10-09, Andy Lutomirski <luto@kernel.org> wrote:
> > On Mon, Oct 8, 2018 at 11:53 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > > * AT_NO_PROCLINK: Disallows ->get_link "symlink" jumping. This is a very
> > >   specific restriction, and it exists because /proc/$pid/fd/...
> > >   "symlinks" allow for access outside nd->root and pose risk to
> > >   container runtimes that don't want to be tricked into accessing a host
> > >   path (but do want to allow no-funny-business symlink resolution).
> >
> > Can you elaborate on the use case?
> >
> > If I'm set up a container namespace and walk it for real (through the
> > outside /proc/PID/root or otherwise starting from an fd that points
> > into that namespace), and I walk through that namespace's /proc, I'm
> > going to see the same thing that the processes in the namespace would
> > see.  So what's the issue?
> >
> > Similarly, if I somehow manage to walk into the outside /proc, then
> > I've pretty much lost regardless of the links.
>
> Well, there's a couple of reasons:
>
> * The original AT_NO_JUMPS patchset similarly disabled "proclinks" but
>   it was sort of all contained within AT_NO_JUMPS. In order to have a
>   precise 1:1 feature mapping we need this in *some* form (and in v1 the
>   only way to get it was to add a separate flag). According to the
>   original O_BENEATH changelog, both you and Al pushed for this to be
>   part of O_BENEATH. :P

:)

Now that you mention it, I *think* my reasoning involved a rather
different use case: sandboxing.  If a task is Capsicum-ified or
seccomp()ed such that it can *only* use O_BENEATH or AT_BENEATH, this
restriction considerably strengthens the resulting security.
