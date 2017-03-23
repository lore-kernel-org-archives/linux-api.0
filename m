From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: fanotify read returns with errno == EOPENSTALE
Date: Thu, 23 Mar 2017 09:47:07 -0400
Message-ID: <CAOQ4uxja14p02jQurLTGv_fHrs+UBa5qfacrgY_-7tyv6UJqdw@mail.gmail.com>
References: <87inn12urq.fsf@drapion.f-secure.com> <CAOQ4uxjzjFDLmvebHmC4t4_tT8xyWfbHVGfKohEqw7ZjpxfV_w@mail.gmail.com>
 <20170322193122.GV29622@ZenIV.linux.org.uk> <CAOQ4uxhTd1j4HLgZFTdr7wwrhjzkVT8QeoXjca_AMZmYHF31sQ@mail.gmail.com>
 <87a88c2yxq.fsf@drapion.f-secure.com> <CAOQ4uxggwSDcjdyCDreKs7m0ZNy+6PQQNojm6qDU7mH2tQE-Bw@mail.gmail.com>
 <1490270212.3921.10.camel@poochiereds.net> <8760j02mfz.fsf@drapion.f-secure.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8760j02mfz.fsf-q6puBR44SRrF1m+2HNTUelaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 23, 2017 at 8:43 AM, Marko Rauhamaa
<marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org> wrote:
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
>
>> It was definitely not the intention to leak this error code to
>> userland. EOPENSTALE is not a POSIX sanctioned error code, so
>> applications generally don't know anything about it and will be
>> confused.
>
> Got it. I will try to work on a reproduction and make a proper bug
> report.
>

Try this:

- watch a single file for permissions events (so you will only have
one event in the queue)
- open file from client to generate single event (don't read event yet)
- remove file from server (to make it stale)
- read event (with stale file)

>> I haven't looked closely at this particular problem, but IIRC we
>> usually just translate EOPENSTALE to ESTALE, and that may be all that
>> needs to be done here. If this happened in the RHEL kernel, then
>> please do open a bug with Red Hat and we'll get it straightened out.
>
> ESTALE has not been mentioned as a possible error code from an fanotify
> read. Most importantly, since read fails, I suppose there is no recovery
> but you must close the fanotify fd and call fanotify_init() again. Or
> should I just ignore it and read on? If so, why bother returning the
> error from the kernel in the first place?
>

Oh my. I completely misread your report before.
I though you were trying to read from the event->fd.
Now I understand that  you mean read from fanotify fd.
That will definitely return the error, but  only in the special case
where open error
happened on the first event being read to the buffer.
If error happens after adding some events to the buffer, fanotify
process will not know
about this. Regular event will be silently dropped and permission event will be
denied.

>From fanotify(7) man page BUGS section:

       *  If  a  call  to read(2) processes multiple events from the
fanotify queue
          and an error occurs, the return value will be the total
length of the events
          successfully copied to the user-space buffer before the
error occurred.
          The return value will not be -1, and errno will not be set.
          Thus, the reading application has no way to detect the error.

There is  small subset of open errors that you could get for failure to create
an fd for the event, like  ENODEV/ENXIO and EMFILE.
You do NOT need to call fanotify_init() again, the next read will read
the next event.
(That information might be useful in man page)


>> That said, you should take heed that all of the [fa|i|d]notify APIs do
>> not extend beyond the local machine when you use them on network
>> filesystems. If you're expecting to get notification of events that
>> are occurring on other clients, you're going to be disappointed here.
>
> That certainly is disappointing. However, there is a certain level of
> coherency one would expect, namely:
>
>  * An NFS4 client opening a file should be subject to an OPEN_PERM check
>    on that client (if the client is monitoring the mount point).
>
>  * An NFS4 client opening a file should be subject to an OPEN_PERM check
>    on the server (if the server is monitoring the mount point).
>
>  * An fanotify read should not fail mysteriously. Rather, a read on
>    metadata->fd should be the one failing.
>

Depending on the error.
If you can't get an fd, how will the event be reported?
With my suggestion to pass filehandle on event, fd is redundant,
so event can be passed with the error on fd field.

Please try to create a reproducer for case where error is returned
and when it is not.

The fix seems trivial and I can post it once you have the test:
- return EAGAIN for read in case of a single event in queue without fd
  so apps getting the read error will have a good idea what to do
- in case of non single event, maybe copy event with error on event->fd
  to the buffer for specific errors that make sense to report (EMFILE)
  so a watcher checks the values of negative event->fd can maybe do
  something about it (e.g. provide a smaller buffer).

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
