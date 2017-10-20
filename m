From: Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/3] printk: Introduce per-console loglevel setting
Date: Fri, 20 Oct 2017 10:33:55 -0700
Message-ID: <11bdad91-4cf2-db79-6573-3afdc6bc125d@fb.com>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <b6faa2e2-1480-c306-9c3f-9329d4c5b62d@fb.com>
 <20171020080501.GD29163@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020080501.GD29163-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/20/2017 01:05 AM, Petr Mladek wrote:
> On Thu 2017-10-19 16:40:45, Calvin Owens wrote:
>> On 09/28/2017 05:43 PM, Calvin Owens wrote:
>>> Not all consoles are created equal: depending on the actual hardware,
>>> the latency of a printk() call can vary dramatically. The worst examples
>>> are serial consoles, where it can spin for tens of milliseconds banging
>>> the UART to emit a message, which can cause application-level problems
>>> when the kernel spews onto the console.
>>
>> Any thoughts on this series? Happy to resend again, but if there are no
>> objections I'd love to see it merged sooner rather than later :)
>>
>> Happy to resend too, just let me know.
> 
> There is no need to resend the patch. It is on my radar and I am
> going to look at it.
> 
> Please, be patient, you hit conference, illness, after vacation
> season. We do not want to unnecessarily delay it but it is
> not a trivial change that might be accepted within minutes.

No worries, just wanted to make sure it hadn't been missed :)

Thanks,
Calvin

> Best Regards,
> Petr
