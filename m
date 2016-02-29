From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 7/7] block, directio: set a REQ_POLL flag when submitting polled bios
Date: Mon, 29 Feb 2016 09:28:51 -0500
Message-ID: <x49si0bmvz0.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
	<1456160876-14560-8-git-send-email-hch@lst.de>
	<x49bn73mb38.fsf@segfault.boston.devel.redhat.com>
	<20160227085722.GB4255@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160227085722.GB4255@lst.de> (Christoph Hellwig's message of
	"Sat, 27 Feb 2016 09:57:22 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Fri, Feb 26, 2016 at 04:10:51PM -0500, Jeff Moyer wrote:
>> Hi, Christoph,
>> 
>> REQ_POLL is set but never checked.  Is part of the patch missing, or was
>> that intentional?
>
> Jens insisted that I add it, even if there aren't users.  I disagree,
> but in the end he'll have to apply the series..

OK.  I think it just adds confusion.

Cheers,
Jeff
