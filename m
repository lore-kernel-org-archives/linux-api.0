From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/14] block: Add specific data integrity errors
Date: Wed, 11 Jun 2014 09:54:55 -0700
Message-ID: <20140611165455.GG9511@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-13-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401334128-15499-13-git-send-email-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 28, 2014 at 11:28:46PM -0400, Martin K. Petersen wrote:
> Introduce a set of error codes that can be used by the block integrity
> subsystem to signal which class of error was encountered by either the
> I/O controller or the storage device.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

New error code should be run past linux-kernel and linux-api.

I'd also love to see something catching these so that they don't
leak to userspace.

In fact I'd really prefer to not overload the errno space with something
so block specific if possible - we use very few errnos in the
bio/request errors, and cleaning them up to use a block-specific error
type would be the best solution.
