From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Wed, 6 Dec 2017 09:29:34 -0600
Message-ID: <CANk1AXRFfV9dL+82RcdwRtwTwE9jdE5erZ8q8MUud4z_k6Fn=g@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com> <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
 <20171128031519.GA25705@hao-dev> <CANk1AXRBEcz5_j+v0oTAXfH10hrPbHGabdR8Pqt07exYxYgfCw@mail.gmail.com>
 <20171205033330.GA19730@hao-dev> <CANk1AXRdU6usqtsCUjjSC8Fk2SS8iKn+Ow4PvCiRpSBAcDwWjw@mail.gmail.com>
 <20171206053015.GA19023@hao-dev> <e73f5bc9bfc54efcb7b7c43c66379452@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e73f5bc9bfc54efcb7b7c43c66379452-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 6, 2017 at 3:44 AM, David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org> wrote:
> From: Wu Hao
>> Sent: 06 December 2017 05:30
> ...
>> > Regarding file names, it seems like the files added to drivers/fpga
>> > could be uniformly named dfl-*.[ch].  Some are fpga-dfl-*.[ch] while
>> > other are currently dfl-*.[ch] currently.
>
> They don't even want to do into a drivers/fgpa directory.
> Maybe drivers/dfl or drivers/dfl/intel

It's plugged into the fpga framework in drivers/fpga.  This patchset
also handles reprogramming the fpga, not just the dfl style
enumeration.  But your points about this being not just for FPGA are
interesting to me.  Do you have a use for this that isn't
FPGA-centric?

Alan

>
>         David
>
