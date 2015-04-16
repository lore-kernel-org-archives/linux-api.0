From: Roy Franz <roy.franz@linaro.org>
Subject: Re: [Patch 2/3] firmware: dmi_scan: add SBMIOS entry and DMI tables
Date: Thu, 16 Apr 2015 10:08:28 -0700
Message-ID: <CAFECyb_N1iMqqp_MNR+chvW1uGPDWtCqv3QrPFnVndd7u6pXXQ@mail.gmail.com>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1427979423-22767-3-git-send-email-ivan.khoronzhuk@globallogic.com>
	<551E5F0B.6050709@globallogic.com>
	<CAFECyb_BGU82vCi0jOz+MbdsxRS-jFoHNsZe5KdOCgpt0K7y+A@mail.gmail.com>
	<CAFECyb9RFAEWMOFCDcKKYBgQk85HoDiG2yfyou6X9qm=Wq5+Pg@mail.gmail.com>
	<20150416084808.424385e0@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150416084808.424385e0@endymion.delvare>
Sender: linux-doc-owner@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: "Ivan.khoronzhuk" <ivan.khoronzhuk@globallogic.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Grant Likely <grant.likely@linaro.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Mike Waychison <mikew@google.com>, dmidecode-devel@nongnu.org, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 15, 2015 at 11:48 PM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Roy,
>
> On Wed, 15 Apr 2015 17:54:51 -0700, Roy Franz wrote:
>> On Tue, Apr 14, 2015 at 9:19 PM, Roy Franz <roy.franz@linaro.org> wrote:
>> > I have made modifications to dmidecode to support this interface, and it
>> > works quite nicely for dmidecode. (changes posted to dmidecode-devel list)
>> > The only open issue I am aware of is how the SMBIOS v3 entry point
>> > will be handled,
>> > especially in cases where there is a v2 and a v3 entry point.
>> > In principal I think this a good change - are there any other open issues?
>>
>> I looked at the SMBIOS spec again, and the platform can provide either or
>> both of the 32-bit and 64-bit entry points.  The spec says that an
>> implementation
>> "should" provide a 32-bit entry point for compatibility.
>>
>> These 2 entry point structures can both point to the same SMBIOS
>> structure table,
>> or two distinct ones.  If distinct, the one referenced by the 32-bit
>> entry point must be
>> a consistent subset of the 64-bit one.
>> There does not seem to be any prohibition from using new SMBIOS v3 structures
>> in a table referenced by a 32-bit entry point, so backwards
>> compatibility is completely
>> up to the implementation.
>
> What do you mean with "new SMBIOS v3 structures"? I took a brief look
> at the change log at the end of the SMBIOS 3.0.0 specification, and all
> I can see are new enumerated values for existing fields, as well as 3
> new fields in the type 4 structure. I can't see any new structure type.
> Either way this is all backwards compatible, which is why both entry
> points can point to the same table.
Sorry, I used that imprecisely - I was referring to the new things defined
in the 3.0 specification in addition to the new entry point.  It sounds like
there is not much.
>
>> Since the point of this patchset (and related changes to dmidecode) is
>> to provide the
>> SMBIOS information without using /dev/mem, I think the interface we
>> define should
>> support all the cases outlined in the specification.  I would like to
>> avoid a case where
>> we're back to using /dev/mem to deal with the dual entry/dual table
>> case if that becomes
>> important down the road.
>>
>> Here's a proposal for files in /sys/firmware/dmi/tables:
>>
>> smbios_entry_point32   -  32 bit (existing entry point type), if it exists.
>> smbios_entry_point64   -  64 bit entry, new in SMBIOS v3.0
>> DMI32                         -  smbios structure tables referenced by
>> 32 bit entry point, if it exists
>> DMI64                         -  smbios structure tables referenced by
>> 64 bit entry point, if it exists.
>>                                      symlink to DMI32 if identical
>> smbios_entry_point    - symlink to smbios_entry_point64 if it exists,
>> otherwise symlink to smbios_entry_point64
>> DMI                           - symlink to DMI64 if it exists,
>> otherwise symlink to DMI32
>>
>> These last two would provide names to the 'preferred' tables, and
>> names that would always exist on all systems, which
>> I think is a nice property to have.
>>
>> Thoughts?
>
> The idea was discussed before, and discarded. The question is, what use
> cases do you envision from a user-space application perspective? As you
> found out, the table pointed to by the _SM3_ entry point must be a
> super-set of the one pointed to by the _SM_ entry point, so for a
> compliant implementation there is no reason to follow the _SM_ entry
> point when both exist. And if only one entry point exists, there is
> nothing to choose from.
>
> The kernel itself will have to choose one of the entry points when it
> comes to dmi_scan and dmi-id. It can't provide two sets of DMI strings.
> So it seems reasonable to only expose though sysfs that one entry point
> and table that the kernel itself used.
>
> The only case where it would make some sense to expose everything to
> user-space is for BIOS debugging purpose: if both entry points exist
> and point to different tables, and if the _SM3_ table is broken and
> the _SM_ table is correct, then you may want to be able to temporarily
> read the _SM_ table instead of the _SM3_ table, to check what needs to
> be fixed in the latter. But I would argue that this is beyond the scope
> of our code: neither the kernel nor dmidecode are DMI table or BIOS
> authoring tools.
>
> If there really ever is a need to ignore the _SM3_ entry point, I'd
> rather have a kernel boot parameter for this. This would guarantee that
> the kernel and user-space applications always operate on the same data.
>
> So I would keep the sysfs interface simple, as Ivan implemented it.

Apologies for missing that previous discussion - I was intentionally
bringing an old topic up.
I don't feel strongly, and I think the main use case is debugging
something in the future,
as it doesn't address any current problems. My main motivation for
proposing this was to
avoid a future case where the answer is "just map /dev/mem".  This is
acceptable if the only
people doing it are developers debugging a BIOS/UEFI problem, but I
don't think this is the
right answer for general use case.  If a general use case emerges in
the future that requires
both tables exposed, we can extend the sysfs interface then (and this
may well never happen.)

Thanks,
Roy


>
> --
> Jean Delvare
> SUSE L3 Support
