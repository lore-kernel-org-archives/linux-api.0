From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/8] pipe: fix limit checking in pipe_set_size()
Date: Mon, 22 Aug 2016 09:15:35 +1200
Message-ID: <60022222-ced6-85d4-77bb-bf8bf8ce668b@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <7f0732a9-6172-e92d-7c5b-473b769fe37e@gmail.com>
 <20160819054818.GH17944@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160819054818.GH17944-K+wRfnb2/UA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Willy Tarreau <w@1wt.eu>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Willy,

Might you have a chance to further review of this patch series?
It would be great if you could, since much of it touches changes
made by you earlier.

Thanks,

Michael

On 08/19/2016 05:48 PM, Willy Tarreau wrote:
> Hi Michael,
> 
> Since you're changing this code, it's probably worth swapping the size
> check and capable() below to save a function call in the normal path :
> 
> On Fri, Aug 19, 2016 at 05:25:35PM +1200, Michael Kerrisk (man-pages) wrote:
>> +	if (nr_pages > pipe->buffers) {
>> +		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
> 
> =>		if (size > pipe_max_size && !capable(CAP_SYS_RESOURCE)) {
> 
>> +			ret = -EPERM;
>> +			goto out_revert_acct;
>> +		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
>> +				too_many_pipe_buffers_soft(pipe->user)) &&
>> +				!capable(CAP_SYS_RESOURCE) &&
>> +				!capable(CAP_SYS_ADMIN)) {
>> +			ret = -EPERM;
>> +			goto out_revert_acct;
>> +		}
>> +	}
> (...)
> 
> Cheers,
> Willy
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
