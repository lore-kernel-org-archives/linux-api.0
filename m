From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] iio: derive the mounting matrix from ACPI _PLD objects
Date: Mon, 4 May 2015 11:21:27 +0300
Message-ID: <CAE1zot+1qGPhquFH8+=MhiXNb-OoqKuiYJae3aATqntFO6Q-Jw@mail.gmail.com>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
	<1430146908-27919-4-git-send-email-octavian.purdila@intel.com>
	<64714.10.254.87.235.1430149342.squirrel@linux.intel.com>
	<CAE1zot+YKTPmVbG-_fNRy-E_VCcqq1VE78H3PMSMb5HvsBheQw@mail.gmail.com>
	<553EB0B3.5000707@linux.intel.com>
	<CAE1zot+fusrvow+s2+CmoctcSD=c2BxoSyd2b=7MBv-pg68A+Q@mail.gmail.com>
	<5546C72E.2040101@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5546C72E.2040101-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sathyanarayanan.kuppuswamy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael J Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 4, 2015 at 4:11 AM, Sathyanarayanan Kuppuswamy
<sathyanarayanan.kuppuswamy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Hi Octavian,
>
> On 04/27/2015 07:23 PM, Octavian Purdila wrote:
>>
>> On Tue, Apr 28, 2015 at 12:57 AM, sathyanarayanan kuppuswamy
>> <sathyanarayanan.kuppuswamy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>>>
>>> Hi
>>>
>>> On 04/27/2015 08:54 AM, Octavian Purdila wrote:
>>>>
>>>> On Mon, Apr 27, 2015 at 6:42 PM, Kuppuswamy Sathyanarayanan
>>>> <sathyanarayanan.kuppuswamy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>>>>>
>>>>> Since Acpi framework already exports this info to user space, Why not
>>>>> do
>>>>> this derivation in user space code ? Why do we need new ABI, if the
>>>>> same
>>>>> can be derived from existing one.
>>>>>
>>>> The ABI was added in the previous patch so that we can present the
>>>> sensor orientation information to userspace even in the case of device
>>>> tree.
>>>
>>> If the main reason for implementing a new ABI is to support DT platforms,
>>> Why not implement a version of _PLD for device tree ? Don't you think it
>>> would be much better than adding a new ABI to export redundant
>>> information ?
>>>
>> IMO the mounting matrix is more consistent with the IIO ABIs. Although
>> I have no issue with repicating _PLD for device tree if people agree
>> that it is better.
>
> Since your main issue is, device tree lacking ABI to specify location
> information, you should consider fixing it there. Let's wait for others
> comment on this.
>
> If you think mounting matrix provides more information than what is
> supported
> by _PLD,  then we should consider implementing another ABI. AFAIK, that is
> not
> the case here.
>
> Adding adding a new ABI to represent the information that can be derived
> from existing ABI does not seem to be useful.

AFAICS the ACPI _PLD information is not (yet) exported to userspace. This patch:

http://marc.info/?t=140795040700003&r=1&w=2

does not seem to be merged upstream. So there is no existing ABI to
derive from :)

>>
>>
>>> Also the location information of the device is not just specific to iio
>>> drivers. You should consider that we would have similar requirements for
>>> devices implemented as input or platform drivers.
>>
>> The upstream standard for those sensors where the orientation matters
>> (accelerometer, gyro, compass) is IIO.
>>
>> Granted, there are other device types for which the orientation
>> information may be useful (e.g. camera). However the actual
>> interpretation and action to be taken is different for each subsystem
>> (e.g. in the camera case do the correction via V4L2_CID_HFLIP /
>> V4L2_CID_VFLIP) so I think it is better to expose it at the subsystem
>> level in a way consistent with the subsystem's ABIs.
>
> I agree that location information is used differently at different
> sub systems. But my question is why we need  a new ABI ?
>
> Why not handle it in user space ?
>
> -
