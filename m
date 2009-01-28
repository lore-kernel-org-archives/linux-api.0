From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Wed, 28 Jan 2009 10:14:18 -0800
Message-ID: <4980A07A.5060904@caviumnetworks.com>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org> <20090128031439.GA11025@redhat.com> <20090128173618.GA3174@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090128173618.GA3174-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jan 28, 2009 at 04:14:39AM +0100, Oleg Nesterov wrote:
>> I didn't send the actual patch. The idea is,
>>
>> 	can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
>> 	and I won't insist if you don't like is.
>>
>> 		static inline int try_lock_f_flags(struct file *file)
>> 		{
>> 			return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
>> 		}
> 
> ->f_flags is an unsigned int and the bit macros need an unsigned long.
> Increasing the size of struct file for this is probably a bad idea.
> 

Could that be seen as a deficiency in the bit macros?

Could we modify them so that they worked on unsigned int as well?  I 
know we could for some architectures.

David Daney
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
