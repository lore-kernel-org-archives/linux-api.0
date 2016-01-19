From: =?UTF-8?Q?Emilio_L=c3=b3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: [PATCH v1 0/1] ioctl to disallow detaching kernel USB drivers
Date: Tue, 19 Jan 2016 13:39:59 -0300
Message-ID: <569E66DF.3050004@collabora.co.uk>
References: <Pine.LNX.4.44L0.1511301113120.1938-100000@iolanthe.rowland.org>
 <565C8376.6070505@samsung.com> <20151130172028.GA1088@kroah.com>
 <565C9A18.6000006@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565C9A18.6000006-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

I'm reviving this thread as there's no consensus so far, and I'd like t=
o=20
see this supported in some way in mainline.

El 30/11/15 a las 15:48, Krzysztof Opasiak escribi=F3:
>
>
> On 11/30/2015 06:20 PM, Greg KH wrote:
>> On Mon, Nov 30, 2015 at 06:12:22PM +0100, Krzysztof Opasiak wrote:
>>>
>>>
>>> On 11/30/2015 05:16 PM, Alan Stern wrote:
>>>> On Fri, 27 Nov 2015, Krzysztof Opasiak wrote:
>>>>
>>>>>>> I run through your code and as far as I understand above is not
>>>>>>> exactly
>>>>>>> true. Your patch allows only to prevent userspace from accessin=
g
>>>>>>> interfaces
>>>>>>> which has kernel drivers, there is no way to stop an applicatio=
n
>>>>>>> from taking
>>>>>>> control over all free interfaces.
>>>>>>>
>>>>>>> Let's say that your device has 3 interfaces. First of them has =
a
>>>>>>> kernel
>>>>>>> driver but second and third doesn't. You have 2 apps. One shoul=
d
>>>>>>> communicate
>>>>>>> using second interface and another one third. But first app is
>>>>>>> malicious and
>>>>>>> it claims all free interfaces of received device (your patch
>>>>>>> doesn't prevent
>>>>>>> this). And when second app starts it is unable to do anything
>>>>>>> with the
>>>>>>> device because all interfaces are taken. How would you like to
>>>>>>> handle this?
>>>>>>
>>>>>> You can't, and why would you ever want to, as you can't tell wha=
t
>>>>>> an app
>>>>>> "should" or "should not" do.  If you really care about this, the=
n
>>>>>> use a
>>>>>> LSM policy to prevent this.
>>>>>
>>>>> Well, an app can declare what it does and what it needs in it's
>>>>> manifest
>>>>> file (or some equivalent of this) and the platform should ensure =
that
>>>>> app can do only what it has declared.
>>>>>
>>>>> I would really like to use LSM policy in here but currently it is
>>>>> impossible as one device node represents whole device. Permission=
s
>>>>> (even
>>>>> those from LSM) are being checked only on open() not on each
>>>>> ioctl() so
>>>>> as far as I know there is nothing which prevents any owner of
>>>>> opened fd
>>>>> to claim all available (not taken by someone else) interfaces and=
 LSM
>>>>> policy is unable to filter those calls (unless we add some LSM ho=
oks
>>>>> over there).
>>>>
>>>> How about this approach?  Once a process has dropped its usbfs
>>>> privileges, it's not allowed to claim any interfaces (either expli=
citly
>>>> or implicitly).  Instead, it or some manager program must claim th=
e
>>>> appropriate interfaces before dropping privileges.
>>>>
>>>
>>> I agree that restricting interface claiming only to privileged
>>> process is a
>>> good idea. Unfortunately this generates a problem when program need=
s
>>> more
>>> than one interface (like in cdc - data + control for example). We
>>> need to
>>> declare both of them in first call to "usb-manager" or reopen the d=
ev
>>> node
>>> at second call and claim all interfaces claimed using this fd till
>>> now and
>>> claim one more and then drop privileges and send a new fd.

I talked with Reilly some time back and they proposed using an extra=20
parameter in the ioctl. This parameter would be a mask that specifies=20
which interfaces the unprivileged process is allowed to claim (but=20
doesn't necessarily have to do so). Providing a mask of ~0 would retain=
=20
the current patch behaviour, and allow existing programs using=20
out-of-tree implementations to continue working with little changes.

Now, if this were to be used on a system that knew better, via an app=20
manifest or similar, the manager process would generate a suitable mask=
=20
based on the interfaces required by the unprivileged process and use it=
=20
as a parameter when dropping privileges. This way, the unprivileged=20
process would be unable to claim interfaces it is not supposed to claim=
,=20
while allowing it the liberty to do as it wishes with the interfaces it=
=20
is allowed to use.

Krzysztof et al, would you find such an interface suitable? If you thin=
k=20
it could be a way forward I'll gladly write the code and send a new pat=
ch.

Cheers,
Emilio
