From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] fanotify: don't expose EOPENSTALE to userspace
Date: Tue, 25 Apr 2017 16:51:50 +0300
Message-ID: <CAOQ4uxiQ1WQ5g-xXFnwOwkf4Ej3-qi_rcDraq8fxxRvHFfG3Lw@mail.gmail.com>
References: <1493119775-4558-1-git-send-email-amir73il@gmail.com> <20170425134230.GE30046@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425134230.GE30046-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "stable [v4.9]" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 25, 2017 at 4:42 PM, J . Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> On Tue, Apr 25, 2017 at 02:29:35PM +0300, Amir Goldstein wrote:
>> When delivering an event to userspace for a file on an NFS share,
>> if the file is deleted on server side before user reads the event,
>> user will not get the event.
>>
>> If the event queue contained several events, the stale event is
>> quietly dropped and read() returns to user with events read so far
>> in the buffer.
>>
>> If the event queue contains a single stale event or if the stale
>> event is a permission event, read() returns to user with the kernel
>> internal error code 518 (EOPENSTALE), which is not a POSIX error code.
>>
>> Check the internal return value -EOPENSTALE in fanotify_read(), just
>> the same as it is checked in path_openat() and drop the event in the
>> cases that it is not already dropped.
>
> Makes sense to me.
>
> Of course we can't prevent the case where a file's deleted on the server
> after the read but before the application uses the event, so the
> application could see ESTALE on a later operation; but that's not the
> case you're talking about here.
>

Sure. This is not meant to prevent ESTALE, just to prevent EOPENSTALE
and there was no point to report ESTALE to the user in this case.

I do have another patch coming up to fix the same issue in overlayfs,
where I do return ESTALE instead of EOPENSTALE.

Amir.
