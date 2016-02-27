From: Christoph Hellwig <hch@lst.de>
Subject: Re: selective block polling and preadv2/pwritev2 revisited V2
Date: Sat, 27 Feb 2016 09:57:44 +0100
Message-ID: <20160227085744.GC4255@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de> <x497fhrmaps.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x497fhrmaps.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 26, 2016 at 04:18:55PM -0500, Jeff Moyer wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > This series allows to selectively enable/disable polling for completions
> > in the block layer on a per-I/O basis.  For this it resurrects the
> > preadv2/pwritev2 syscalls that Milosz prepared a while ago (and which
> > are much simpler now due to VFS changes that happened in the meantime).
> > That approach also had a man page update prepared, which I will resubmit
> > with the current flags once this series makes it in.
> 
> It would be helpful for reviewers if you submitted the man page at the
> same time, in my opinion.

Ok.

> Do you have any plans on adding polling support to the buffered path?

How would that even make sense?
