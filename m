From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v7] Add udmabuf misc device
Date: Tue, 11 Sep 2018 14:03:50 +0200
Message-ID: <20180911120350.qtacdf2otwzuywv2@sirius.home.kraxel.org>
References: <20180827093444.23623-1-kraxel@redhat.com>
 <21053714.0Xa7F2u2PE@avalon>
 <20180911065014.vo6qp6hkb7cjftdc@sirius.home.kraxel.org>
 <18750721.r4B5nx0M26@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18750721.r4B5nx0M26@avalon>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>, Shuah Khan <shuah@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:DMA BUFFER SHARING FRAMEWORK" <linux-media@vger.kernel.org>, "moderated list:DMA BUFFER SHARING FRAMEWORK" <linaro-mm-sig@lists.linaro.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> > >> +	if (WARN_ON(vmf->pgoff >= ubuf->pagecount))
> > >> +		return VM_FAULT_SIGBUS;
> > > 
> > > Just curious, when do you expect this to happen ?
> > 
> > It should not.  If it actually happens it would be a bug somewhere,
> > thats why the WARN_ON.
> 
> But you seem to consider that this condition that should never happen still 
> has a high enough chance of happening that it's worth a WARN_ON(). I was 
> wondering why this one in particular, and not other conditions that also can't 
> happen and are not checked through the code. 

Added it while writing the code, to get any coding mistake I make
flagged right away instead of things exploding later on.

I can drop it.

> > >> +	ubuf = kzalloc(sizeof(struct udmabuf), GFP_KERNEL);
> > > 
> > > sizeof(*ubuf)
> > 
> > Why?  Should not make a difference ...
> 
> Because the day we replace
> 
> 	struct udmabuf *ubuf;
> 
> with
> 
> 	struct udmabuf_ext *ubuf;
> 
> and forget to change the next line, we'll introduce a bug. That's why 
> sizeof(variable) is preferred over sizeof(type). Another reason is that I can 
> easily see that
> 
> 	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
> 
> is correct, while using sizeof(type) requires me to go and look up the 
> declaration of the variable.

So it simplifies review, ok, will change it.

BTW: Maybe the kernel should pick up a neat trick from glib:

g_new0() is a macro which takes the type instead of the size as first
argument, and it casts the return value to that type.  So the compiler
will throw warnings in case of a mismatch.  That'll work better than
depending purely on the coder being careful and review catching the
remaining issues.

cheers,
  Gerd
