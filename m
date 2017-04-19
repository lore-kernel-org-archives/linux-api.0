From: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
Subject: Re: fanotify read returns with errno == EOPENSTALE
Date: Wed, 19 Apr 2017 16:46:03 +0300
Message-ID: <87lgqwa4tg.fsf@drapion.f-secure.com>
References: <87inn12urq.fsf@drapion.f-secure.com>
        <CAOQ4uxjzjFDLmvebHmC4t4_tT8xyWfbHVGfKohEqw7ZjpxfV_w@mail.gmail.com>
        <20170322193122.GV29622@ZenIV.linux.org.uk>
        <CAOQ4uxhTd1j4HLgZFTdr7wwrhjzkVT8QeoXjca_AMZmYHF31sQ@mail.gmail.com>
        <87a88c2yxq.fsf@drapion.f-secure.com>
        <CAOQ4uxggwSDcjdyCDreKs7m0ZNy+6PQQNojm6qDU7mH2tQE-Bw@mail.gmail.com>
        <1490270212.3921.10.camel@poochiereds.net>
        <8760j02mfz.fsf@drapion.f-secure.com>
        <CAOQ4uxja14p02jQurLTGv_fHrs+UBa5qfacrgY_-7tyv6UJqdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOQ4uxja14p02jQurLTGv_fHrs+UBa5qfacrgY_-7tyv6UJqdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Amir Goldstein's message of "Thu, 23 Mar 2017 09:47:07 -0400")
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

> On Thu, Mar 23, 2017 at 8:43 AM, Marko Rauhamaa
> <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org> wrote:
>> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
>>
>>> It was definitely not the intention to leak this error code to
>>> userland. EOPENSTALE is not a POSIX sanctioned error code, so
>>> applications generally don't know anything about it and will be
>>> confused.
>>
>> Got it. I will try to work on a reproduction and make a proper bug
>> report.
>
> Try this:
>
> - watch a single file for permissions events (so you will only have
> one event in the queue)
> - open file from client to generate single event (don't read event yet)
> - remove file from server (to make it stale)
> - read event (with stale file)

I did that and reproduced the problem on a recent development kernel.
Happens every time.

Just take the example program listed under "man fanotify" ("fantest")
and follow these steps:

    ==============================================================
    NFS Server    NFS Client(1)     NFS Client(2)
    ==============================================================
    # echo foo >/nfsshare/bar.txt
                  # cat /nfsshare/bar.txt
                  foo
                                    # ./fantest /nfsshare
                                    Press enter key to terminate.
                                    Listening for events.
    # rm -f /nfsshare/bar.txt
                  # cat /nfsshare/bar.txt
                                    read: Unknown error 518
                  cat: /nfsshare/bar.txt: Operation not permitted
    ==============================================================

where NFS Client (1) and (2) are two terminal sessions on a single NFS
Client machine.

So what do we conclude? Is this a kernel bug or works as designed?

> Oh my. I completely misread your report before. I though you were
> trying to read from the event->fd. Now I understand that you mean read
> from fanotify fd. That will definitely return the error, but only in
> the special case where open error happened on the first event being
> read to the buffer. If error happens after adding some events to the
> buffer, fanotify process will not know about this. Regular event will
> be silently dropped and permission event will be denied.
>
> [...]
>
> You do NOT need to call fanotify_init() again, the next read will read
> the next event.

It does appear that reading the fanotify fd again does the trick. 

However, the client gets an EPERM instead of ENOENT, which is a bit
weird.

> The fix seems trivial and I can post it once you have the test:
> - return EAGAIN for read in case of a single event in queue without fd
>   so apps getting the read error will have a good idea what to do
> - in case of non single event, maybe copy event with error on event->fd
>   to the buffer for specific errors that make sense to report (EMFILE)
>   so a watcher checks the values of negative event->fd can maybe do
>   something about it (e.g. provide a smaller buffer).

EAGAIN would be perfect for me since I'm using fanotify in a nonblocking
mode. It might be a bit surprising in the blocking case.


Marko

-- 
+358 44 990 4795
Skype: marko.rauhamaa_f-secure
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
