From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH 4/5] samples: livepatch: init reloc list and mark as
 klp module
Date: Tue, 10 Nov 2015 07:50:06 -0600
Message-ID: <20151110135006.GB3163@treble.redhat.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-5-git-send-email-jeyu@redhat.com>
 <5641A7BA.8000100@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5641A7BA.8000100@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 10, 2015 at 09:15:54AM +0100, Jiri Slaby wrote:
> On 11/10/2015, 05:45 AM, Jessica Yu wrote:
> > Intialize the list of relocation sections in the sample
> > klp_object (even if the list will be empty in this case).
> > Also mark module as a livepatch module so that the module
> > loader can appropriately initialize it.
> > 
> > Signed-off-by: Jessica Yu <jeyu@redhat.com>
> > ---
> >  samples/livepatch/livepatch-sample.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
> > index fb8c861..2ef9345 100644
> > --- a/samples/livepatch/livepatch-sample.c
> > +++ b/samples/livepatch/livepatch-sample.c
> > @@ -57,6 +57,7 @@ static struct klp_object objs[] = {
> >  	{
> >  		/* name being NULL means vmlinux */
> >  		.funcs = funcs,
> > +		.reloc_secs = LIST_HEAD_INIT(objs[0].reloc_secs)
> 
> And I see now. This is not the best place for it though. I would put
> INIT_LIST_HEAD in the core code instead.

Maybe the reloc_secs list should instead be an array of klp_reloc_sec
structs, with the last entry being 0, similar to how we do other "lists"
in the klp interface (e.g., klp_patch.objs, klp_object.funcs).

-- 
Josh
