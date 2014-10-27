From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
Date: Mon, 27 Oct 2014 02:58:12 -0700
Message-ID: <20141027095812.GB23416@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
 <x49k33po42c.fsf@segfault.boston.devel.redhat.com>
 <CANP1eJE-gRPNc9xDpAYKHVzcwS+v3AwDb=Dm1CBa=sevSczqjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <CANP1eJE-gRPNc9xDpAYKHVzcwS+v3AwDb=Dm1CBa=sevSczqjg@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 01:16:04PM -0400, Milosz Tanski wrote:
> Christoph, should I apply your last 3 patches to the end of this tree
> and send it along with the next submission?

Yes, please do.  Please make sure to take my fixed repost of the
"xfs: add RWF_NONBLOCK support" patch.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
