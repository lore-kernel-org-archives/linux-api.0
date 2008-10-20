From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Document kernel taint flags properly
Date: Mon, 20 Oct 2008 14:37:52 -0700
Message-ID: <48FCFA30.9000707@xenotime.net>
References: <20081017225515.GA14133@kroah.com> <cfd18e0f0810180151v232f623pdbf0f12cad6532d6@mail.gmail.com> <20081020204318.GB21131@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756080AbYJTVi6@vger.kernel.org>
In-Reply-To: <20081020204318.GB21131@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Greg KH wrote:
> On Sat, Oct 18, 2008 at 03:51:11AM -0500, Michael Kerrisk wrote:
>   
>> Greg,
>>
>> Small corrections below.
>>
>> On Fri, Oct 17, 2008 at 5:55 PM, Greg KH <greg@kroah.com> wrote:
>>     
>>> From: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> This fills in the documentation for all of the current kernel taint
>>> flags, and fixes the number for TAINT_CRAP, which was incorrectly
>>> described.
>>>
>>> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
>>> Cc: Randy Dunlap <rdunlap@xenotime.net>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> ---
>>>  Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
>>>  1 file changed, 17 insertions(+), 7 deletions(-)
>>>
>>> --- a/Documentation/sysctl/kernel.txt
>>> +++ b/Documentation/sysctl/kernel.txt
>>> @@ -363,11 +363,21 @@ tainted:
>>>  Non-zero if the kernel has been tainted.  Numeric values, which
>>>  can be ORed together:
>>>
>>> -  1 - A module with a non-GPL license has been loaded, this
>>> -      includes modules with no license.
>>> -      Set by modutils >= 2.4.9 and module-init-tools.
>>> -  2 - A module was force loaded by insmod -f.
>>> -      Set by modutils >= 2.4.9 and module-init-tools.
>>> -  4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
>>> - 64 - A module from drivers/staging was loaded.
>>> +   1 - A module with a non-GPL license has been loaded, this
>>> +       includes modules with no license.
>>> +       Set by modutils >= 2.4.9 and module-init-tools.
>>> +   2 - A module was force loaded by insmod -f.
>>> +       Set by modutils >= 2.4.9 and module-init-tools.
>>> +   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
>>> +   8 - A module was forcefully unloaded from the system by rmmod -f.
>>>       
>> s/forcefully/forcibly/
>>
>>     
>>> +  16 - A hardware machine check error occured on the system.
>>>       
>> occurred
>>     
>
> Thanks, I've updated this in my version.
>
> Randy, I can send this through my tree, is that ok?  Or do you want it
> to go through yours?
>   
You please go ahead with it.

Thanks,
~Randy
