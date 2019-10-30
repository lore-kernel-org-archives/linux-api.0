From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Wed, 30 Oct 2019 23:38:38 +0100
Message-ID: <d08d13d9-8eee-9c1e-2f8d-e846063882d7@rasmusvillemoes.dk>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <CAOi1vP97DMX8zweOLfBDOFstrjC78=6RgxK3PPj_mehCOSeoaw@mail.gmail.com>
 <4892d186-8eb0-a282-e7e6-e79958431a54@rasmusvillemoes.dk>
 <CAOi1vP9paV2-2_S0NgfbZDE6+5kqHXVc9xabHVC-2Ss1MmXkCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOi1vP9paV2-2_S0NgfbZDE6+5kqHXVc9xabHVC-2Ss1MmXkCg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-security-module@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 30/10/2019 23.16, Ilya Dryomov wrote:
> On Wed, Oct 30, 2019 at 9:35 PM Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
>>
>> On 30/10/2019 17.19, Ilya Dryomov wrote:
>>> On Thu, Oct 24, 2019 at 11:49 AM David Howells <dhowells@redhat.com> wrote:
>>>>  /*
>>>> - * We use a start+len construction, which provides full use of the
>>>> - * allocated memory.
>>>> - * -- Florian Coosmann (FGC)
>>>> - *
>>>> + * We use head and tail indices that aren't masked off, except at the point of
>>>> + * dereference, but rather they're allowed to wrap naturally.  This means there
>>>> + * isn't a dead spot in the buffer, provided the ring size < INT_MAX.
>>>> + * -- David Howells 2019-09-23.
>>>
>>> Hi David,
>>>
>>> Is "ring size < INT_MAX" constraint correct?
>>
>> No. As long as one always uses a[idx % size] to access the array, the
>> only requirement is that size is representable in an unsigned int. Then
>> because one also wants to do the % using simple bitmasking, that further
>> restricts one to sizes that are a power of 2, so the end result is that
>> the max size is 2^31 (aka INT_MAX+1).
> 
> I think the fact that indices are free running and wrap at a power of
> two already restricts you to sizes the are a power of two,

Ah, yes, of course. When reducing indices mod n that may already have
been implicitly reduced mod N, N must be a multiple of n for the result
to be well-defined.

Rasmus
