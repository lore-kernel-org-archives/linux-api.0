From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Date: Mon, 18 Feb 2013 11:28:40 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1302181121460.17024@pobox.suse.cz>
References: <20130215112911.68A98E0085@blue.fi.intel.com> <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com> <20130215120022.GA23694@x220> <20130215135141.1EFCEE0085@blue.fi.intel.com> <20130215200526.GA15811@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <20130215200526.GA15811@core.coreip.homeip.net>
Sender: linux-input-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Johan Hedberg <johan.hedberg@gmail.com>, David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org, linux-input@vger.kernel.org, RavindranathX Doddi <ravindranathx.doddi@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
List-Id: linux-api@vger.kernel.org

On Fri, 15 Feb 2013, Dmitry Torokhov wrote:

> > Here's my attempt to fix the issue.
> > 
> > Not sure if tricks with padding in a good idea. We can  just use __u64
> > instead of pointer, but it will require update of userspace to silence
> > cast warning and will cause warning if you will try to use updated
> > userspace with old kernel headers.
> > 
> > Any comments?
> 
> This does not fix anything really, we simply have to deal with compat
> interface.
> 
> Compiled but not tested.
> 
> Thanks.

Sorry for late response, I have been extremely busy doing some skiing :-)

Thanks a lot for fixing this embarassing bug, Dmitry. I have now applied 
the patch.

-- 
Jiri Kosina
SUSE Labs
