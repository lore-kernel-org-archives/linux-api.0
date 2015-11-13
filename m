From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Fri, 13 Nov 2015 02:15:54 -0500
Message-ID: <20151113071553.GE13513@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-4-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1511111519250.12467@pobox.suse.cz>
 <20151111200732.GB30025@packer-debian-8-amd64.digitalocean.com>
 <alpine.LNX.2.00.1511121601370.9440@pobox.suse.cz>
 <20151112174032.GG4038@treble.hsd1.ky.comcast.net>
 <20151112202243.GC5841@packer-debian-8-amd64.digitalocean.com>
 <20151112203221.GM4038@treble.hsd1.ky.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151112203221.GM4038-M1RQNqTfbHcHO9+bouH2LOBSVt8DKT+lrE5yTffgRl4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [12/11/15 14:32 -0600]:
>On Thu, Nov 12, 2015 at 03:22:44PM -0500, Jessica Yu wrote:
>> Looking into this more, I think we do need one __klp_rela section per
>> function being patched.  Each rela section is linked to the section to
>> which the relocations apply via the rela section's sh_info field. In
>> SHT_RELA sections, the sh_info field contains the section index to
>> which the relocs apply. We cannot have one single combined rela
>> section per object as the call to apply_relocate_add() simply won't
>> work, because we would have relocs that apply to different functions
>> (and hence different sections).
>>
>> So I guess instead of a single field in klp_object specifying the
>> __klp_rela section index, we could probably just have an array of
>> section indices.
>
>Ok, makes sense, sounds like we need multiple klp relas per object.
>
>I still don't quite understand the benefit of caching the klp_rela
>section indices.  What problem does it solve?  It seems simpler to just
>iterate over all the sections in klp_write_object_relocations().

I was trying to accomodate Miroslav's dislike of klp_reloc_sec :-)
But now that we are sure that we need multiple __klp_rela sections
per object, I think an array of indices might still be somewhat
complicated (we need to figure out its size and everything, a list
here would be easier). I think it might be fine to leave things the
way they are here.

Jessica
