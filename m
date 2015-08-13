From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC][PATCH 1/2] usb: gadget: configfs: add MTP function
Date: Thu, 13 Aug 2015 22:23:02 +0200
Message-ID: <55CCFCA6.9070907@samsung.com>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
 <1439493140-22207-2-git-send-email-amit.pundir@linaro.org>
 <55CCF156.8010302@samsung.com> <20150813195748.GB30092@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20150813195748.GB30092-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Lockwood <lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Benoit Goby <benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Peter Oh <poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Badhri Jagan Sridharan <Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Andrzej Pietrasiewicz <andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Yegor Yefremov <yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Philippe Reynes <tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 08/13/2015 09:57 PM, Greg Kroah-Hartman wrote:
> On Thu, Aug 13, 2015 at 09:34:46PM +0200, Krzysztof Opasiak wrote:
>> Hello,
>>
>> On 08/13/2015 09:12 PM, Amit Pundir wrote:
>>> his MTP function is based on years of work originally done in the
>>> Android kernel tree by:
>>>      Mike Lockwood<lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>      Benoit Goby<benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>      Colin Cross<ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>      Arve Hj=F8nnev=E5g<arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>      Peter Oh<poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>>      Greg Hackmann<ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>      Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> I've folded the series up to make it easier to review, and to provi=
de
>>> a coherent patch description.
>>>
>>> Post Gingerbread (Android v2.3), Android dropped USB Mass Storage
>>> in favor of Media Transfer Protocal (MTP), which is widely used for
>>> transferring media files to digital music players and similar
>>> applications. This USB gadget function implements MTP functionalty.
>>>
>>> Historically this function has been a part of Android composite
>>> gadget driver. Android composite driver was Android's solution
>>> for dynamic gadget function switching prior to the ConfigFS gadget
>>> being merged. There were failed few attempts in past
>>> http://marc.info/?l=3Dlinux-usb&m=3D132451695808552  to upstream An=
droid
>>> composite driver as well. Now this Android MTP gadget function has =
been
>>> re-implemented so as to be used as a generic ConfigFS function inst=
ead.
>>>
>>> Again, many thanks to Mike, Benoit, Colin, Arve, Peter, Greg and Ba=
dhri,
>>> as they are the real authors of this work. However, I've folded the=
ir
>>> patches together and modified it enough that I don't want them to b=
e
>>> blamed for any mistakes I've made condensing their patches down.
>>>
>>> Cc: Mike Lockwood<lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>> Cc: Benoit Goby<benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>> Cc: Colin Cross<ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>> Cc: Arve Hj=F8nnev=E5g<arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>> Cc: Peter Oh<poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>> Cc: Greg Hackmann<ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Cc: Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Cc: Android Kernel Team<kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>> Cc: Greg Kroah-Hartman<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>>> Cc: Jonathan Corbet<corbet-T1hC0tSOHrs@public.gmane.org>
>>> Cc: Felipe Balbi<balbi-l0cyMroinI0@public.gmane.org>
>>> Cc: Andrzej Pietrasiewicz<andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>> Cc: Laurent Pinchart<laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
>>> Cc: Yegor Yefremov<yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
>>> Cc: Philippe Reynes<tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> Cc: John Stultz<john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> Cc: Sumit Semwal<sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> Signed-off-by: Amit Pundir<amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> In my humble opinion adding such function to Linux kernel doesn't ma=
ke any
>> sense. By design, MTP is a protocol which requires access to userspa=
ce
>> features esp. file system. It is very important to run MTP daemon wi=
th
>> suitable user and LSM label and many many other issues which should =
be
>> handled by userspace access policy.
>>
>> Moreover this is not a fully functional USB function but only some i=
nterface
>> which can be used by mtp-responder (mtp-daemon - call it as you like=
) to
>> communicate with host. As we have FunctionFS which allows to impleme=
nt any
>> USB function in as a userspace service. As MTP nature is more relate=
d to
>> userspace I think that porting MTP daemon to use this is a right way=
 to go.
>> This should be much more reasonable than adding new function which a=
lso
>> requires daemon for proper working. So why add another interface whi=
le we
>> can use a generic one?
>
> Isn't there already a userspace MTP daemon that uses the existing
> functionfs for usb gadgets?  I thought I remember seeing that
> somewhere...
>

I know for sure that ADB and SDB has been ported to use functionfs. I=20
can even see ADB with ffs backend working on my nexus 9 with 3.10 kerne=
l.

I've seen such mtp-responder implementation but that time it has not=20
been published to open source. I don't know what is the current state..=
=2E

Best regards,

--=20
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
