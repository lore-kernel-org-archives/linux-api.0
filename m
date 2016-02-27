From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/7] vfs: add the RWF_HIPRI flag for preadv2/pwritev2
Date: Sat, 27 Feb 2016 09:58:49 +0100
Message-ID: <20160227085849.GE4255@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de> <1456160876-14560-5-git-send-email-hch@lst.de> <x49r3fzkufg.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49r3fzkufg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 26, 2016 at 04:56:03PM -0500, Jeff Moyer wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > This adds a flag that tells the file system that this is a high priority
> > request for which it's worth to poll the hardware.  The flag is purely
> > advisory and can be ignored if not supported.
> 
> I'm not in love with the HIGHPRI name, but I don't have a better one in
> mind.  So...

I don't really like it too much either.  So if someone else has a better
suggestion: you're welcome!
