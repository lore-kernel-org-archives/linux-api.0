From: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] pipe: make pipe user buffer limit checks more precise
Date: Wed, 17 Aug 2016 21:51:45 +0200
Message-ID: <57B4C051.7030200@oracle.com>
References: <86c85cff-7fee-cded-386a-e1d518573dda@gmail.com>
 <db82480c-7956-b89d-1f4e-ba2c94f4067e@gmail.com>
 <57B301FE.9090108@oracle.com>
 <1532b6c4-c618-348c-d36a-9679d5d5a1b4@gmail.com>
 <57B38CF7.5080803@oracle.com>
 <67c8abf7-df7c-444d-7876-d160a211c969@gmail.com>
 <57B4BC5B.9050405@oracle.com>
 <55f54f95-f614-179e-db4b-912adf2199bb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55f54f95-f614-179e-db4b-912adf2199bb-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/17/2016 09:41 PM, Michael Kerrisk (man-pages) wrote:
>>> So, would that mean something like the following (where I've moved
>>> some checks from pipe_fcntl() to pipe_set_size()):
>> [...]
>
> And, do you agree that something similar is required for alloc_pipe_info()
> when creating a pipe?

Yeah, that sounds correct to me.


Vegard
