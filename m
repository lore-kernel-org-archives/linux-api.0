From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 29/38] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #10]
Date: Fri, 27 Jul 2018 23:27:34 +0100
Message-ID: <11038.1532730454@warthog.procyon.org.uk>
References: <CALCETrWDGa+ut=xsoki+XFKzdD7KruJJicfH1tKdBtywLuk7iQ@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk> <CALCETrUXsOexKcj+K_v_bsW6DkGFgyNOaEs_qVOAcdNGBbEb2w@mail.gmail.com> <7034.1532728300@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWDGa+ut=xsoki+XFKzdD7KruJJicfH1tKdBtywLuk7iQ@mail.gmail.com>
Content-ID: <11037.1532730454.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> > [*] Not without a 6-arg syscall or some other way of passing it.
> 
> Are there still architectures that have problems with 6-arg syscalls?

As I understand it, 6-arg syscalls are frowned upon.

> I suppose that, as long as there is never a case where fsconfig_set_path and
> fsconfig_set_fd both succeed, then it's not a big deal.

fsconfig_set_path/path_empty requires the 'value' argument to point to a
string, possibly "", and fsconfig_set_fd requires it to be NULL.

I can't stop you from doing:

	fd = open("/some/path", O_PATH);
	fsconfig(fsfd, fsconfig_set_fd, "fd", NULL, fd);

or:

	fd = open("/dev/sda6", O_RDWR);
	fsconfig(fsfd, fsconfig_set_path_empty, "foo", "", fd);

The first should fail because I'm using fget() not fget_raw() and the
second will pass the string and fd number to the filesystem, which will
presumably then call fs_lookup_param() to invoke pathwalk upon it - which will
likely also fail.

David
