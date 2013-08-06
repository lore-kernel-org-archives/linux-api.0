From: Christoph Hellwig <hch@lst.de>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 07:54:25 +0200
Message-ID: <20130806055425.GA9280@lst.de>
References: <20130805222544.GA19168@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-41783-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-##L=##H@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20130805222544.GA19168@brightrain.aerifal.cx>
To: Rich Felker <dalias@aerifal.cx>
Cc: linux-api@vger.kernel.org, "Joseph S. Myers" <joseph@codesourcery.com>, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 05, 2013 at 06:25:44PM -0400, Rich Felker wrote:
> Hi,
> 
> [I'm resending this to linux-api instead of linux-kernel on the advice
> of Joseph Myers on libc-alpha. Please see the link to the libc-alpha
> thread at the bottom of this message for discussion that has already
> taken place.]

As told you earlier on linux-kernel just send a patch with your semantics
to lkml.  We're not going to reserve a value for a namespace that is
reserved for the kernel to implement something that should better
be done in kernel space.
