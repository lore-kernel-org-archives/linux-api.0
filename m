From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Wed, 13 Jan 2016 13:39:25 -0500
Message-ID: <20160113183924.GA980@packer-debian-8-amd64.digitalocean.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
 <1452281304-28618-5-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1601131012340.10011@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1601131012340.10011-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Miroslav Benes [13/01/16 10:19 +0100]:
>On Fri, 8 Jan 2016, Jessica Yu wrote:
>
>>  static int klp_write_object_relocations(struct module *pmod,
>>  					struct klp_object *obj)
>>  {
>> -	int ret = 0;
>> -	unsigned long val;
>> -	struct klp_reloc *reloc;
>> +	int i, len, ret = 0;
>> +	char *secname;
>> +	const char *objname;
>>
>>  	if (WARN_ON(!klp_is_object_loaded(obj)))
>>  		return -EINVAL;
>>
>> -	if (WARN_ON(!obj->relocs))
>> -		return -EINVAL;
>> +	objname = klp_is_module(obj) ? obj->name : "vmlinux";
>>
>>  	module_disable_ro(pmod);
>> +	/* For each klp rela section for this object */
>> +	for (i = 1; i < pmod->info->hdr->e_shnum; i++) {
>> +		if (!(pmod->info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH))
>> +			continue;
>
>One more thing. If the module does not specify it is a live patch module
>in modinfo (with MODULE_INFO(livepatch, "Y")), but it is a perfect live
>patch module otherwise (it calls klp_register_patch in its init function),
>the kernel crashes here. pmod->info is not initialized at all. This should
>be fixed. Perhaps the easiest would be to call
>klp_write_object_relocations() in klp_init_object_loaded() only if
>is_livepatch_module() returns true. Similar to a check for obj->relocs
>before.

Hm yes, that's a problem. To remedy this, I think it makes sense to
require all livepatch modules to identify themselves with the modinfo
attribute, since it is a very simple requirement. If some module calls
klp_register_patch() and it does not have the livepatch attribute,
klp_register_patch() can just return an error. We can call
is_livepatch_module() at the beginning of klp_register_patch(), and
proceed only if the check succeeds, since we'll then know that the
required structures have been properly initialized in the module
loader. What do you think?

Jessica
