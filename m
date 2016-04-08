From: huang ying <huang.ying.caritas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
Date: Sat, 9 Apr 2016 07:46:04 +0800
Message-ID: <CAC=cRTO9rmWLoqgCuY-_HprykJfQU62GcHucUnvM657f5ZuxCw@mail.gmail.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
	<7544228.v4QPX4F7J7@vostro.rjw.lan>
	<1456495897.13244.144.camel@linux.intel.com>
	<1460047286.6620.26.camel@linux.intel.com>
	<877fg828lr.fsf@yhuang-dev.intel.com>
	<1460109638.6620.41.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460109638.6620.41.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-efi-u79uwXL29TbrhsbdSgBK9A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 8, 2016 at 6:00 PM, Andy Shevchenko
<andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Fri, 2016-04-08 at 09:27 +0800, Huang, Ying wrote:
>> Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> writes:
>>
>> >
>> > On Fri, 2016-02-26 at 16:11 +0200, Andy Shevchenko wrote:
>> > >
>> > > On Thu, 2016-02-18 at 01:03 +0100, Rafael J. Wysocki wrote:
>> > > >
>> > > >
>> > > > On Wednesday, February 17, 2016 02:17:24 PM Andy Shevchenko
>> > > > wrote:
>> > > > >
>> > > > >
>> > > > > Switch to use a generic UUID API instead of custom approach.
>> > > > > It
>> > > > > allows to
>> > > > > define UUIDs, compare them, and validate.
>> > > []
>> > >
>> > Summon initial author of the UUID library.
>> >
>> > Summary: the API of comparison functions is rather strange. What the
>> > point to not take pointers directly? (Moreover I hope compiler too
>> > clever not to make a copy of constant arguments there)
>> >
>> > I could only imagine the case you are trying to avoid temporary
>> > variables for constants like NULL_UUID.
>> >
>> > Issue with this is the ugliness in the users of that, in
>> > particularly
>> > present in ACPI (drivers/acpi/apei/ghes.c).
>> >
>> > I would like to have more clear interface for that. Perhaps we may
>> > add
>> > something like
>> >
>> > cmp_p(pointer, non-pointer);
>> > cmp_pp(pointer, pointer);
>> >
>> > to not break existing API for now.
>> >
>> > It would be useful for many cases in the kernel.
>> You can take a look at the drivers/acpi/apei/erst.c for uuid_le_cmp
>> usage.
>>
>> #define
>> CPER_CREATOR_PSTORE                                             \
>>         UUID_LE(0x75a574e3, 0x5052, 0x4b29, 0x8a, 0x8e, 0xbe,
>> 0x2c,     \
>>                 0x64, 0x90, 0xb8, 0x9d)
>>
>>         if (uuid_le_cmp(rcd->hdr.creator_id, CPER_CREATOR_PSTORE) !=
>> 0)
>>                 goto skip;
>>
>> Looks better?
>
> I don't quite understand the issues with
>
> if (uuid_le_cmp(&rcd->hdr.creator_id, &CPER_CREATOR_PSTORE) != 0)

I tried to make uuid_le looks like a primitive data type and UUID
constant looks like primitive type constants if possible.  If we can
define data as uuid_le/be, then it will look just like that.  But if
there are too many places we cannot use uuid_le/be directly, I am OK
to convert the interface to use pointer instead.

> or, like I mentioned previously, we may introduce _cmp_p() and use like
>
> if (uuid_le_cmp_p(&rcd->hdr.creator_id, CPER_CREATOR_PSTORE) != 0)

Personally, I don't like this interface. It is better for two
parameters to have same data type.

> if it looks better (again, I don't know if compiler is going to copy the last argument).
>
>>
>> This is the typical use case in mind when I write the uuid.h.
>>
>> As for uuid_le_cmp usage in drivers/acpi/apei/ghes.c,
>>
>>               if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>>                                CPER_SEC_PLATFORM_MEM)) {
>
> Ditto
>
> if (!uuid_le_cmp_p((uuid_le *)gdata->section_type,
> CPER_SEC_PLATFORM_MEM)) {
>
>>
>> The code looks not good mainly because acpi_hest_generic_data is not
>> defined with uuid_le in mind.
>>
>> struct acpi_hest_generic_data {
>>       u8 section_type[16];
>>       u32 error_severity;
>>       u16 revision;
>>       u8 validation_bits;
>>       u8 flags;
>>       u32 error_data_length;
>>       u8 fru_id[16];
>>       u8 fru_text[20];
>> };
>>
>> If section_type was defined as uuid_le instead of u8[16], the
>> uuid_le_cmp usage would look better.  So I suggest to use uuid_le/be
>> in
>> data structure definition in new code if possible.
>
> This is understandable for such structures, but we might get a UUID from
> a buffer which is pointer to u8. It's not possible to convert to uuid_*
> since it's too generic stuff and might require to introduce
> ACPI_TYPE_UUID with standardization and all necessary work. Apparently
> not the shortest way.

If this is just a special case that happens seldom, we can just work
around it with *(uuid_le/be *)buf.  If it is common, we can change the
interface or add a new interface.

Best Regards,
Huang, YIng

>> >
>> > >
>> > > >
>> > > >
>> > > > >
>> > > > >
>> > > > > +static const uuid_le ads_uuid =
>> > > > > +     UUID_LE(0xdbb8e3e6, 0x5886, 0x4ba6,
>> > > > > +             0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96,
>> > > > > 0x6b);
>> > > > >
>> > > > >  static bool acpi_enumerate_nondev_subnodes(acpi_handle scope,
>> > > > >                                          const union
>> > > > > acpi_object
>> > > > > *desc,
>> > > > > @@ -138,7 +136,7 @@ static bool
>> > > > > acpi_enumerate_nondev_subnodes(acpi_handle scope,
>> > > > >                   || links->type != ACPI_TYPE_PACKAGE)
>> > > > >                       break;
>> > > > >
>> > > > > -             if (memcmp(uuid->buffer.pointer, ads_uuid,
>> > > > > sizeof(ads_uuid)))
>> > > > > +             if (uuid_le_cmp(*(uuid_le *)uuid-
>> > > > > >buffer.pointer,
>> > > > > ads_uuid))
>> > > > Maybe it's too late, but I don't quite understand the pointer
>> > > > manipulations here.
>> > > >
>> > > > I can see why you need a type conversion (although it looks
>> > > > ugly),
>> > > > but why do you
>> > > > need to dereference it too?
>> > > The function takes that kind of type on input. The other variants
>> > > are
>> > > not compiled.
>> > > Perhaps we better change uuid_{lb}e_cmp() first to take normal
>> > > pointers, though I think the initial idea was to get type checking
>> > > at
>> > > compile time.
>> > >
>
> --
> Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Intel Finland Oy
>
