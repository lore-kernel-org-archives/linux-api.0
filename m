From: Paul Eggert <eggert@cs.ucla.edu>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 12:02:04 -0700
Message-ID: <ec12e823-5c32-3269-039a-1b97ab3d4819@cs.ucla.edu>
References: <20170330163327.23920-1-hch@lst.de>
 <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
 <20170330172159.GA24139@lst.de>
 <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-78335-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CA+55aFyg5sXb2vjW9Wt45asoveV7E1scqmph6Op6ZFYdGNwsEg@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 03/30/2017 11:19 AM, Linus Torvalds wrote:
> like "dd" growing an atomic flag and setting it on stdout),

'dd' typically assumes that if a flag O_FOO is not #defined by 
<fcntl.h>, then 'dd' can "#define O_FOO 0" and the rest of dd's code can 
assume O_FOO works "well enough" on older systems. I hope this 
backward-compatibility hack will suffice for O_ATOMIC too.


> I'm assuming you'd also possible want to be able to use F_SETFL to set
> O_ATOMIC after the fact

Just for fun, one thread can set O_ATOMIC at the same time another 
thread is doing a 'write'....
