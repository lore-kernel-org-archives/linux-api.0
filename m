From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Thu, 12 Nov 2015 10:16:10 +0100
Message-ID: <20151112091610.GJ4431@pathway.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-4-git-send-email-jeyu@redhat.com>
 <20151111152256.GP2599@pathway.suse.cz>
 <20151111182718.GA30025@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151111182718.GA30025-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2015-11-11 13:27:18, Jessica Yu wrote:
> Basically, the patch module code is expected to build the reloc_secs
> list for each object that is being patched. For example in kpatch, the
> patch module generates this list in patch_init(). Like you guessed, it
> does go through all the elf sections of the patch module to find the
> reloc sections marked SHF_RELA_LIVEPATCH. We are able to access these
> sections through module->info, which is set up for livepatch modules
> before the module loader calls do_init_module() (and hence before
> patch_init(), See patch 2/5).
> See below for an example of how the reloc_secs list might be built: https://github.com/flaming-toast/kpatch/blob/no_dynrela_redux/kmod/patch/livepatch-patch-hook.c#L213

Thanks a lot for the link and explanation. I think that it would be nice to
incorporate this into the patchset. I would put it into a separate
function, e.g. klp_reloc_secs_init(). It can be called either from
klp_register_patch() or from klp_init_patch().

> Once the patch module has built this list, it is good to go for use in
> livepatch core. All livepatch has to do then is to iterate though the
> list, resolve any outstanding symbols, and call apply_relocate_add(),
> as shown in this patch.
>
> Miroslav mentioned in another email that we should start thinking
> about including documentation about this, including the expected patch
> module format. So perhaps v2 should include some documentation about
> this whole process somewhere.

That would be cool.

Thank you,
Petr
