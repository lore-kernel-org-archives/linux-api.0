From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 02/13] uapi: General notification ring definitions [ver
 #4]
Date: Sat, 8 Jun 2019 21:35:33 -0700
Message-ID: <6b6f5bb0-1426-239b-ac9f-281e31ddcd04@infradead.org>
References: <20190607151228.GA1872258@magnolia>
 <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk>
 <155991706083.15579.16359443779582362339.stgit@warthog.procyon.org.uk>
 <29222.1559922719@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <29222.1559922719@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/7/19 8:51 AM, David Howells wrote:
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 

>>> +	__u32			info;
>>> +#define WATCH_INFO_OVERRUN	0x00000001	/* Event(s) lost due to overrun */
>>> +#define WATCH_INFO_ENOMEM	0x00000002	/* Event(s) lost due to ENOMEM */
>>> +#define WATCH_INFO_RECURSIVE	0x00000004	/* Change was recursive */
>>> +#define WATCH_INFO_LENGTH	0x000001f8	/* Length of record / sizeof(watch_notification) */
>>
>> This is a mask, isn't it?  Could we perhaps have some helpers here?
>> Something along the lines of...
>>
>> #define WATCH_INFO_LENGTH_MASK	0x000001f8
>> #define WATCH_INFO_LENGTH_SHIFT	3
>>
>> static inline size_t watch_notification_length(struct watch_notification *wn)
>> {
>> 	return (wn->info & WATCH_INFO_LENGTH_MASK) >> WATCH_INFO_LENGTH_SHIFT *
>> 			sizeof(struct watch_notification);
>> }
>>
>> static inline struct watch_notification *watch_notification_next(
>> 		struct watch_notification *wn)
>> {
>> 	return wn + ((wn->info & WATCH_INFO_LENGTH_MASK) >>
>> 			WATCH_INFO_LENGTH_SHIFT);
>> }
> 
> No inline functions in UAPI headers, please.  I'd love to kill off the ones
> that we have, but that would break things.

Hi David,

What is the problem with inline functions in UAPI headers?

>> ...so that we don't have to opencode all of the ring buffer walking
>> magic and stuff?
> 
> There'll end up being a small userspace library, I think.

>>> +};
>>> +
>>> +#define WATCH_LENGTH_SHIFT	3
>>> +
>>> +struct watch_queue_buffer {
>>> +	union {
>>> +		/* The first few entries are special, containing the
>>> +		 * ring management variables.
>>
>> The first /two/ entries, correct?
> 
> Currently two.
> 
>> Also, weird multiline comment style.
> 
> Not really.

Yes really.

>>> +		 */

It does not match the preferred coding style for multi-line comments
according to coding-style.rst.


thanks.
-- 
~Randy
