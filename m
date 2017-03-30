From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 12:14:54 -0700
Message-ID: <CA+55aFyKLCCe2OFCnyLYPDMT+DNWhYRQiLwFx1UU1+sf9w3oKA@mail.gmail.com>
References: <20170330163327.23920-1-hch@lst.de> <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
 <20170330172159.GA24139@lst.de> <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg@mail.gmail.com>
 <ec12e823-5c32-3269-039a-1b97ab3d4819@cs.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <libc-alpha-return-78336-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <ec12e823-5c32-3269-039a-1b97ab3d4819@cs.ucla.edu>
To: Paul Eggert <eggert@cs.ucla.edu>
Cc: Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 12:02 PM, Paul Eggert <eggert@cs.ucla.edu> wrote:
>
>> I'm assuming you'd also possible want to be able to use F_SETFL to set
>> O_ATOMIC after the fact
>
> Just for fun, one thread can set O_ATOMIC at the same time another thread is
> doing a 'write'....

I'm sure that falls under "if you break it, you get to keep both
pieces". IOW, I don't think anybody will ever say that the concurrent
write has to have some particular semantics wrt the concurrent
O_ATOMIC. Maybe *part* of the write will be done with some semantics,
and part of the write will be done with other semantics.

My guess is that there is going to be very few O_ATOMIC users anyway,
and they'll very carefully set it once and test it (or not even test
it - just make it be a configuration flag and tell people "don't ask
for O_ATOMIC if your system doesn't support it")

                  Linus
