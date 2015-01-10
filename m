From: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH] Documentation: Add entry for dell-laptop sysfs interface
Date: Sat, 10 Jan 2015 00:21:06 -0800
Message-ID: <CAN8TOE9gBzW3NMb_E29xs3hOmEyh-YbXY2SqKN9L=xBWpYrHZQ@mail.gmail.com>
References: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com>
	<20141231053149.GA3764@norris-Latitude-E6410>
	<1636595.UbTko9mUNA@xps13>
	<20150110065714.GB104814@vmdeb7>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <20150110065714.GB104814@vmdeb7>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, mjg59@srcf.ucam.org, linux-api@vger.kernel.org, platform-driver-x86@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com, pali.rohar@gmail.com, Aaron Sloman <A.Sloman@cs.bham.ac.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 9, 2015 at 10:57 PM, Darren Hart <dvhart@infradead.org> wrote:
> On Wed, Dec 31, 2014 at 12:20:59PM +0100, Gabriele Mazzotta wrote:
>> You are perfectly right, the documentation is wrong and I'm sorry for
>> that. als_setting should allow you to define when the keyboard
>> backlight has to be turned on or off depending on the value reported
>> by the ambient light sensor.
>>
>> Please note that not everything that is in libsmbios [1] is implemented
>> in the kernel driver. Take a look at it, recently there have been few
>> changes related to the ALS settings. Probably they are not needed given
>> that you are able to set the threshold with the current kernel driver,
>> but you might find something interesting.
>>
>> I'll submit a patch to correct the documentation, thanks for reporting.
>
> Have I missed a patch from you for this? I'd like to see this corrected in the
> 3.19 rc cycle.

https://lkml.org/lkml/2015/1/2/63
