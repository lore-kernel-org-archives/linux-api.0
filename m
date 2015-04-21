From: "Ivan.khoronzhuk" <ivan.khoronzhuk@globallogic.com>
Subject: Re: [Patch v2 2/3] firmware: dmi_scan: add SBMIOS entry and DMI tables
Date: Tue, 21 Apr 2015 18:26:07 +0300
Message-ID: <55366C0F.6020803@globallogic.com>
References: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>	<1429525187-3376-3-git-send-email-ivan.khoronzhuk@globallogic.com> <20150421162427.21c358a5@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150421162427.21c358a5@endymion.delvare>
Sender: linux-doc-owner@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org
List-Id: linux-api@vger.kernel.org

Hi Jean,

On 21.04.15 17:24, Jean Delvare wrote:
> Hi Ivan,
>
> On Mon, 20 Apr 2015 13:19:46 +0300, Ivan Khoronzhuk wrote:
>> Some utils, like dmidecode and smbios, need to access SMBIOS entry
>> table area in order to get information like SMBIOS version, size, etc.
>> Currently it's done via /dev/mem. But for situation when /dev/mem
>> usage is disabled, the utils have to use dmi sysfs instead, which
>> doesn't represent SMBIOS entry and adds code/delay redundancy when direct
>> access for table is needed.
>>
>> So this patch creates dmi/tables and adds SMBIOS entry point to allow
>> utils in question to work correctly without /dev/mem. Also patch adds
>> raw dmi table to simplify dmi table processing in user space, as
>> proposed by Jean Delvare.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
>> ---
>>   .../ABI/testing/sysfs-firmware-dmi-tables          | 22 ++++++
>>   drivers/firmware/dmi-sysfs.c                       | 17 +++--
>>   drivers/firmware/dmi_scan.c                        | 82 ++++++++++++++++++++++
>>   include/linux/dmi.h                                |  2 +
>>   4 files changed, 114 insertions(+), 9 deletions(-)
>>   create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi-tables
>> (...)
>> +static int __init dmi_init(void)
>> +{
>> +	int ret;
>> +	u8 *dmi_table = NULL;
>> +	struct kobject *tables_kobj = NULL;
>> +
>> +	if (!dmi_available) {
>> +		ret = -ENODATA;
>> +		goto err;
>> +	}
>> +
>> +	/*
>> +	 * Set up dmi directory at /sys/firmware/dmi. This entry should stay
>> +	 * even after farther error, as it can be used by other modules like
>> +	 * dmi-sysfs.
>> +	 */
>> +	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
>> +	tables_kobj = kobject_create_and_add("tables", dmi_kobj);
> I'm afraid you can't do that. kobject_create_and_add() doesn't check if
> the parent is NULL and will happily create "tables" at the root of
> sysfs if for any reason the previous call to kobject_create_and_add()
> failed and returned NULL. I agree it is unlikely and would be cleaned
> up immediately, but still, instantiating an object at the wrong place,
> even temporarily, is wrong.
>
>> +	if (!(dmi_kobj && tables_kobj)) {
>> +		ret = -ENOMEM;
>> +		goto err;
>> +	}
> I'd rather go with:
>
> 	if (!(dmi_kobj = kobject_create_and_add("dmi", firmware_kobj))
> 	 || !(tables_kobj = kobject_create_and_add("tables", dmi_kobj))) {
>
> I know that checkpatch complains about this construct, but in many
> cases it is the right thing to do.
>
> Another possible approach is simply:
>
> 	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
> 	if (dmi_kobj)
> 		tables_kobj = kobject_create_and_add("tables", dmi_kobj);
> 	if (!tables_kobj) {
>
>> +
>> +	bin_attr_smbios_entry_point.size = smbios_entry_point_size;
>> +	bin_attr_smbios_entry_point.private = smbios_entry_point;
>> +	ret = sysfs_create_bin_file(tables_kobj, &bin_attr_smbios_entry_point);
>> +	if (ret)
>> +		goto err;
>> +
>> +	dmi_table = dmi_remap(dmi_base, dmi_len);
>> +	if (!dmi_table) {
>> +		ret = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	bin_attr_DMI.size = dmi_len;
>> +	bin_attr_DMI.private = dmi_table;
>> +	ret = sysfs_create_bin_file(tables_kobj, &bin_attr_DMI);
>> +	if (!ret)
>> +		return 0;
>> +
>> +err:
>> +	pr_err("dmi: Firmware registration failed.\n");
>> +
>> +	if (tables_kobj) {
>> +		sysfs_remove_bin_file(tables_kobj,
>> +				      &bin_attr_smbios_entry_point);
>> +		kobject_del(tables_kobj);
>> +		kobject_put(tables_kobj);
>> +	}
>> +
>> +	if (dmi_table)
>> +		dmi_unmap(dmi_table);
> I'm not happy with this single error label. This forces you to
> initialize all your pointers to NULL and then to check for them to find
> out what needs to be done in the error path. With multiple error labels,
> you would know exactly what needs to be done, this is more efficient.
>
>> +
>> +	return ret;
>> +}
> Everything else looks good. No need to resend, I'll fix up the above
> myself in place or as an incremental patch.
>
> Thanks,

Don't bother, I'll send corrected version.

-- 
Regards,
Ivan Khoronzhuk

