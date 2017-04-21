From: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
Subject: Re: fanotify read returns with errno == EOPENSTALE
Date: Fri, 21 Apr 2017 16:13:39 +0300
Message-ID: <871ssl9a4c.fsf@drapion.f-secure.com>
References: <87inn12urq.fsf@drapion.f-secure.com>
        <CAOQ4uxjzjFDLmvebHmC4t4_tT8xyWfbHVGfKohEqw7ZjpxfV_w@mail.gmail.com>
        <20170322193122.GV29622@ZenIV.linux.org.uk>
        <CAOQ4uxhTd1j4HLgZFTdr7wwrhjzkVT8QeoXjca_AMZmYHF31sQ@mail.gmail.com>
        <87a88c2yxq.fsf@drapion.f-secure.com>
        <CAOQ4uxggwSDcjdyCDreKs7m0ZNy+6PQQNojm6qDU7mH2tQE-Bw@mail.gmail.com>
        <1490270212.3921.10.camel@poochiereds.net>
        <8760j02mfz.fsf@drapion.f-secure.com>
        <CAOQ4uxja14p02jQurLTGv_fHrs+UBa5qfacrgY_-7tyv6UJqdw@mail.gmail.com>
        <87lgqwa4tg.fsf@drapion.f-secure.com>
        <CAOQ4uxirSfVVYBexXrWccDHnE5oqxNgUh3-X5Ey1w4R=nHXDjA@mail.gmail.com>
        <CAOQ4uxjA8Z7wnwuHFCKeKT1xz0Gh-qS40Y6cfPi3fAM0MKsRuQ@mail.gmail.com>
        <87shl38d1x.fsf@drapion.f-secure.com>
        <CAOQ4uxiJyrvEJMhM1jhiE5pCgP0iA_LL4Eo_h7UY00wkTKhbTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOQ4uxiJyrvEJMhM1jhiE5pCgP0iA_LL4Eo_h7UY00wkTKhbTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Amir Goldstein's message of "Thu, 20 Apr 2017 16:34:55 +0300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

> On Thu, Apr 20, 2017 at 3:43 PM, Marko Rauhamaa
> <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org> wrote:
>> Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>
>>> Sorry I messed up the previous patch. please try this one:
>>
>> I will try it.

Tried it. Superficially, it seems to be working, but...

>> More importantly, does EAGAIN here still guarantee EPOLLET semantics
>> of epoll(7)? IOW, if I get EAGAIN, I shouldn't have to try read(2)ing
>> the fanotify fd again before calling epoll_wait(2).
>
> Yes, if you get EAGAIN it means there are no more events in the queue,
> so shouldn't have to try read again.

I ran into a system hang with our real product that suggests there might
be a problem left. It would be explained if your patch generated an
EAGAIN while there were other events waiting in the queue.

I will have to investigate further.


Marko

-- 
+358 44 990 4795
Skype: marko.rauhamaa_f-secure
