From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Wed, 30 Oct 2019 21:35:09 +0100
Message-ID: <4892d186-8eb0-a282-e7e6-e79958431a54@rasmusvillemoes.dk>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <CAOi1vP97DMX8zweOLfBDOFstrjC78=6RgxK3PPj_mehCOSeoaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOi1vP97DMX8zweOLfBDOFstrjC78=6RgxK3PPj_mehCOSeoaw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>, David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-security-module@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 30/10/2019 17.19, Ilya Dryomov wrote:
> On Thu, Oct 24, 2019 at 11:49 AM David Howells <dhowells@redhat.com> wrote:
>>  /*
>> - * We use a start+len construction, which provides full use of the
>> - * allocated memory.
>> - * -- Florian Coosmann (FGC)
>> - *
>> + * We use head and tail indices that aren't masked off, except at the point of
>> + * dereference, but rather they're allowed to wrap naturally.  This means there
>> + * isn't a dead spot in the buffer, provided the ring size < INT_MAX.
>> + * -- David Howells 2019-09-23.
> 
> Hi David,
> 
> Is "ring size < INT_MAX" constraint correct?

No. As long as one always uses a[idx % size] to access the array, the
only requirement is that size is representable in an unsigned int. Then
because one also wants to do the % using simple bitmasking, that further
restricts one to sizes that are a power of 2, so the end result is that
the max size is 2^31 (aka INT_MAX+1).

> I've never had to implement this free running indices scheme, but
> the way I've always visualized it is that the top bit of the index is
> used as a lap (as in a race) indicator, leaving 31 bits to work with
> (in case of unsigned ints).  Should that be
> 
>   ring size <= 2^31
> 
> or more precisely
> 
>   ring size is a power of two <= 2^31

Exactly. But it's kind of moot since the ring size would never be
allowed to grow anywhere near that.

Rasmus
