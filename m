From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/10] fs: add RWF_DSYNC aand RWF_SYNC
Date: Tue, 9 Aug 2016 10:15:57 +0200
Message-ID: <20160809081557.GA10564@lst.de>
References: <1460044324-5298-1-git-send-email-hch@lst.de> <1460044324-5298-10-git-send-email-hch@lst.de> <CAKgNAkjza2eZnS7bzmvg1nB_jLmtk1N-o=uusD_hBo20sHTyaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkjza2eZnS7bzmvg1nB_jLmtk1N-o=uusD_hBo20sHTyaA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On Sun, Aug 07, 2016 at 07:45:03AM +1000, Michael Kerrisk (man-pages) wrote:
> I've added some documentation for these flags to the man page, but in
> the process I realized that have a question. Do these flags provide
> equivalents of O_DSYNC and O_SYNC for the I/O operation, or for the
> file? What I mean is this: with, say, RWF_DSYNC, is it just the data
> written by this pwritev2() call that is synced to the underlying file,
> or is all dirty data for the file synced at that point?

You beat me to it - I'm overdue sending you updates for these flags.

The flags only affect the actual pwritev2 operation they are applied
to.  That is only the range just written is guaranteed to be on
stable storage.

Btw, I was going to just send you a patch, but it seems your update
isn't out in the git tree yet, is it?
