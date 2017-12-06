From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Wed, 6 Dec 2017 16:39:32 -0600
Message-ID: <CANk1AXTwERaK52p+gbLGx-JxK0g9hq2oYwbJNzbJNbHp6X03Jw@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com> <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
 <20171128031519.GA25705@hao-dev> <CANk1AXRBEcz5_j+v0oTAXfH10hrPbHGabdR8Pqt07exYxYgfCw@mail.gmail.com>
 <20171205033330.GA19730@hao-dev> <CANk1AXRdU6usqtsCUjjSC8Fk2SS8iKn+Ow4PvCiRpSBAcDwWjw@mail.gmail.com>
 <20171206053015.GA19023@hao-dev> <e73f5bc9bfc54efcb7b7c43c66379452@AcuMS.aculab.com>
 <CANk1AXRFfV9dL+82RcdwRtwTwE9jdE5erZ8q8MUud4z_k6Fn=g@mail.gmail.com> <e2b9d86fda904f709158c018a099e19d@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e2b9d86fda904f709158c018a099e19d@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: Wu Hao <hao.wu@intel.com>, "mdf@kernel.org" <mdf@kernel.org>, "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "luwei.kang@intel.com" <luwei.kang@intel.com>, "yi.z.zhang@intel.com" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 6, 2017 at 10:28 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Alan Tull
>> Sent: 06 December 2017 15:30
>> On Wed, Dec 6, 2017 at 3:44 AM, David Laight <David.Laight@aculab.com> wrote:
>> > From: Wu Hao
>> >> Sent: 06 December 2017 05:30
>> > ...
>> >> > Regarding file names, it seems like the files added to drivers/fpga
>> >> > could be uniformly named dfl-*.[ch].  Some are fpga-dfl-*.[ch] while
>> >> > other are currently dfl-*.[ch] currently.
>> >
>> > They don't even want to do into a drivers/fgpa directory.
>> > Maybe drivers/dfl or drivers/dfl/intel
>>
>> It's plugged into the fpga framework in drivers/fpga.  This patchset
>> also handles reprogramming the fpga, not just the dfl style
>> enumeration.  But your points about this being not just for FPGA are
>> interesting to me.  Do you have a use for this that isn't
>> FPGA-centric?
>
> That all just seems wrong to me.
> If you've managed to invent some common code for reprogramming fpga
> I'd have though it would be library functions.

Why don't you familiarize yourself with the fpga framework before
commenting on it? ;)

>
> The driver ought to sit somewhere related to its functionality.
>
> Our fpga loads from a serial EEPROM, the image is about 6.5MB.
> We can rewrite it from userspace by mmap()ing part of one of the BARs
> to access some very locally written (by me) VHDL that does most of
> the required bit-banging for 32it word accesses.

The fpga framework is intended to handle cases where the it is desired
to reprogram the fpga a lot without having to reboot.  It doesn't
sound like that is your use case.

> You really wouldn't want to load 6.5MB into kernel space!

No, and there have been proposals, shot down so far regarding
streaming firmware images a page at a time.

>
> We also had to solve the problem of 9 separate driver modules that
> want to access different parts of the BARs.
> I think we have 46 separate slaves in the fpgas BARs (most are in 1 BAR).
> Some of these are common between different boards (or completely different
> memory maps for the same board.
>
> I can imagine some generic method of having a 'board' driver for a
> specific PCI-id that knows the BAR offsets of various functions so that
> other sub-drivers could be loaded to access those functions.
> But that is some kind of pseudo-bus not fpga specific in any way.
>
>         David
>
