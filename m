From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
Date: Fri, 24 Oct 2014 11:55:23 -0400
Message-ID: <x49k33po42c.fsf@segfault.boston.devel.redhat.com>
References: <cover.1413923420.git.milosz@adfin.com>
	<cover.1413923420.git.milosz@adfin.com>
	<ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
	(Milosz Tanski's message of "Tue, 21 Oct 2014 16:46:59 -0400")
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> Filesystems that generic_file_read_iter will not be allowed to perform
> non-blocking reads. This only will read data if it's in the page cache and if
> there is no page error (causing a re-read).
>
> Christoph Hellwig wrote the filesystem specify code (cifs, ofs, shm, xfs).
>
> Signed-off-by: Milosz Tanski <milosz@adfin.com>

Add in the 2 hunks from the other patches, as suggested by Christoph,
and you can add my:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
