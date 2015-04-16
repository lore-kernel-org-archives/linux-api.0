From: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: Re: [Patch 2/3] firmware: dmi_scan: add SBMIOS entry and DMI tables
Date: Thu, 16 Apr 2015 20:32:43 +0300
Message-ID: <552FF23B.5080408@globallogic.com>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>	 <1427979423-22767-3-git-send-email-ivan.khoronzhuk@globallogic.com>	 <20150416115252.7dc964a3@endymion.delvare>	 <552FB18D.6080207@globallogic.com> <1429199064.4386.93.camel@chaos.site> <552FF0E4.709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FF0E4.709-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: subscivan <subscivan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Sorry, sent it from not original mail.

On 16.04.15 20:27, subscivan wrote:
> Jean,
>
> On 16.04.15 18:44, Jean Delvare wrote:
>> Hi Ivan,
>>
>> Le Thursday 16 April 2015 =C3=A0 15:56 +0300, Ivan.khoronzhuk a =C3=A9=
crit :
>>> On 16.04.15 12:52, Jean Delvare wrote:
>>>> On Thu,  2 Apr 2015 15:57:02 +0300, Ivan Khoronzhuk wrote:
>>>>> +static BIN_ATTR(smbios_entry_point, S_IRUSR, raw_table_read,=20
>>>>> NULL, 0);
>>>> This one could be world-readable as it contains no sensitive
>>>> information.
>>> It contains the address of DMI table containing sensitive informati=
on.
>>> Who knows which ways can be used to take it. Anyway, no see reasons=
=20
>>> in this
>>> w/o DMI table. But if you insist I can do it "world-readable".
>> OK, you convinced me.
>>
>>>>> +struct bin_attribute bin_attr_dmi_table =3D
>>>>> +            __BIN_ATTR(DMI, S_IRUSR, raw_table_read, NULL, 0);
>>>> I do not understand why you don't use BIN_ATTR here too? I tried=20
>>>> naming
>>>> the attribute bin_attr_DMI and it seems to work just fine, checkpa=
tch
>>>> doesn't even complain!
>>> I dislike upper case in names, at least in such simple names.
>>> It makes me using bin_attr_DMI lower in the code. That's why.
>>> But if you like it, I will name it "bin_attr_DMI"
>> I don't like upper case in names either, but in this specific case, =
I'd
>> do it for consistency. As you wish though, I really only wanted to k=
now
>> the reason.
>>
>>>>> +
>>>>> +static int __init dmi_init(void)
>>>>> +{
>>>>> +    int ret =3D -ENOMEM;
>>>>> +    struct kobject *tables_kobj =3D NULL;
>>>>> +
>>>>> +    if (!dmi_available) {
>>>>> +        ret =3D -ENOSYS;
>>>>> +        goto err;
>>>>> +    }
>>>> This is weird. Can this actually happen?
>>>>
>>>> We currently have two ways to enter this module: dmi_scan_machine(=
),
>>>> which is called by the architecture code, and dmi_init(), which is
>>>> called at subsys_initcall time. As far as I can see,
>>>> core/arch_initcalls are guaranteed to be always called before
>>>> subsys_initcalls. If we can rely on that, the test above is not=20
>>>> needed.
>>>> If for any reason we can't, that means that dmi_init() should not =
be a
>>>> subsys_initcall, but should instead be called explicitly at the en=
d of
>>>> dmi_scan_machine().
>>> We cannot be sure that firmware_kobj created at time of dmi_init().
>>> The sources don't oblige you to call it at core level,
>>> for instance like it was done for arm64. For x86, dmi_init() can be=
=20
>>> called
>>> before firmware_kobj is created.
>> Looking at the code, it seems that firmware_kobj is created very, ve=
ry
>> early in the boot process. In do_basic_setup(), you can see that
>> driver_init() (which in turn calls firmware_init(), creating
>> firmware_kobj) is called before do_initcalls(). So firmware_kobj mus=
t be
>> defined before dmi_scan_machine() or dmi_init() is called.
>
> No. Not must, rather should. See below.
>
>>
>> Oh, and this wasn't even my point ;-) I'm fine with you checking if
>> firmware_kobj is defined. My question was about the dmi_available ch=
eck
>> above. But that question was silly anyway, sorry. I confused
>> dmi_available with dmi_initialized. Checking for dmi_available is
>> perfectly reasonable, please scratch my objection.
>>
>>> And if I call it from dmi_init() I suppose
>>> I would face an error. As I can't call it in dmi_init I can't be=20
>>> sure that
>>> DMI is available at all. So, no, we have to check dmi_available her=
e=20
>>> and
>>> call it at subsys layer, where it's supposed to be.
>> I can't parse that, I suspect you wrote dmi_init where you actually
>> meant dmi_scan_machine? Given how early firmware_kobj is created, I
>> think the code currently in dmi_init could in fact go at the end of
>> dmi_scan_machine.
>
> Actually, dmi_scan_machine can be called even earlier.
> As I've sad, for x86, it's called before firmware_kobj is created.
>
> kernel_start()
>     setup_arch()
>         dmi_scan_machine()
>
> And for firmware_init(), as you noticed already:
>
> start_kernel()
>     rest_init()
>         kernel_init()
>             kernel_init_freeable()
>                 do_basic_setup()
>                     driver_init()
>                         firmware_init()
>
> Pay attentions that setup_arch() is called much earlier than rest_ini=
t().
> So dmi_init couldn't in fact go at the end of dmi_scan_machine.
>
>> But it's not important for the time being, this can be
>> attempted later.
>>
>>>>> (...)
>>>>> +    kobject_del(dmi_kobj);
>>>>> +    kobject_put(dmi_kobj);
>>>>> +    dmi_kobj =3D NULL;
>>>> I'm wondering, wouldn't it make sense to keep dmi_kobj alive (with=
 an
>>>> appropriate comment), so that dmi-sysfs has a chance to load? As i=
t is
>>>> now, a bug or some unexpected behavior in this new code could caus=
e a
>>>> regression for dmi-sysfs users. Just because I don't like dmi_sysf=
s
>>>> doesn't mean we can break it ;-)
>>> As I remember it was not so critical for you last time.
>>> "I don't care which way you choose". And I've explained my position=
=2E
>>> But it's not very hard to me to change it. Anyway patch requires=20
>>> re-push.
>> You're right, I did not remember we had discussed this already,
>> sorry :-(
>>
>> Well, I still agree that it doesn't really matter, but of two accept=
able
>> solutions for an event which will most likely never happen, why not =
go
>> for the ones with the fewer lines of code? ;-)
>
> Ok.

--=20
Regards,
Ivan Khoronzhuk
