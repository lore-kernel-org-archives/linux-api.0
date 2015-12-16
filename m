From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: s390: keep mod_arch_specific for livepatch modules
Date: Wed, 16 Dec 2015 18:48:28 -0500
Message-ID: <20151216234828.GB29092@packer-debian-8-amd64.digitalocean.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-4-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1512161257170.25787@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1512161257170.25787-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Miroslav Benes [16/12/15 13:02 +0100]:
>On Mon, 30 Nov 2015, Jessica Yu wrote:
>
>> Livepatch needs to utilize the symbol information contained in the
>> mod_arch_specific struct in order to be able to call the s390
>> apply_relocate_add() function to apply relocations. Remove the redundant
>> vfree() in module_finalize() since module_arch_freeing_init() (which also frees
>> said structures) is called in do_init_module(). Keep a reference to syminfo if
>> the module is a livepatch module and free the structures in
>> module_arch_cleanup(). If the module isn't a livepatch module, we free the
>> structures in module_arch_freeing_init() as usual.
>>
>> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  arch/s390/kernel/module.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
>> index 0c1a679..17a1979 100644
>> --- a/arch/s390/kernel/module.c
>> +++ b/arch/s390/kernel/module.c
>> @@ -51,6 +51,9 @@ void *module_alloc(unsigned long size)
>>
>>  void module_arch_freeing_init(struct module *mod)
>>  {
>> +	if (mod->klp)
>> +		return;
>> +
>>  	vfree(mod->arch.syminfo);
>>  	mod->arch.syminfo = NULL;
>>  }
>
>Hm, this is problematic. module_arch_freeing_init() is called from
>module_deallocate() and this is called in the error path in load_module().
>So if there was an error during load_module() of livepatch module which
>led to free_modinfo label or behind mod->arch.syminfo would not be freed
>at all. module_arch_cleanup() is called earlier under
>free_arch_cleanup.

Gah. Good catch. How about we add an additional check to see if
mod->state is MODULE_STATE_LIVE? If so, we can return. This means
we're coming from do_init_module(). If module_arch_freeing_init() was
called and the module was in a state other than MODULE_STATE_LIVE
(UNFORMED, GOING, COMING), we know we need to free. Think that would
work?

Jessica
