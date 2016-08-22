From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/8] pipe: fix limit checking in pipe_set_size()
Date: Tue, 23 Aug 2016 07:37:55 +1200
Message-ID: <9b60a7ae-1bb5-16de-727f-78237ab9a89b@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <7f0732a9-6172-e92d-7c5b-473b769fe37e@gmail.com>
 <20160819054818.GH17944@1wt.eu>
 <60022222-ced6-85d4-77bb-bf8bf8ce668b@gmail.com>
 <20160821213541.GA3864@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160821213541.GA3864-K+wRfnb2/UA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Willy Tarreau <w@1wt.eu>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Willy,

On 08/22/2016 09:35 AM, Willy Tarreau wrote:
> Hi Michael,
> 
> On Mon, Aug 22, 2016 at 09:15:35AM +1200, Michael Kerrisk (man-pages) wrote:
>> Hi Willy,
>>
>> Might you have a chance to further review of this patch series?
>> It would be great if you could, since much of it touches changes
>> made by you earlier.
> 
> Well, all I did there was implementing a suggestion from Linus, but I'm
> not a specialist at all there. However I've read all your series and at
> least with my limited knowledge, all I've read seems to make sense at
> the code matches the descriptions. I don't remember any particular trap
> in this place so I'm not worried.

Okay.

> I remember that I noticed this inaccuracy in the accounting but I
> estimated it was not important since the goal was to *limit* resource
> usage with a simple patch that we could easily backport. Your approach
> looks clean and possibly backportable if needed. That's all I can say
> I'm afraid :-/

No problem. Thanks for the reply!

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
