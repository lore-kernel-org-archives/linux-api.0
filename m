From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [RFC PATCH 3/3] iio: derive the mounting matrix from ACPI _PLD
 objects
Date: Mon, 04 May 2015 12:23:46 +0100
Message-ID: <554756C2.5070407@kernel.org>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>	<1430146908-27919-4-git-send-email-octavian.purdila@intel.com>	<64714.10.254.87.235.1430149342.squirrel@linux.intel.com>	<CAE1zot+YKTPmVbG-_fNRy-E_VCcqq1VE78H3PMSMb5HvsBheQw@mail.gmail.com>	<553EB0B3.5000707@linux.intel.com> <CAE1zot+fusrvow+s2+CmoctcSD=c2BxoSyd2b=7MBv-pg68A+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAE1zot+fusrvow+s2+CmoctcSD=c2BxoSyd2b=7MBv-pg68A+Q@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>, sathyanarayanan.kuppuswamy@linux.intel.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>, Robert Moore <robert.moore@intel.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, lenb@kernel.org, linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 28/04/15 03:23, Octavian Purdila wrote:
> On Tue, Apr 28, 2015 at 12:57 AM, sathyanarayanan kuppuswamy
> <sathyanarayanan.kuppuswamy@linux.intel.com> wrote:
>> Hi
>>
>> On 04/27/2015 08:54 AM, Octavian Purdila wrote:
>>>
>>> On Mon, Apr 27, 2015 at 6:42 PM, Kuppuswamy Sathyanarayanan
>>> <sathyanarayanan.kuppuswamy@linux.intel.com> wrote:
>>>>
>>>> Since Acpi framework already exports this info to user space, Why not do
>>>> this derivation in user space code ? Why do we need new ABI, if the same
>>>> can be derived from existing one.
>>>>
>>> The ABI was added in the previous patch so that we can present the
>>> sensor orientation information to userspace even in the case of device
>>> tree.
>>
>> If the main reason for implementing a new ABI is to support DT platforms,
>> Why not implement a version of _PLD for device tree ? Don't you think it
>> would be much better than adding a new ABI to export redundant information ?
>>
> 
> IMO the mounting matrix is more consistent with the IIO ABIs. Although
> I have no issue with repicating _PLD for device tree if people agree
> that it is better.
> 
>> Also the location information of the device is not just specific to iio
>> drivers. You should consider that we would have similar requirements for
>> devices implemented as input or platform drivers.
> 
> The upstream standard for those sensors where the orientation matters
> (accelerometer, gyro, compass) is IIO.
It's probably worth pull Dmitry in on this conversation as well (and maybe
the input list). cc'd.

For reference of those who haven't seen this before.  The question here is about
exposing the sensor mounting matrix ( orientation of the sensor frame of reference
relative to some 'magic' orientation - probably the PCB )

Note I'd also throw in here that I'd argue for a combined R T matrix
e.g. [R T] so as to cover cases where we care about the position as well as the
orientation relative to some reference point.  A class case in point would
be rotation measurement from offset accelerometers.

Could go with a full projective geometry matrix, but probably better to keep it
in some base scale e.g.
[R   T]
[000 1]
but not bother exporting the 000 1 as it'll always be the same.


Note I've written this email whilst without net access (free wifi at
Stansted airport is rubbish!) so haven't checked out the existing ACPI ABI.
Will try and remember to do this when I get a moment with working internet.

Jonathan  
> 
> Granted, there are other device types for which the orientation
> information may be useful (e.g. camera). However the actual
> interpretation and action to be taken is different for each subsystem
> (e.g. in the camera case do the correction via V4L2_CID_HFLIP /
> V4L2_CID_VFLIP) so I think it is better to expose it at the subsystem
> level in a way consistent with the subsystem's ABIs.
> 

