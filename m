From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/2] Add further ioctl() operations for namespace discovery
Date: Tue, 20 Dec 2016 11:53:38 +1300
Message-ID: <87bmw7pm31.fsf@xmission.com>
References: <0e229ec4-e3fc-dd46-c5b9-3afa0f14bfcd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0e229ec4-e3fc-dd46-c5b9-3afa0f14bfcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Michael
        Kerrisk's message of "Mon, 19 Dec 2016 15:38:15 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Eric,
>
> The code proposed in this patch series is pretty small. Is there any
> chance we could make the 4.10 merge window, if the changes seem
> acceptable to you?

I see why you are asking but I am not comfortable with aiming for
the merge window that is on-going and could close at any moment.
I have seen recenly too many patches that should work fine have
some odd minor issue.  Like an extra _ in a label used in an ifdef
that resulted in memory stomps.    Linus might be more brave but i would
rather wait until the next merge window, so I don't need to worry about
spoiling anyone's holidays with a typo someone over looked.

At first glance these patches seem reasonable. I don't see any problem
with the ioctls you have added.

That said I have a question.  Should we provide a more direct way to
find the answer to your question?  Something like the access system
call?

I think a more direct answer would be more maintainable in the long run
as it does not bind tools to specific implementation details in the
future.  Which could allow us to account for LSM policies and the like.

Eric
