From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: Re: [RFC][PATCH 1/2] usb: gadget: configfs: add MTP function
Date: Thu, 13 Aug 2015 22:41:44 +0200
Message-ID: <55CD0108.4060303@samsung.com>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
 <1439493140-22207-2-git-send-email-amit.pundir@linaro.org>
 <55CCF156.8010302@samsung.com> <20150813195748.GB30092@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <20150813195748.GB30092@kroah.com>
Sender: linux-doc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Amit Pundir <amit.pundir@linaro.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Mike Lockwood <lockwood@android.com>, Benoit Goby <benoit@android.com>, Colin Cross <ccross@android.com>, =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, Peter Oh <poh@broadcom.com>, Greg Hackmann <ghackmann@google.com>, Badhri Jagan Sridharan <Badhri@google.com>, Android Kernel Team <kernel-team@android.com>, Jonathan Corbet <corbet@lwn.net>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Yegor Yefremov <yegorslists@googlemail.com>, Philippe Reynes <tremyfr@gmail.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>
List-Id: linux-api@vger.kernel.org



On 08/13/2015 09:57 PM, Greg Kroah-Hartman wrote:
> On Thu, Aug 13, 2015 at 09:34:46PM +0200, Krzysztof Opasiak wrote:
>> Hello,
>>
>> On 08/13/2015 09:12 PM, Amit Pundir wrote:
>>> his MTP function is based on years of work originally done in the
>>> Android kernel tree by:
>>>      Mike Lockwood<lockwood@android.com>
>>>      Benoit Goby<benoit@android.com>
>>>      Colin Cross<ccross@android.com>
>>>      Arve Hj=F8nnev=E5g<arve@android.com>
>>>      Peter Oh<poh@broadcom.com>
>>>      Greg Hackmann<ghackmann@google.com>
>>>      Badhri Jagan Sridharan<Badhri@google.com>
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
>>> Cc: Mike Lockwood<lockwood@android.com>
>>> Cc: Benoit Goby<benoit@android.com>
>>> Cc: Colin Cross<ccross@android.com>
>>> Cc: Arve Hj=F8nnev=E5g<arve@android.com>
>>> Cc: Peter Oh<poh@broadcom.com>
>>> Cc: Greg Hackmann<ghackmann@google.com>
>>> Cc: Badhri Jagan Sridharan<Badhri@google.com>
>>> Cc: Android Kernel Team<kernel-team@android.com>
>>> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>> Cc: Jonathan Corbet<corbet@lwn.net>
>>> Cc: Felipe Balbi<balbi@ti.com>
>>> Cc: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
>>> Cc: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>>> Cc: Yegor Yefremov<yegorslists@googlemail.com>
>>> Cc: Philippe Reynes<tremyfr@gmail.com>
>>> Cc: John Stultz<john.stultz@linaro.org>
>>> Cc: Sumit Semwal<sumit.semwal@linaro.org>
>>> Signed-off-by: Amit Pundir<amit.pundir@linaro.org>
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

I've found some interesting link[2] which may mean that Sailfish OS guy=
s=20
has some mtp implementation with functionfs backend:

<<<<< cite

- /dev/mtp
mtp functionfs rw,relatime

 >>>>> cite

Started digging and got it!

This looks like mtp with ffs backend:

https://github.com/nemomobile/buteo-mtp

Didn't tested, even didn't try to compile, no guarantee;)

=46ootnotes:
1 -=20
http://reviewjolla.blogspot.com/2014/06/techspecs-android-on-jolla-phon=
e.html

Best regards,

--=20
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
