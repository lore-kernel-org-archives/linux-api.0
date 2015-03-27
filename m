From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add preadv2/pwritev2 documentation.
Date: Fri, 27 Mar 2015 09:49:32 -0700
Message-ID: <20150327094932.31b5c9fc.akpm@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<1426530746-32222-1-git-send-email-milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1426530746-32222-1-git-send-email-milosz@adfin.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, 16 Mar 2015 14:32:26 -0400 Milosz Tanski <milosz@adfin.com> wrote:

> +.BR pwritev2 ()
>  can also fail for the same reasons as
>  .BR lseek (2).
> -Additionally, the following error is defined:
> +Additionally, the following errors are defined:
> +.TP
> +.B EAGAIN
> +The operation would block. This is possible if the file descriptor \fIfd\fP refers to a socket and has been marked nonblocking
> +.RB ( O_NONBLOCK ),
> +or the operation is a
> +.BR preadv2
> +and the \fIflags\fP argument is set to
> +.BR RWF_NONBLOCK.

Can you please expand on this to describe the circumstances in which
pread2() returns -EAGAIN?  Let's fix up the short-read confusion.

And let's have a think about EAGAIN vs EWOULDBLOCK.
