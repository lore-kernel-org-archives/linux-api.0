From: Nikolaus Rath <Nikolaus-BTH8mxji4b0@public.gmane.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Fri, 15 Jan 2016 09:51:50 -0800
Message-ID: <871t9i91e1.fsf@thinkpad.rath.org>
References: <565394BE.4040506@codeaurora.org>
	<5696E366.2080605@codeaurora.org> <20160114045716.GB8006@kroah.com>
	<5697EF97.9020800@codeaurora.org>
	<CA+55aFwxaU0Y_UxyKFv6WaYsPWDDzZG-rhVtMuLSPcJ0WLLw2A@mail.gmail.com>
	<CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g@mail.gmail.com>
	<CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Antonio SJ Musumeci's message of "Fri, 15 Jan 2016 12:37:28 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Jan 15 2016, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org> wrote:
> The idea is that you want to be able to reason about open, create, et=
c. but
> don't care about the data transfer.
>
> I have N filesystems I wish to unionize. When I create a new file I w=
ant to
> pick the drive with the most free space (or some other algo). creat i=
s
> called, succeeds, and now the application issuing this starts writing=
=2E The
> FUSE fs doesn't care about the writes. It just wanted to pick the dri=
ve
> this file should have been created on. Anything I'd do with the FD af=
ter
> that I'm happy to short circuit. I don't need to be asked what to do =
when
> fstat'ing this FD or anything which in FUSE hands over the 'fh'. It's=
 just
> a file descriptor for me and I'd simply be calling the same function.
>
> Ideally I think one would want to be able to select which functions t=
o
> short circuit and maybe even have it so that a short circuited functi=
on
> could propagate back through FUSE on error. But the read and write sh=
ort
> circuiting is probably the biggest win given the overhead.


I think you should avoid using the term "stacked" completely (which
would also make Christoph happy). There have been several discussions i=
n
the past about adding a "fd delegation" function to FUSE. Generally, th=
e
idea is that the FUSE userspace code tells the FUSE kernel module to
internally "delegate" to writes and reads for a given file (or even a
range in that file) to a different file descriptor provided by
userspace.

I think that function would be useful, and not just for union file
systems. There are many FUSE file systems that end up writing the data
into some other file on the disk without doing any transformations on
the data itself. Especially with the range feature, they would all
benefit from the ability to delegate reads and writes.

However, Miklos has said in the past that the performance gain from thi=
s
is very small. You can get almost as good a result by splicing from one
fd to the other in userspace. In that case this function could actually
be implemented completely in libfuse.


Do you have any benchmark results that compare a splice-in-userspace
approach with your patch?


Best,
-Nikolaus

--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
