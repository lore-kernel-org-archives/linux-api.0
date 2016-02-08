From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Mon, 8 Feb 2016 15:34:42 -0500
Message-ID: <20160208203441.GB27290@packer-debian-8-amd64.digitalocean.com>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <1454548271-24923-3-git-send-email-jeyu@redhat.com>
 <20160208201039.GC23106@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160208201039.GC23106-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [08/02/16 14:10 -0600]:
>On Wed, Feb 03, 2016 at 08:11:07PM -0500, Jessica Yu wrote:
>> For livepatch modules, copy Elf section, symbol, and string information
>> from the load_info struct in the module loader. Persist copies of the
>> original symbol table and string table.
>>
>> Livepatch manages its own relocation sections in order to reuse module
>> loader code to write relocations. Livepatch modules must preserve Elf
>> information such as section indices in order to apply livepatch relocation
>> sections using the module loader's apply_relocate_add() function.
>>
>> In order to apply livepatch relocation sections, livepatch modules must
>> keep a complete copy of their original symbol table in memory. Normally, a
>> stripped down copy of a module's symbol table (containing only "core"
>> symbols) is made available through module->core_symtab. But for livepatch
>> modules, the symbol table copied into memory on module load must be exactly
>> the same as the symbol table produced when the patch module was compiled.
>> This is because the relocations in each livepatch relocation section refer
>> to their respective symbols with their symbol indices, and the original
>> symbol indices (and thus the symtab ordering) must be preserved in order
>> for apply_relocate_add() to find the right symbol.
>
>This patch didn't apply clean to linux-next/master.  I didn't
>investigate why, but maybe it depends on the other patch set which
>removes the notifiers?  (If so, that should be mentioned in the cover
>letter.)

A very recent commit (8244062ef) introduced some changes
kernel/module.c that intersect with this patch, so I think this is why
the patch didn't apply cleanly to today's tree...Anyhow I will rebase
again before sending out v5. Thanks for the comments :-)

Jessica
