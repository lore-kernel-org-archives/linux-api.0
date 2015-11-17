From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 2/2] iio: health: Add driver for the TI AFE4404 heart
 monitor
Date: Tue, 17 Nov 2015 11:07:52 -0600
Message-ID: <564B5EE8.1040604@ti.com>
References: <1446309089-21094-1-git-send-email-afd@ti.com>
 <1446309089-21094-3-git-send-email-afd@ti.com> <56367B95.3030105@kernel.org>
 <5637C96C.5010602@ti.com> <563A5F1E.70904@kernel.org>
 <563A75E7.3040602@ti.com> <563BA952.107@kernel.org> <5642434C.3020609@ti.com>
 <56487595.5010402@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56487595.5010402-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/15/2015 06:07 AM, Jonathan Cameron wrote:
> On 10/11/15 19:19, Andrew F. Davis wrote:
>> On 11/05/2015 01:09 PM, Jonathan Cameron wrote:
>>> Lars, Hartmut, Peter,
>>>
>>> This is becoming a really involved ABI discussion so I'd like some
>>> input on this if any of you have the time.
>>>
>>> I'm going to be busy now until at least the weekend...
>>>
>>> On 04/11/15 21:17, Andrew F. Davis wrote:
>>>> On 11/04/2015 01:40 PM, Jonathan Cameron wrote:
>>>>> On 02/11/15 20:37, Andrew F. Davis wrote:
>>>>>> On 11/01/2015 02:52 PM, Jonathan Cameron wrote:
>>>>>>> On 31/10/15 16:31, Andrew F. Davis wrote:
>>>>>>>> Add driver for the TI AFE4404 heart rate monitor and pulse oximeter.
>>>>>>>> This device detects reflected LED light fluctuations and presents an ADC
>>>>>>>> value to the user space for further signal processing.
>>>>>>>>
>>>>>>>> Data sheet located here:
>>>>>>>> http://www.ti.com/product/AFE4404/datasheet
>>>>>>>>
>>>>>>>> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>>>>>>> Hi Andrew,
>>>>>>>
>>>>>>> Good to see this resurface.  It's a fascinating little device.
>>>>>>>
>>>>>>> Anyhow, most of the interesting bit in here is unsuprisingly concerned
>>>>>>> with the interface.  I know we went round a few loops of this before but
>>>>>>> it still feels like we haven't worked out to handle it well.  I would like
>>>>>>> as much input as we can get on this as inevitablly it will have
>>>>>>> repercussions outside this driver.
>>>>>>>
>>>>>>> Your approach of hammering out descriptive sysfs attributes is a good
>>>>>>> starting point but we need to work towards a formal description that
>>>>>>> can be generalised.  Whilst there are not many similar devices out there
>>>>>>> to this one, I suspect there are a few and more may well show up in
>>>>>>> future.
>>>>>>>
>>>>>>
>>>>>> Yeah, I'm working on brining up drivers for them now :)
>>>>> cool
>>>>>>
>>>>>>> The escence of my rather roundabout response inline is that I'm suggesting
>>>>>>> adding a new channel type to represent light transmission, taking the analogous
>>>>>>> case of proximity devices in which we are looking at light reflection.
>>>>>>> I've also taken the justification we use for illuminance vs intensity readings
>>>>>>> for two sensor ALS sensors as a precident for having compound channels of a different
>>>>>>> type to the 'raw' data that feeds them.  Hence I propose something along
>>>>>>> the lines of:
>>>>>>>
>>>>>>> in_intensityX_raw (raw channel value with the led on)
>>>>>>> in_intensityX_ambient_raw (raw channel value with the led off)
>>>>>>>
>>>>>>
>>>>>> I'm not sure, I know it may be too late for a lot of drivers but putting the 'X'
>>>>>> against the 'intensity' works for devices like ADCs/DACs with a simple list
>>>>>> of numeric channels, but for any other device with named channels this will
>>>>>> become very inconsistent, especially when adding modified channels and
>>>>>> differential channels.
>>>>> Sadly its ABI now so we can't realistically change it.  We can extend, we can't
>>>>> replace (we we can over the course of a lot of years but that's a nightmare).
>>>>>
>>>>>>
>>>>>> For example:
>>>>>>
>>>>>> in_intensity5_name_ambient-2_mean_raw
>>>>> The oddity here is that in your case the device in interacting with a stimulus
>>>>> output.  Normally the index reflects an actual sensor.  We are kind of bludgeoning
>>>>> it in. The only equivalently nasty case I know of is touch screens where different
>>>>> resistances are being connected - from a generic point of view those are a nightmare
>>>>> as well (as every implementation does it differently).
>>>>
>>>> Yeah, this part really doesn't fit the mold for this subsystem, or
>>>> any really, hwmon, input, were also considered, but the plan is still
>>>> to attempt to shoehorn it in to this one, so hopefully you can bear with me
>>>> on all these oddities :)
>>> Much as it irritates my sense of neat and tidy I guess that if we do end up with
>>> an ABI for this that we don't like later it isn't the end of the world as I doubt
>>> we'll be inundated with hundreds of these sensors.
>>>
>>> However, lets keep the naming within reason to how we would naturally extend
>>> the ABI.
>>>
>>> Having thought more on these differential channels, do we really need to have
>>> them explicitly as differential channels at all?  Perhaps we are better off with
>>>
>>> in_intensity0_led1_raw
>>> in_intensity1_ambient_raw
>>> in_intensity2_transmitted_led1_raw
>>>
>>> in_intensity3_led2_raw
>>> in_intensity4_ambient_raw
>>> in_intensity5_transmitted_led2_raw
>>>
>>> in_intenisty6_led3_raw
>>> in_intenisty7_ambient_raw
>>> in_intensity8_transmitted_led3_raw
>>>
>>> in_intensity9_transmitted_led1_meanfiltered_raw
>>> (and it does want to be explicitly meanfiltered and not mean
>>> which would imply the mean over all time)
>>>
>>> in_intensity10_transmitted_led2_meanfiltered_raw
>>>
>>> It's simple, descriptive and almost fits in the current ABI - you could
>>> even blugeon it in easily enough except for the mean filtered case.
>>> In many ways this is your naming proposal after all.
>>>
>>
>> One issue might be that we really only have 4 real channels that become
>> different things depending on how you setup the device. Matching the
>> names of the registers is the only way we can label these, as the user
>> might change their use.
>>
>> in_intensity_[RegName]_raw
>>
>> I really can't see any way around it, the channels are just too adjustable.
> Lots of channels to cover the use case the hardware supports.  This happens
> all the time on SoC ADCs as they can be wired to pretty much anything
> internally or externally.
>>
>> This will really be true for the 	 driver, the part looks to
>> have about 13 different measurement inputs it can take, all user-select
>> multiplexed into 1 register/channel. :/
>
> That's fine, support them all independently then use available_scan_masks
> to control which sets are possible.  You end up with a lot of 'channels'
> but a coherent interface.   Sounds like 52 channels in that devices case
> which isn't too bad - of which you can only have 4 at a time (or looking
> at the sheet, only 1 at a time perhaps? - note for fiddly cases we have
> the validate_scan_mask callback to do this in code - see validate_scanmask_onehot
> for example).
>

I see, I'll look into this.

After looking over the max30100 driver, I've realized I really don't need to
be exposing these channels to sysfs at all as they are only useful measured
together in a triggered/timed buffer. Should clean things up a bit.

> This is a common enough case on ADCs (particularly soc ones) where you have
> sampling slots that can effectively be allocated to hundreds of channels,
> but the ability to only pick a few at a time.
>
> Looking at that part you might want to add some configuration (device tree
> or similar) to restrict what channels are actually plausible given you either
> have a weighcell or a body composition thingy attached to a given physical
> input!
>

I think all inputs will be hooked up in a real use case, I'm not sure
though.

[...]

>>>
>>>>
>>>>>>
>>>>>>> The led version of ambient strikes me as odd to start with given I think the LED
>>>>>>> is turned off during that measurement?  This is merely to do with when they
>>>>>>> occur in the sequence?
>>>>>>>
>>>>>>> What we are really dealing with here is a single photodiode and an led sequencer.
>>>>>>> Perhaps we need a modifier that simply means the source is an led driven at the same instance?
>>>>>>> (this is the same as for proximity sensors, but there the signal is explicitly proximity).
>>>>>>>
>>>>>>
>>>>>> Yeah, the device is basically one photodiode and one ADC feeding to one of four storage
>>>>>> registers. The sequencer controls which LEDs are on, what buffer to fill, and
>>>>>> when the ADC is sampling from which buffer to which register. This is all user definable
>>>>>> so you can sample one LED twice, or not even sample the ambient light at all if you
>>>>>> want.
>>>>>>
>>>>>> This I why I would like to keep the input names locked to the data sheet, they are named
>>>>>> based on the name of the sequencer control that fills them. Abstracting this away would
>>>>>> add endless confusion.
>>>>>>
>>>>>>> Maybe, we should be treating these as a different type entirely?  They are measuring light
>>>>>>> levels, but in common with proximity sensors the 'interesting' bit is what is effecting
>>>>>>> those levels.  Perhaps a new type would make sense.
>>>>>>> How about:
>>>>>>>
>>>>>>> in_intensitytransmittedX_raw
>>>>>>> in_intensityX_raw
>>>>>>>
>>>>>>> This makes a mess of the differential channels however, as suddenly they are taking the
>>>>>>> difference of two signals of different types.  Ah well there goes a good plan.  I'd neglected
>>>>>>> that the transmitted version is the combination of the ambient and the transmitted.
>>>>>>>
>>>>>>> This is irritatingly hard to map onto anything generic.
>>>>>>>
>>>>>>
>>>>>> Exactly, there is no reason to enforce generic names for devices like these.
>>>>> If there is going to be more than one of them and a common userspace library
>>>>> then we need to have at least a consistent ABI.
>>>>
>>>> Sure, so then I would just avoid the issue by not adding another type for this,
>>>> mostly one off, case.
>>> I'm wondering ultimately how one off it is... What over devices use light transmitted...
>>> Hmm. scanners etc I guess, can't think of other cases with a single led and light sensor
>>> off the top of my head..  Ahah, optical swipe card readers (I'm sure I saw one somewhere
>>> once ;)
>>>
>>
>> Radar, X-ray, if you include all reflected electromagnetic waves as light...
> Fair point (my day job is x-ray so I ought to have thought of that - we use pin diodes
> on some machines to indirectly estimate very small masses).
>
> Still this got more complex in my mind when I saw the other device vaguely similar to this
> one that I have a driver to review for... Matt Rantostay's
> [RFC v1] iio: light: add MAX30100 oximeter driver support
>
> I think that type is using reflected light rather than transmitted for a similar job.  What
> fun.
>
> Actually if you wouldn't mind taking a look at Matt's driver as someone rather more
> knowledgeable about these kinds of drivers than me that would be great!
>

ACK, I'll comment on that thread if I find something interesting. Looks like the health
folder will be growing :)

[...]

>>>>
>>>>> Yes, the framework grows over time, and yes it needs to be extended. This is only
>>>>> natural as new devices turn up that do new things.
>>>>>
>>>>> Be careful to note that your strings naming the things would be just as much part of
>>>>> the ABI as any new modifier or channel type.
>>>>>
>>>>
>>>> Not necessarily, if the names match a regualar pattern or are provided to userspace in
>>>> a standard way, it wouldn't be any different that any other ABI that has different files
>>>> available or returns different values depending on what devices are available.
>>>
>>> I agree, so where is the advantage?  All you end up with is a massive look up table
>>> of namings. We have that now, just the other way around and deliberately more restrictive
>>> to try and keep life sane fo the userspace libraries.
>>>
>>
>> This will help us to lose the lookup table we need now, the available sysfs names and
>> their uses can all be read out dynamically from a single common interface.
> It's just moving the look up table around. From a review point of view I much
> prefer the restrictions we effectively apply now by having it done this way as
> it means I can be 99% sure that most drivers are within the ABI (sure we could write
> tools to check this doing it the other way)

I can see it being nice from a review point of view, no real objections to the current
way, just an idea.


[...]

>>>>>>>> +
>>>>>>>> +What:        /sys/bus/iio/devices/iio:deviceX/out_current_offdac_ledY_raw
>>>>>>>> +        /sys/bus/iio/devices/iio:deviceX/out_current_offdac_ledY_ambient_raw
>>>>>>>> +Date:        October 2015
>>>>>>>> +KernelVersion:
>>>>>>>> +Contact:    Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>>>>>>>> +Description:
>>>>>>>> +        Get and set the offset cancellation DAC setting for these
>>>>>>>> +        stages.
>>>>>>>> +        Values range from 0 -> 15
>>>>>>> Are these in mA?
>>>>>>>
>>>>>>> Not sure I like the naming here.  You could either treat them as explicit output
>>>>>>> channels, or (and I'd be tempted to favour this) as calibration offsets for the
>>>>>>> in_intensitytransmitted_ channel described above (or maybe the straight intensity
>>>>>>> channels - I'm now confused on what is what here!).
>>>>>>>
>>>>>>
>>>>>> Can you imagine how the user will feel if we try to hide all the details with
>>>>>> these names? The data sheet calls them 'offdac_led1' so why hide that.
>>>>> Because the next datasheet that comes along for a different part might call
>>>>> them something subtly different then we end up with needing custom userspace
>>>>> code for each part.  If we do that then there is no point in having the devices
>>>>> in IIO in the first place.   The reason all this ABI needs to be considered from
>>>>> a generic point of view is that we are setting precedence.  Naming should not
>>>>> be defined by what it happened to be called on the particular instance of
>>>>> the datasheet against which the first driver was defined (and yes we have
>>>>> had instances of the names changing entirely on datasheets).
>>>>>
>>>>> The point is to come up with ABI that is generic. That is probably the most
>>>>> important part of IIO (and the bit we spend most time discussing / arguing about).
>>>>>
>>>>> This is a calibration offset applied to the incoming signal - arguably by calling
>>>>> offdac_led1 you are obscuring the useful information to the user which is 'what
>>>>> is this for?'.
>>>>>
>>>>
>>>> If anything they would be offsets for the in_intensity_ledX_raw channels, but
>>>> then I'm not sure how you would handle types, the offset is set with current,
>>>> the measured value is in intensity.
>>> The advantage of caliboffset is it's unscaled and the relationship to the output
>>> is deliberately never defined as it's rarely linear - so 'what' it is doesn't
>>> actually matter.
>>>
>>> We have these on IMUs for example - they often correspond to something magic
>>> in the analog front end that is not even in the datasheet - though if you are
>>> lucky there is an application note explaining the magic test needed to derive
>>> a value (sometimes read from another register under some particular condition).
>>> Usually they are just burnt in values that no one normally touches.
>>>
>>
>> Hmm, looking back at the data sheet these gains are not for the individual channels,
>> they change the whole front end gain, so they probably won't work as channel
>> claiboffsets.
> That's what info_mask_shared_by_all is for.
>
>

Hmmm, I may have been misinterpreting it's use, I'll look into this.

[...]
