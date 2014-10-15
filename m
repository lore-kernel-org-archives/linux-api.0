From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [RFC PATCH v2 3/3] i2c: show and change bus frequency via sysfs
Date: Wed, 15 Oct 2014 06:46:30 -0700
Message-ID: <543E7AB6.2090901@roeck-us.net>
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>	<1413298094-9276-4-git-send-email-octavian.purdila@intel.com>	<20141014154151.GB10067@roeck-us.net>	<CAE1zotKpgEqAhtQvsFFee8xnX02MmhwrM0YU-6OHVZHcxiAi9g@mail.gmail.com>	<543E7312.1020104@roeck-us.net> <CAE1zotL4TLpdCeaX4=1YC=9PenscvAMDXJDAdYdVRNmGcjJaeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE1zotL4TLpdCeaX4=1YC=9PenscvAMDXJDAdYdVRNmGcjJaeQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Johan Hovold <johan@kernel.org>, linux-i2c <linux-i2c@vger.kernel.org>, linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/15/2014 06:32 AM, Octavian Purdila wrote:
> On Wed, Oct 15, 2014 at 4:13 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 10/15/2014 04:49 AM, Octavian Purdila wrote:
>>>
>>> On Tue, Oct 14, 2014 at 6:41 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>
>>>>
>>>> On Tue, Oct 14, 2014 at 05:48:14PM +0300, Octavian Purdila wrote:
>>>>>
>>>>> This patch adds three new sysfs files: bus_frequency,
>>>>> bus_min_frequency and bus_max_frequency which allows the user to view
>>>>> or change the bus frequency on a per bus level.
>>>>>
>>>
>>> <snip>
>>>
>>>>> +
>>>>> +static DEVICE_ATTR(bus_frequency, S_IRUGO, i2c_sysfs_freq_show,
>>>>> +                i2c_sysfs_freq_store);
>>>>
>>>>
>>>> Consider using DEVICE_ATTR_RO here. Also, extra empty line.
>>>>
>>>
>>> Unfortunately that won't work because we must transform bus_frequency
>>> to a RW entry (via is_visible) if the bus can change the frequency. We
>>
>>
>> Ah yes, you are right.
>>
>>> can't use DEVIE_ATTR_RW either, because transforming a RW entry to a
>>> RO entry with is visible is not possible:
>>>
>>
>> Why not ?
>>
>> is_visible returns the desired mode. Just like you can return mode |
>> S_IWUSR,
>> you can return mode & ~S_IWUSR.
>>
>> Am I missing something ?
>>
>
> Here is how sysfs uses is_visible:
>
> static int create_files(struct kernfs_node *parent, struct kobject *kobj,
> ...
>                          if (grp->is_visible) {
>                                  mode = grp->is_visible(kobj, *attr, i);
>                                  if (!mode)
>                                          continue;
>                          }
>                          error = sysfs_add_file_mode_ns(parent, *attr, false,
>                                                         (*attr)->mode | mode,
>                                                         NULL);
>
> so basically is the mode set is the original mode from the attributed
> "or-ed" with the mode return by is_visible.
>
Ah, you are right. That's a new one for me. Thanks, I didn't notice earlier.
Good to know ;-).

Guenter
