From: Christoph Hellwig <hch@lst.de>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 16:03:21 +0200
Message-ID: <20130806140321.GA4421@lst.de>
References: <20130805222544.GA19168@brightrain.aerifal.cx> <20130806055425.GA9280@lst.de> <20130806134254.GT221@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-41794-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-##L=##H@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20130806134254.GT221@brightrain.aerifal.cx>
To: Rich Felker <dalias@aerifal.cx>
Cc: Christoph Hellwig <hch@lst.de>, linux-api@vger.kernel.org, "Joseph S. Myers" <joseph@codesourcery.com>, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2013 at 09:42:54AM -0400, Rich Felker wrote:
> > As told you earlier on linux-kernel just send a patch with your semantics
> 
> Apologies, I did not see the reply, and I'm still looking for it. I
> should have put the request to CC me more prominently in the email...

Sorry, it actually was libc-alpha that I replied to.  I didn't notice
you sent two slightly different messages instead of a having a cross-posted
discussion, which would have been more useful.

> 
> > to lkml.  We're not going to reserve a value for a namespace that is
> > reserved for the kernel to implement something that should better
> > be done in kernel space.
> 
> Did you mean "that should better be done in user space"?

No.  It should be done in kernelspace, just like all other O_ flags.

> 
> Whether O_SEARCH and O_EXEC are provided fully natively by the kernel
> or handled by userspace, either way a reserved value in the open flags
> must be set aside. Otherwise any value used by the userspace
> implementation would risk conflicting with future kernel features
> using the same bit(s).

No flag is going to get reserved without a proper (kernel-level)
implementation.
