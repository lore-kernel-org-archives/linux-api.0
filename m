From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: samples: livepatch: init reloc list and mark as klp module
Date: Tue, 10 Nov 2015 13:37:26 -0500
Message-ID: <20151110183725.GA22400@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-5-git-send-email-jeyu@redhat.com>
 <5641A7BA.8000100@suse.cz>
 <20151110135006.GB3163@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110135006.GB3163-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [10/11/15 07:50 -0600]:
>On Tue, Nov 10, 2015 at 09:15:54AM +0100, Jiri Slaby wrote:
>> On 11/10/2015, 05:45 AM, Jessica Yu wrote:
>> > Intialize the list of relocation sections in the sample
>> > klp_object (even if the list will be empty in this case).
>> > Also mark module as a livepatch module so that the module
>> > loader can appropriately initialize it.
>> >
>> > Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  samples/livepatch/livepatch-sample.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
>> > index fb8c861..2ef9345 100644
>> > --- a/samples/livepatch/livepatch-sample.c
>> > +++ b/samples/livepatch/livepatch-sample.c
>> > @@ -57,6 +57,7 @@ static struct klp_object objs[] = {
>> >  	{
>> >  		/* name being NULL means vmlinux */
>> >  		.funcs = funcs,
>> > +		.reloc_secs = LIST_HEAD_INIT(objs[0].reloc_secs)
>>
>> And I see now. This is not the best place for it though. I would put
>> INIT_LIST_HEAD in the core code instead.
>
>Maybe the reloc_secs list should instead be an array of klp_reloc_sec
>structs, with the last entry being 0, similar to how we do other "lists"
>in the klp interface (e.g., klp_patch.objs, klp_object.funcs).

Yeah, I admit the asymmetry is a bit awkward. Plus we can add in a
klp_for_each_reloc_sec to keep the api consistent. I'll go ahead and
change this to follow the existing klp "list" format.

Jessica
