From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/22] docs: fpga: add a document for Intel FPGA driver overview
Date: Tue, 18 Jul 2017 09:32:39 -0500
Message-ID: <CANk1AXRB4OzouKPRh2n-HfhrGGUUCh2w2BM8Zz81ZwCGU+8KCw@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-2-git-send-email-hao.wu@intel.com> <CANk1AXTDVVRG05H9kwZujFYGGS=AjQ2cdfrBm=bRNz9S7p6R6w@mail.gmail.com>
 <20170713042520.GC28569@hao-dev> <20170714235914.GA17169@eluebber-mac02.jf.intel.com>
 <CANk1AXTLhbczboA=wCYGUhnJyyYfvmUqUpk490sk34eh-MU5Ew@mail.gmail.com> <20170718052228.GA10631@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170718052228.GA10631-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "Luebbers, Enno" <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 18, 2017 at 12:22 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Jul 17, 2017 at 03:14:29PM -0500, Alan Tull wrote:
>> > Also, we're thinking that some operations require that you first "acquire
>> > ownership" of the respective device, which I believe maps more easily to
>> > open() and ioctls than sysfs.
>> >
>> > Thanks
>> > - Enno
>>
>> Yes, sysfs doesn't implement open/close so there's no clean way to
>> have one thing in userspace that owns the interface.  It's a shame.
>
> No, that was by design :)

Well that's good to know!  linux-api is copied on this patchset.  I'm
wondering if there is another mailing list that can weigh in on this
new ioctl that is being added to the kernel or if that's the one.

Alan Tull
