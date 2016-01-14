From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Thu, 14 Jan 2016 07:52:00 -0800
Message-ID: <87mvs8qhun.fsf@thinkpad.rath.org>
References: <565394BE.4040506@codeaurora.org>
	<5696E366.2080605@codeaurora.org>
	<20160114082554.GA12489@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160114082554.GA12489@infradead.org> (Christoph Hellwig's
	message of "Thu, 14 Jan 2016 00:25:54 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Nikhilesh Reddy <reddyn@codeaurora.org>, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@linuxfoundation.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard.weinberger@gmail.com>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de
List-Id: linux-api@vger.kernel.org

On Jan 14 2016, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jan 13, 2016 at 03:53:10PM -0800, Nikhilesh Reddy wrote:
>> Add support for filesystem stacked read/write of files
>> when enabled through a userspace init option of FUSE_STACKED_IO.
>>=20
>> When FUSE_STACKED_IO is enabled all the reads and writes
>> to the fuse mount point go directly to the native filesystem
>> rather than through the fuse daemon. All requests that aren't
>> read/write still go thought the userspace code.
>
> Please write your stacked features as kernel drivers.

Could you explain in more detail? I think I don't understand either the
why, the how, or what you mean with driver in this context (not sure
which one it is).=20


(I'm not the original submitter but interested in this)


Best,
-Nikolaus

--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
