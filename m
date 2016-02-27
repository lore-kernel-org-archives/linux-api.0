From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] block, directio: set a REQ_POLL flag when
	submitting polled bios
Date: Sat, 27 Feb 2016 09:57:22 +0100
Message-ID: <20160227085722.GB4255@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de> <1456160876-14560-8-git-send-email-hch@lst.de> <x49bn73mb38.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49bn73mb38.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 26, 2016 at 04:10:51PM -0500, Jeff Moyer wrote:
> Hi, Christoph,
> 
> REQ_POLL is set but never checked.  Is part of the patch missing, or was
> that intentional?

Jens insisted that I add it, even if there aren't users.  I disagree,
but in the end he'll have to apply the series..
