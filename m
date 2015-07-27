From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Mon, 27 Jul 2015 10:33:31 -0700
Message-ID: <20150727173331.GA17594@infradead.org>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
 <1437061068-26118-5-git-send-email-ming.lei@canonical.com>
 <20150727084020.GA28336@infradead.org>
 <CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
 <20150727094530.GA15507@infradead.org>
 <CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Justin M. Forbes" <jforbes@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 05:53:33AM -0400, Ming Lei wrote:
> Because size has to be 4k aligned too.

Yes.  But again I don't see any reason to limit us to a hardcoded 512
byte block size here, especially considering the patches to finally
allow enabling other block sizes from userspace.
