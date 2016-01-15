From: Nikolaus Rath <Nikolaus-BTH8mxji4b0@public.gmane.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Fri, 15 Jan 2016 13:38:01 -0800
Message-ID: <87oacm7ccm.fsf@thinkpad.rath.org>
References: <565394BE.4040506@codeaurora.org>
	<5696E366.2080605@codeaurora.org> <20160114045716.GB8006@kroah.com>
	<5697EF97.9020800@codeaurora.org>
	<CA+55aFwxaU0Y_UxyKFv6WaYsPWDDzZG-rhVtMuLSPcJ0WLLw2A@mail.gmail.com>
	<CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g@mail.gmail.com>
	<CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw@mail.gmail.com>
	<871t9i91e1.fsf@thinkpad.rath.org> <56994884.9060002@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56994884.9060002-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> (Nikhilesh Reddy's message of
	"Fri, 15 Jan 2016 11:29:08 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Jan 15 2016, Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> Our local benchmarks on embedded devices (where power and cpu usage i=
s
> critical) show that splice doesnt help as much .. when running
> multiple cpu's results in increased power usage
>
> The below results are on a specific device model.
>
> Where IOPS is number of 4K based read or writes that could be perform=
ed each second.
>
>                                  regular         spliced         Stac=
ked I/O
> sequencial write (MiBPS)	56.55633333	100.34445       141.7096667
> sequencial read (MiBPS)	        49.644	        60.43434        122.36=
7
>
> random write (IOPS)	        2554.333333	4053.4545       8572
> random read (IOPS)	        977.3333333	1223.34         1432.666667
>
> The above tests were performed using a file size of 1GB

That looks convincing to me.

> Also we can called it FUSE_DELEGATED_IO if that helps :).
> I chose to call is stacked i/o since we are technically stacking the
> fuse read/writes on the ext4/fat or other filesystems.

Yeah, but "stacked" has a pretty strong association with union/overlay
file systems (as you have seen), and the feature is not at all specific
to that usecase.

=46or example, many FUSE file systems store data in some remote server
over the network but cache it on a local disk. The access to the cached
data would benefit from the feature under discussion, but I have a hard
time thinking of such a FUSE file system being "stacked" on the file
system that happens to hold its cache.


Best,
-Nikolaus

--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
