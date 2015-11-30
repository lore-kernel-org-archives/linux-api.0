From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 0/1] ioctl to disallow detaching kernel USB drivers
Date: Mon, 30 Nov 2015 18:12:22 +0100
Message-ID: <565C8376.6070505@samsung.com>
References: <Pine.LNX.4.44L0.1511301113120.1938-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <Pine.LNX.4.44L0.1511301113120.1938-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?Q?Emilio_L=c3=b3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 11/30/2015 05:16 PM, Alan Stern wrote:
> On Fri, 27 Nov 2015, Krzysztof Opasiak wrote:
>
>>>> I run through your code and as far as I understand above is not exactly
>>>> true. Your patch allows only to prevent userspace from accessing interfaces
>>>> which has kernel drivers, there is no way to stop an application from taking
>>>> control over all free interfaces.
>>>>
>>>> Let's say that your device has 3 interfaces. First of them has a kernel
>>>> driver but second and third doesn't. You have 2 apps. One should communicate
>>>> using second interface and another one third. But first app is malicious and
>>>> it claims all free interfaces of received device (your patch doesn't prevent
>>>> this). And when second app starts it is unable to do anything with the
>>>> device because all interfaces are taken. How would you like to handle this?
>>>
>>> You can't, and why would you ever want to, as you can't tell what an app
>>> "should" or "should not" do.  If you really care about this, then use a
>>> LSM policy to prevent this.
>>
>> Well, an app can declare what it does and what it needs in it's manifest
>> file (or some equivalent of this) and the platform should ensure that
>> app can do only what it has declared.
>>
>> I would really like to use LSM policy in here but currently it is
>> impossible as one device node represents whole device. Permissions (even
>> those from LSM) are being checked only on open() not on each ioctl() so
>> as far as I know there is nothing which prevents any owner of opened fd
>> to claim all available (not taken by someone else) interfaces and LSM
>> policy is unable to filter those calls (unless we add some LSM hooks
>> over there).
>
> How about this approach?  Once a process has dropped its usbfs
> privileges, it's not allowed to claim any interfaces (either explicitly
> or implicitly).  Instead, it or some manager program must claim the
> appropriate interfaces before dropping privileges.
>

I agree that restricting interface claiming only to privileged process 
is a good idea. Unfortunately this generates a problem when program 
needs more than one interface (like in cdc - data + control for 
example). We need to declare both of them in first call to "usb-manager" 
or reopen the dev node at second call and claim all interfaces claimed 
using this fd till now and claim one more and then drop privileges and 
send a new fd.

Maybe better option would be to add optional argument to claim interface 
ioctl() and allow to claim interface for other fd than the current one? 
So "usb-manager" could have fd with full control and claim interfaces 
for apps which have fds with restricted privileges.

Best regards,
-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
