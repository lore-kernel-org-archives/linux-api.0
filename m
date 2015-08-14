From: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 1/2] usb: gadget: configfs: add MTP function
Date: Fri, 14 Aug 2015 15:23:23 +0530
Message-ID: <CAMi1Hd1xjHBhUM2gQ7Dhy6jQEAOgAwyQQyBoUHU+RztbYPrzcQ@mail.gmail.com>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
 <1439493140-22207-2-git-send-email-amit.pundir@linaro.org>
 <55CCF156.8010302@samsung.com> <20150813195748.GB30092@kroah.com> <55CD0108.4060303@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CD0108.4060303-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Lockwood <lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Benoit Goby <benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Peter Oh <poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Badhri Jagan Sridharan <Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Andrzej Pietrasiewicz <andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Yegor Yefremov <yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Philippe Reynes <tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14 August 2015 at 02:11, Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> w=
rote:
>
>
> On 08/13/2015 09:57 PM, Greg Kroah-Hartman wrote:
>>
>> On Thu, Aug 13, 2015 at 09:34:46PM +0200, Krzysztof Opasiak wrote:
>>>
>>> Hello,
>>>
>>> On 08/13/2015 09:12 PM, Amit Pundir wrote:
>>>>
>>>> his MTP function is based on years of work originally done in the
>>>> Android kernel tree by:
>>>>      Mike Lockwood<lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>>      Benoit Goby<benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>>      Colin Cross<ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>>      Arve Hj=C3=B8nnev=C3=A5g<arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>>      Peter Oh<poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>>>      Greg Hackmann<ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>      Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>> I've folded the series up to make it easier to review, and to prov=
ide
>>>> a coherent patch description.
>>>>
>>>> Post Gingerbread (Android v2.3), Android dropped USB Mass Storage
>>>> in favor of Media Transfer Protocal (MTP), which is widely used fo=
r
>>>> transferring media files to digital music players and similar
>>>> applications. This USB gadget function implements MTP functionalty=
=2E
>>>>
>>>> Historically this function has been a part of Android composite
>>>> gadget driver. Android composite driver was Android's solution
>>>> for dynamic gadget function switching prior to the ConfigFS gadget
>>>> being merged. There were failed few attempts in past
>>>> http://marc.info/?l=3Dlinux-usb&m=3D132451695808552  to upstream A=
ndroid
>>>> composite driver as well. Now this Android MTP gadget function has=
 been
>>>> re-implemented so as to be used as a generic ConfigFS function ins=
tead.
>>>>
>>>> Again, many thanks to Mike, Benoit, Colin, Arve, Peter, Greg and B=
adhri,
>>>> as they are the real authors of this work. However, I've folded th=
eir
>>>> patches together and modified it enough that I don't want them to =
be
>>>> blamed for any mistakes I've made condensing their patches down.
>>>>
>>>> Cc: Mike Lockwood<lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Benoit Goby<benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Colin Cross<ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Arve Hj=C3=B8nnev=C3=A5g<arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Peter Oh<poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>>> Cc: Greg Hackmann<ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>> Cc: Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>> Cc: Android Kernel Team<kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Greg Kroah-Hartman<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>>>> Cc: Jonathan Corbet<corbet-T1hC0tSOHrs@public.gmane.org>
>>>> Cc: Felipe Balbi<balbi-l0cyMroinI0@public.gmane.org>
>>>> Cc: Andrzej Pietrasiewicz<andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Laurent Pinchart<laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
>>>> Cc: Yegor Yefremov<yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
>>>> Cc: Philippe Reynes<tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> Cc: John Stultz<john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>> Cc: Sumit Semwal<sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>> Signed-off-by: Amit Pundir<amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>
>>>
>>> In my humble opinion adding such function to Linux kernel doesn't m=
ake
>>> any
>>> sense. By design, MTP is a protocol which requires access to usersp=
ace
>>> features esp. file system. It is very important to run MTP daemon w=
ith
>>> suitable user and LSM label and many many other issues which should=
 be
>>> handled by userspace access policy.
>>>
>>> Moreover this is not a fully functional USB function but only some
>>> interface
>>> which can be used by mtp-responder (mtp-daemon - call it as you lik=
e) to
>>> communicate with host. As we have FunctionFS which allows to implem=
ent
>>> any
>>> USB function in as a userspace service. As MTP nature is more relat=
ed to
>>> userspace I think that porting MTP daemon to use this is a right wa=
y to
>>> go.
>>> This should be much more reasonable than adding new function which =
also
>>> requires daemon for proper working. So why add another interface wh=
ile we
>>> can use a generic one?

=46airly valid point. I did see MTP mentioned in FunctionFS context in
Documentation/usb/functionfs.txt but I could not find an open
userpsace MTP daemon implementation based on F_FS to try.

>>
>>
>> Isn't there already a userspace MTP daemon that uses the existing
>> functionfs for usb gadgets?  I thought I remember seeing that
>> somewhere...
>>
>
> I've found some interesting link[2] which may mean that Sailfish OS g=
uys has
> some mtp implementation with functionfs backend:
>
> <<<<< cite
>
> - /dev/mtp
> mtp functionfs rw,relatime
>
>>>>>> cite
>
> Started digging and got it!
>
> This looks like mtp with ffs backend:
>
> https://github.com/nemomobile/buteo-mtp

Thanks for the pointer. This "buteo-mtp" looks interesting.

Regards,
Amit Pundir

>
> Didn't tested, even didn't try to compile, no guarantee;)
>
> Footnotes:
> 1 -
> http://reviewjolla.blogspot.com/2014/06/techspecs-android-on-jolla-ph=
one.html
>
>
> Best regards,
>
> --
> Krzysztof Opasiak
> Samsung R&D Institute Poland
> Samsung Electronics
