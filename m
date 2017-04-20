From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: fanotify read returns with errno == EOPENSTALE
Date: Thu, 20 Apr 2017 16:34:55 +0300
Message-ID: <CAOQ4uxiJyrvEJMhM1jhiE5pCgP0iA_LL4Eo_h7UY00wkTKhbTg@mail.gmail.com>
References: <87inn12urq.fsf@drapion.f-secure.com> <CAOQ4uxjzjFDLmvebHmC4t4_tT8xyWfbHVGfKohEqw7ZjpxfV_w@mail.gmail.com>
 <20170322193122.GV29622@ZenIV.linux.org.uk> <CAOQ4uxhTd1j4HLgZFTdr7wwrhjzkVT8QeoXjca_AMZmYHF31sQ@mail.gmail.com>
 <87a88c2yxq.fsf@drapion.f-secure.com> <CAOQ4uxggwSDcjdyCDreKs7m0ZNy+6PQQNojm6qDU7mH2tQE-Bw@mail.gmail.com>
 <1490270212.3921.10.camel@poochiereds.net> <8760j02mfz.fsf@drapion.f-secure.com>
 <CAOQ4uxja14p02jQurLTGv_fHrs+UBa5qfacrgY_-7tyv6UJqdw@mail.gmail.com>
 <87lgqwa4tg.fsf@drapion.f-secure.com> <CAOQ4uxirSfVVYBexXrWccDHnE5oqxNgUh3-X5Ey1w4R=nHXDjA@mail.gmail.com>
 <CAOQ4uxjA8Z7wnwuHFCKeKT1xz0Gh-qS40Y6cfPi3fAM0MKsRuQ@mail.gmail.com> <87shl38d1x.fsf@drapion.f-secure.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87shl38d1x.fsf-q6puBR44SRrF1m+2HNTUelaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 20, 2017 at 3:43 PM, Marko Rauhamaa
<marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org> wrote:
> Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>
>> Sorry I messed up the previous patch. please try this one:
>
> I will try it.
>
>> +                        * do the right thing if there are no more events to
>> +                        * read (i.e. return bytes read, -EAGAIN or wait).
>
> EAGAIN is the right thing to do when FAN_NONBLOCK has been specified.
> Without FAN_NONBLOCK, EAGAIN is bound to confuse the application. That
> could be documented, of course.
>

My comment says "do the right thing ... -EAGAIN or wait", meaning depending
FAN_NONBLOCK. The same code that checks for FAN_NONBLOCK will
take care of that. My patch only takes care of dropping the stale event and
continue to next event. If there is no next event, code will "do the
right thing".

> More importantly, does EAGAIN here still guarantee EPOLLET semantics of
> epoll(7)? IOW, if I get EAGAIN, I shouldn't have to try read(2)ing the
> fanotify fd again before calling epoll_wait(2).
>

Yes, if you get EAGAIN it means there are no more events in the queue,
so shouldn't have to try read again.

Amir.
