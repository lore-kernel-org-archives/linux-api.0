From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
 between namespaces
Date: Mon, 25 Jul 2016 13:47:51 +0200
Message-ID: <e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
 <c9bdaf3d-ec93-d754-81ac-9f524a0d0954@gmail.com>
 <20160721210650.GA10989@outlook.office365.com>
 <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
 <CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: mtk.manpages@gmail.com, Andrew Vagin <avagin@virtuozzo.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Serge Hallyn <serge.hallyn@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "criu@openvz.org" <criu@openvz.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Hi Andrey,

On 07/22/2016 08:25 PM, Andrey Vagin wrote:
> On Thu, Jul 21, 2016 at 11:48 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Andrey,
>>
>>
>> On 07/21/2016 11:06 PM, Andrew Vagin wrote:
>>>
>>> On Thu, Jul 21, 2016 at 04:41:12PM +0200, Michael Kerrisk (man-page=
s)
>>> wrote:
>>>>
>>>> Hi Andrey,
>>>>
>>>> On 07/14/2016 08:20 PM, Andrey Vagin wrote:
>>>
>>>
>>> <snip>
>>>
>>>>
>>>> Could you add here an of the API in detail: what do these FDs refe=
r to,
>>>> and how do you use them to solve the use case? And could you you a=
dd
>>>> that info to the commit messages please.
>>>
>>>
>>> Hi Michael,
>>>
>>> A patch for man-pages is attached. It adds the following text to
>>> namespaces(7).
>>>
>>> Since  Linux 4.X, the following ioctl(2) calls are supported for na=
mes=E2=80=90
>>> pace file descriptors.  The correct syntax is:
>>>
>>>       fd =3D ioctl(ns_fd, ioctl_type);
>>>
>>> where ioctl_type is one of the following:
>>>
>>> NS_GET_USERNS
>>>       Returns a file descriptor that refers to an owning  user  nam=
es=E2=80=90
>>>       pace.
>>>
>>> NS_GET_PARENT
>>>       Returns  a  file  descriptor  that refers to a parent namespa=
ce.
>>>       This ioctl(2) can be used for pid and user namespaces. For  u=
ser
>>>       namespaces,  NS_GET_PARENT and NS_GET_USERNS have the same me=
an=E2=80=90
>>>       ing.

=46or each of the above, I think it is worth mentioning that the
close-on-exec flag is set for the returned file descriptor.

>>>
>>> In addition to generic ioctl(2) errors, the following specific ones=
 can
>>> occur:
>>>
>>> EINVAL NS_GET_PARENT was called for a nonhierarchical namespace.
>>>
>>> EPERM  The  requested  namespace  is  outside  of the current names=
pace
>>>       scope.

Perhaps add "and the caller does not have CAP_SYS_ADMIN" in the initial
user namespace"?

>>>
>>> ENOENT ns_fd refers to the init namespace.
>>
>>
>> Thanks for this. But still part of the question remains unanswered.
>> How do we (in user-space) use the file descriptors to answer any of
>> the questions that this patch series was designed to solve? (This
>> info should be in the commit message and the man-pages patch.)
>
> I'm sorry, but I am not sure that I understand what you ask.
>
> Here are the origin questions:
> Someone else then asked me a question that led me to wonder about
> generally introspecting on the parental relationships between user
> namespaces and the association of other namespaces types with user
> namespaces. One use would be visualization, in order to understand th=
e
> running system. Another would be to answer the question I already
> mentioned: what capability does process X have to perform operations
> on a resource governed by namespace Y?
>
> Here is an example which shows how we can get the owning namespace
> inode number by using these ioctl-s.
>
> $ ls -l /proc/13929/ns/pid
> lrwxrwxrwx 1 root root 0 Jul 22 21:03 /proc/13929/ns/pid -> 'pid:[402=
6532228]'
>
> $ ./nsowner /proc/13929/ns/pid
> user:[4026532227]
>
> The owning user namespace for pid:[4026532228] is user:[4026532227].
>
> The nsowner  tool is cimpiled from this code:
>
> int main(int argc, char *argv[])
> {
>         char buf[128], path[] =3D "/proc/self/fd/0123456789";
>         int ns, uns, ret;
>
>         ns =3D open(argv[1], O_RDONLY);
>         if (ns < 0)
>                 return 1;
>
>         uns =3D ioctl(ns, NS_GET_USERNS);
>         if (uns < 0)
>                 return 1;
>
>         snprintf(path, sizeof(path), "/proc/self/fd/%d", uns);
>         ret =3D readlink(path, buf, sizeof(buf) - 1);
>         if (ret < 0)
>                 return 1;
>         buf[ret] =3D 0;
>
>         printf("%s\n", buf);
>
>         return 0;
> }

So, from my point of view, the important piece that was missing from
your commit message was the note to use readlink("/proc/self/fd/%d")
on the returned FDs. I think that detail needs to be part of the
commit message (and also the man page text). I think it even be
helpful to include the above program as part of the commit message:
it helps people more quickly grasp the API.

> Does this example answer to the origin question?

Yes.

>If it isn't, could
> you eloborate what you expect to see here.
>
> And I wrote one more example which show all relationships between
> namespaces. It enumirates all processes in a system, collects all
> namespaces and determins parent and owning namespaces for each of
> them, then it constructs a namespace tree and shows it.
>
> Here is a code: https://gist.github.com/avagin/db805f95e15ffb0af7e559=
dbb8de4418

That's great! Thanks!
 =20
> Here is an example of output for my test system:
> [root@fc24 nsfs]# ./nstree
> user:[4026531837]
>  \__  mnt:[4026532203]
>  \__  ipc:[4026531839]
>  \__  user:[4026532224]
>      \__  user:[4026532226]
>          \__  user:[4026532227]
>              \__  pid:[4026532228]
>      \__  pid:[4026532225]
>          \__  pid:[4026532228]
>  \__  user:[4026532221]
>      \__  pid:[4026532222]
>      \__  user:[4026532223]
>  \__  mnt:[4026532211]
>  \__  uts:[4026531838]
>  \__  cgroup:[4026531835]
>  \__  pid:[4026531836]
>      \__  pid:[4026532225]
>          \__  pid:[4026532228]
>      \__  pid:[4026532222]
>  \__  mnt:[4026531857]
>  \__  mnt:[4026531840]
>  \__  net:[4026531957]

Cheers,

Michael

>>>>> [1] https://lkml.org/lkml/2016/7/6/158
>>>>> [2] https://lkml.org/lkml/2016/7/9/101

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
