From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Tue, 16 Jan 2018 13:04:33 +0100
Message-ID: <20180116120433.GA14579@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-33-hch@lst.de> <x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com> <20180115085310.GB32532@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180115085310.GB32532@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 15, 2018 at 09:53:10AM +0100, Christoph Hellwig wrote:
> > pselect, as an example, crams the sigmask and size together.  Why not
> > just do that?  libaio can take care of setting that up.
> 
> Yes, I could try that.  It's just another double indirection for no
> good reason.

I cna't get this to work - for some reason I always end up with a NULL
sigmask in the kernel.  Nevermind that it leads to really crap code
generation.  I guess for select the latter doesn't matter too much as
everyone sane uses ppoll anyway.
