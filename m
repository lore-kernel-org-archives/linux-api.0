From: Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Input: uinput: Sanity check on ff_effects_max and EV_FF
Date: Thu, 5 Nov 2015 23:34:55 +0100
Message-ID: <CADbOyBSeXDLzaSj=z3W2oMzg1DV3fP651wzLztUezSmf3B05qA@mail.gmail.com>
References: <1442510988-3164-1-git-send-email-elias.vds@gmail.com>
	<1442510988-3164-3-git-send-email-elias.vds@gmail.com>
	<20151015005226.GD3673@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151015005226.GD3673@dtor-ws>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "open list:HID CORE LAYER" <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dmitry,

Excuse me for the long delay.

On Thu, Oct 15, 2015 at 2:52 AM, Dmitry Torokhov
<dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Sep 17, 2015 at 07:29:48PM +0200, Elias Vanderstuyft wrote:
>> Currently the user can specify a non-zero value for ff_effects_max,
>> without setting the EV_FF bit.
>> Inversely,
>> the user can also set ff_effects_max to zero with the EV_FF bit set,
>> in this case the uninitialized method ff->upload can be dereferenced,
>> resulting in a kernel oops.
>>
>> Instead of adding a check in uinput_create_device() and
>> omitting setup of ff-core infrastructure silently in case the check fails,
>> perform the check early in uinput_setup_device(),
>> and print a helpful message and return -EINVAL in case the check fails.
>>
>> Signed-off-by: Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/input/misc/uinput.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
>> index 345df9b..3a90a16 100644
>> --- a/drivers/input/misc/uinput.c
>> +++ b/drivers/input/misc/uinput.c
>> @@ -393,6 +393,21 @@ static int uinput_setup_device(struct uinput_device *udev,
>>       if (IS_ERR(user_dev))
>>               return PTR_ERR(user_dev);
>>
>> +     if (!!user_dev->ff_effects_max ^ test_bit(EV_FF, dev->evbit)) {
>> +             if (user_dev->ff_effects_max)
>> +                     printk(KERN_DEBUG
>> +                             "%s: ff_effects_max (%u) should be zero "
>> +                             "when FF_BIT is not set\n",
>> +                             UINPUT_NAME, user_dev->ff_effects_max);
>> +             else
>> +                     printk(KERN_DEBUG
>> +                             "%s: ff_effects_max should be non-zero "
>> +                             "when FF_BIT is set\n",
>> +                             UINPUT_NAME);
>
> I do not think this is the right place for this check: userspace is
> allowed to write device structure before calling any ioctls to set
> various bits. Also, userspace doe snot have to explicitly set EV_FF bit
> as input_ff_create() does it for us.

OK, I put it here to be consistent with the uinput_validate_absbits() function,
which checks absbit in case the EV_ABS bit is set,
but I incorrectly assumed the EV_ABS bit was required to be set.

> I think the check should be in uinput_create_device() and we should only
> check case when udev->ff_effects_max is 0 but EV_FF is set.

This made me think about the whole idea whether or not
allowing ff_effects_max to be zero is possible for a FF device.
I think it is perfectly possible to have a FF device with no support
for uploading effects,
but with an adjustable AUTOCENTER-force axis.
Or, more exotically, a device with a trigger-button which on press
automatically emits rumble,
with adjustable GAIN.

The only places where we'd need to change code for allowing this,
is in:
- http://lxr.free-electrons.com/source/drivers/input/ff-core.c?v=4.3#L316
    : remove if-then-block
- http://lxr.free-electrons.com/source/drivers/input/misc/uinput.c?v=4.3#L266
    : change if-test to "udev->ff_effects_max || test_bit(EV_FF, dev->evbit)"
Of course, the latter change may conflict with your initial reply:
userspace does not have to explicitly set the EV_FF bit in advance;
however it does make sense to set the bit if e.g. only FF_AUTOCENTER
support is available,
but no uploading of effects (ff->upload and friends will still be set,
but not used, thanks to check_effect_access()).

What do you think about this: should I go with "forbid ff_effects_max
to be zero, and check on it" or "allow ff_effects_max to be zero"?
My previous patches wouldn't conflict with either options.

Thanks,
Elias
