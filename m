From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Fri, 1 Feb 2019 18:05:42 +0000
Message-ID: <20190201180541.GQ2217@ZenIV.linux.org.uk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-6-axboe@kernel.dk>
 <CAG48ez0vDqDH4ks7q4L3F+xt-4kVQrN1yw34QwFAmwQyy27FTw@mail.gmail.com>
 <e9326a77-54c5-e2b8-d9e5-663261462597@kernel.dk>
 <CAG48ez17NW0GJVRC6dFcHZTgQifFz5og1XCUbXkHKhr6f=j74Q@mail.gmail.com>
 <05cb18f7a97a6151c305cdb7240c4abc995aed59.camel@fb.com>
 <CAG48ez09iOOnPz83b6HxktYHTfouS2GD6i3PfQEjp8WCp+3-VA@mail.gmail.com>
 <CAG48ez0sJys=M1MR3DBd1DJ21-qHd2W7sB8+EvjhScWbtQnizA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez0sJys=M1MR3DBd1DJ21-qHd2W7sB8+EvjhScWbtQnizA@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: Matt Mullins <mmullins@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, "avi@scylladb.com" <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 01, 2019 at 06:23:27PM +0100, Jann Horn wrote:

> > Oh, yuck. Uuuh... can we make "struct files_struct" doubly-refcounted,
> > like "struct mm_struct"? One reference type to keep the contents
> > intact (the reference type you normally use, and the type used by
> > uring when the thread is running), and one reference type to just keep
> > the struct itself existing, but without preserving its contents
> > (reference held consistently by the uring thread)?
> 
> Something like this (completely untested); and then instead of the
> current get_files_struct(), you'd do get_files_struct_weak(), and
> while the thread is running, it protects the files_struct from dying
> with tryget_weak_files_struct() / put_files_struct().
> 
> Al, do you have opinions on this?

Yes, but they are not fit for polite company.  IMO the entire approach
is FUBAR; I'll post more detailed review, but what I'd seen so far is
a veto fodder.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
