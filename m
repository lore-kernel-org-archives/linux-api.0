From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v5 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Thu, 6 Nov 2014 10:46:13 -0500
Message-ID: <CANP1eJEjpQ6Kbk-GENocte2Dqeo7C-E54c-MWEm-BnQ=pD+xuw@mail.gmail.com>
References: <cover.1415220890.git.milosz@adfin.com>
	<20141106075641.GB15966@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20141106075641.GB15966@infradead.org>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 6, 2014 at 2:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
> This series looks good, do you also have a man page sniplet to document
> the new syscalls?
>

I just send out the two patches for the man pages, ran out of time
yesterday to update it for RWF_ODSYNC.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
