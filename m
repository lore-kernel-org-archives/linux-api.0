From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
 between namespaces
Date: Thu, 21 Jul 2016 16:41:12 +0200
Message-ID: <c9bdaf3d-ec93-d754-81ac-9f524a0d0954@gmail.com>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468520419-28220-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andrey,

On 07/14/2016 08:20 PM, Andrey Vagin wrote:
> Each namespace has an owning user namespace and now there is not way
> to discover these relationships.
>
> Pid and user namepaces are hierarchical. There is no way to discover
> parent-child relationships too.
>
> Why we may want to know relationships between namespaces?
>
> One use would be visualization, in order to understand the running system.
> Another would be to answer the question: what capability does process X have to
> perform operations on a resource governed by namespace Y?
>
> One more use-case (which usually called abnormal) is checkpoint/restart.
> In CRIU we age going to dump and restore nested namespaces.
>
> There [1] was a discussion about which interface to choose to determing
> relationships between namespaces.
>
> Eric suggested to add two ioctl-s [2]:
>> Grumble, Grumble.  I think this may actually a case for creating ioctls
>> for these two cases.  Now that random nsfs file descriptors are bind
>> mountable the original reason for using proc files is not as pressing.
>>
>> One ioctl for the user namespace that owns a file descriptor.
>> One ioctl for the parent namespace of a namespace file descriptor.
>
> Here is an implementaions of these ioctl-s.

Could you add here an of the API in detail: what do these FDs refer to,
and how do you use them to solve the use case? And could you you add
that info to the commit messages please.

Thanks,

Michael


> [1] https://lkml.org/lkml/2016/7/6/158
> [2] https://lkml.org/lkml/2016/7/9/101
>
> Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
> Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>
> --
> 2.5.5
>
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
