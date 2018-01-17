From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Wed, 17 Jan 2018 08:49:22 -0500
Message-ID: <x49k1wg1tp9.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
	<20180110155853.32348-33-hch@lst.de>
	<x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com>
	<20180115085310.GB32532@lst.de> <20180116120433.GA14579@lst.de>
	<x493735b9l7.fsf@segfault.boston.devel.redhat.com>
	<20180117042721.GT13338@ZenIV.linux.org.uk>
	<20180117070827.GA26868@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180117070827.GA26868@lst.de> (Christoph Hellwig's message of
	"Wed, 17 Jan 2018 08:08:27 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Wed, Jan 17, 2018 at 04:27:21AM +0000, Al Viro wrote:
>> On Tue, Jan 16, 2018 at 07:41:24PM -0500, Jeff Moyer wrote:
>> >  	if (sigmask) {
>> > -		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
>> > +		if (!access_ok(VERIFY_READ, sigmask,
>> > +			       sizeof(void *) + sizeof(size_t)) ||
>> > +		    __get_user(up, (sigset_t __user * __user *)sigmask) ||
>> > +		    __get_user(sigsetsize,
>> > +			       (size_t __user *)(sigmask + sizeof(void *))))
>> >  			return -EFAULT;
>> 
>> How about copy_from_user() on a struct?  Making eyes bleed is fun, but
>> people tend to get annoyed when you do it to them...
>
> Above is the copy & paste version from pselect.  I've got both copy_from_user
> and that horrible version in my tree, and if we really need this awfull
> calling convention copy_from_user certainly is much better.  pselect
> also should be switched to explicit struct + copy_from_user while
> we're at it.  In fact glibc defines a struct for the userland version
> to start with.

Yeah, I did both, but stuck with this variant as that's what pselect
did.  I'm fine with switching to the struct variant.

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
