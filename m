From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/21] docs: fpga: add a document for Intel FPGA
 driver overview
Date: Thu, 21 Dec 2017 14:02:27 +0800
Message-ID: <20171221060227.GA4861@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-2-git-send-email-hao.wu@intel.com>
 <CANk1AXTLBWXGUozXJdKRThJwLiHJ==B--DkkE+YRjveA2YvifQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXTLBWXGUozXJdKRThJwLiHJ==B--DkkE+YRjveA2YvifQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 20, 2017 at 04:31:15PM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > +
> > +PORT
> > +====
> > +A port represents the interface between the static FPGA fabric (the "blue
> > +bitstream") and a partially reconfigurable region containing an AFU (the "green
> > +bitstream"). It controls the communication from SW to the accelerator and
> > +exposes features such as reset and debug.
> 
> Hi Hao,
> 
> If I remember correctly, reset means that the accelerator gets reset
> and this is something that is desirable to do between jobs.  I've
> asked for some documentation about the port reset function, partly
> because the idea of being able to reset hardware from userspace
> somehow scares me.  So please find a good logical place to explain
> what a port reset does and how it is safe for userspace to request it
> at some arbitrary time and how it won't crash the kernel.  We
> discussed this in v2, I grepped v3 for it, maybe I missed it, but I
> don't see it in v3.  My understanding is that disabling and reenabling
> the port bridge causes the accelerator in its FPGA region to get
> reset.

Hi Alan

Yes, that's correct.

Some descriptions are added in Patch#18[1] when introduced the reset ioctl.
I will add some descriptions in the doc as well.

[1]https://marc.info/?l=linux-fpga&m=151176566714744&w=2

@@ -50,6 +53,20 @@
 
 #define FPGA_CHECK_EXTENSION	_IO(FPGA_MAGIC, FPGA_BASE + 1)
 
+/* IOCTLs for AFU file descriptor */
+
+/**
+ * FPGA_PORT_RESET - _IO(FPGA_MAGIC, PORT_BASE + 0)
+ *
+ * Reset the FPGA Port and its AFU. No parameters are supported.
+ * Userspace can do Port reset at any time, e.g during DMA or PR. But
+ * it should never cause any system level issue, only functional failure
+ * (e.g DMA or PR operation failure) and be recoverable from the failure.
+ * Return: 0 on success, -errno of failure
+ */
+
+#define FPGA_PORT_RESET		_IO(FPGA_MAGIC, PORT_BASE + 0)
+

Thanks
Hao

> 
> Alan
> 
> > +
> > +A PCIe device may have several ports and each port can be released from PF by
> > +FPGA_FME_PORT_RELEASE ioctl on FME, and exposed through a VF via PCIe sriov
> > +sysfs interface.
> > +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
