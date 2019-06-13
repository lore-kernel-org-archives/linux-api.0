From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 02/13] uapi: General notification ring definitions [ver
 #4]
Date: Thu, 13 Jun 2019 07:49:49 -0700
Message-ID: <575fa290-961f-8dcd-3b76-4608daa5ee0e@infradead.org>
References: <6b6f5bb0-1426-239b-ac9f-281e31ddcd04@infradead.org>
 <20190607151228.GA1872258@magnolia>
 <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk>
 <155991706083.15579.16359443779582362339.stgit@warthog.procyon.org.uk>
 <29222.1559922719@warthog.procyon.org.uk>
 <30226.1560432885@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30226.1560432885@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/13/19 6:34 AM, David Howells wrote:
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> What is the problem with inline functions in UAPI headers?
> 
> It makes compiler problems more likely; it increases the potential for name
> collisions with userspace; it makes for more potential problems if the headers
> are imported into some other language; and it's not easy to fix a bug in one
> if userspace uses it, just in case fixing the bug breaks userspace.
> 
> Further, in this case, the first of Darrick's functions (calculating the
> length) is probably reasonable, but the second is not.  It should crank the
> tail pointer and then use that, but that requires 
> 
>>>> Also, weird multiline comment style.
>>>
>>> Not really.
>>
>> Yes really.
> 
> No.  It's not weird.  If anything, the default style is less good for several
> reasons.  I'm going to deal with this separately as I need to generate some
> stats first.
> 
> David
> 

OK, maybe you are objecting to the word "weird."  So the multi-line comment style
that you used is not the preferred Linux kernel multi-line comment style
(except in networking code) [Documentation/process/coding-style.rst] that has been
in effect for 20+ years AFAIK.


-- 
~Randy
