From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 23:05:59 +0300
Message-ID: <6cbf0110-eb29-9b18-8f92-7ddf1d6c5cc2@plexistor.com>
References: <20170330163327.23920-1-hch@lst.de>
 <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
 <20170330172159.GA24139@lst.de>
 <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg@mail.gmail.com>
 <20170330182620.GA25251@lst.de>
 <CA+55aFyhH0924xwS4q8sJ=F-HZyoSQZJaQ6cWgTCAj4PjrZt8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyhH0924xwS4q8sJ=F-HZyoSQZJaQ6cWgTCAj4PjrZt8g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 03/30/2017 09:45 PM, Linus Torvalds wrote:
> On Thu, Mar 30, 2017 at 11:26 AM, Christoph Hellwig <hch@lst.de> wrote:
>>
>> That would be nice, but still won't work as we blindly copy f_flags
>> into F_GETFL, not even masking our internal FMODE_ bits.
> 
> Ok, *that* is just silly of us, and we could try to just fix, and even backport.
> 
> There's no possible valid use I could see where that should break
> (famous last words - user code does some damn odd things at times).
> 
> Of course, that won't fix old kernels that are out there, but then
> neither would your original patch...
> 
> Side note: I think you *can* detect the O_ATOMIC support by using
> F_SETFL, because F_SETFL only allows you to change flags that we
> recognize. So somebody who really wants to *guarantee* that O_ATOMIC
> is there and honored even with old kernels could presumable do
> something like
> 
>    fd = open(..); // *no* O_ATOMIC
>    fcnt(fd, F_SETFL, O_ATOMIC);
>    if (fcnt(fd, F_GETFL, NULL) & O_ATOMIC)
>         // Yay! We actually got it
>    else
>         // I guess we need to fall back on old behavior
> 
> although I agree that that is ridiculously inconvenient and not a
> great thing, and it's worth trying to aim for some better model.
> 

Perhaps in that case it is time for an F_GETFL2 an F_GET_REAL_FL
that gives you the nice simple user code Linus wanted for new applications.
and solves forward and backwords for applications and Kernels?

Just my $0.017
Boaz

>                     Linus
> 
