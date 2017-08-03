From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Thu, 3 Aug 2017 12:51:07 -0600
Message-ID: <a313d401-d18b-ed9a-d82d-f6e12f606743@osg.samsung.com>
References: <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
 <20170705112707.54d7f345@gandalf.local.home>
 <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net>
 <20170705130200.7c653f61@gandalf.local.home> <87zibkzgve.fsf@xmission.com>
 <fb399eba-91eb-21a5-e3f5-c3f919061c12@osg.samsung.com>
 <87lgn1nac8.fsf@xmission.com>
 <61093c3f-6ad0-c033-a524-f2624f8d55ba@osg.samsung.com>
 <87r2wtluc1.fsf@xmission.com>
 <92c31d6f-f98d-c764-eeec-bd0a2316d769@osg.samsung.com>
 <20170803030327.gf7pl7foer3abdpe@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803030327.gf7pl7foer3abdpe-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 08/02/2017 09:03 PM, Theodore Ts'o wrote:
> On Wed, Aug 02, 2017 at 12:42:04PM -0600, Shuah Khan wrote:
>>>>> $ make O=$PWD-build -j8 kselftests
>>>>> make[1]: Entering directory 'linux-build'
>>>>> make[1]: *** No rule to make target 'kselftests'.  Stop.
>>>>> make[1]: Leaving directory 'linux-build'
>>>>> Makefile:145: recipe for target 'sub-make' failed
>>>>> make: *** [sub-make] Error 2
>>
>> There are multiple ways to run selftests at the moment. If your
>> preferred use-case isn't supported, I don't see why it can't be
>> added.
> 
> There are many of us who use separate object directories so we can
> build the same kernel tree with multiple configurations.  So for
> example, my kernel sources will be on an SSD, but sometimes my /build
> directory will be on a HDD since storing the object files on an HDD
> don't really buy as much as keeping the sources on SSD.
> 
> For example, so I might be doing builds via: 
> 
> make O=/build/ext4 -j8
> 
>    and
> 
> make O=/build/ext4-32 ARCH=i386 -j8
> 
> Or someone might have a separate config file for doing debugging which
> is different from their production kernel, which they could do by
> having a different .config file in /build/ext4-debug/.config.
> 
>>>> It is "make kselftest"
>>>
>>> If I include the standard O= to keep my source tree pristine
>>> it still fails.  Which is a practical issue.  Especially because
>>> that "make kselftest" needs to be followed by I think "make mrproper"
>>> to get back to my normal development workflow.
>>
>> Hmm. not sure why you would need to run "make mrproper" after running
>> "make kselftest" - I never have to. I would like to understand why though
>> if you are seeing problems without running "make mrproper".
> 
> The problem is that if you are doing builds in separate object
> directories, you must not have any build files in the source tree.
> Otherwise make gets terribly confused.  If you have done a build in
> the source tree, then "make O=..." will because the Kernel makefile
> system has safety check which detects this case and complains:
> 
> % make O=/build/linux-build
> make[1]: Entering directory '/build/linux-build'
>   CHK     include/config/kernel.release
>   GEN     ./Makefile
>   CHK     include/generated/uapi/linux/version.h
>   CHK     scripts/mod/devicetable-offsets.h
>   Using /home/tytso/linux/linux as source for kernel
>   /home/tytso/linux/linux is not clean, please run 'make mrproper'
>   ...
> 
> So this is why Eric said that he has to run "make mrproper" after
> doing "make kselftest".  That's because doing any kind of build in the
> source tree breaks his (and my) normal kernel building system.

Thanks for the detailed explanation. I have a better understanding
of the workflow.

> 
> Personally, I do all of my testing using xfstests (and gce-xfstests in
> particular).  And so I don't have a lot of reason to spend time making
> kselftest work with the "make O=xxx" build paradigm.
Now that I have a better understanding, I will take a look. Based on
quick look, it might not be difficult to support it.

> 
> It's fair to say the fact that kselftest doesn't work with my kernel
> development workflow hasn't helped my motivation to try it out.  But
> as I told the systemtap folks many years ago --- "you're not under any
> obligation to support my workflow; but if systemtap is hostile to my
> kernel development workflow, you also can't expect me to help support
> and grow the use of systemtap, either.  It works both ways."
> 
> The same I think applies to kselftest.  Telling developers who
> complain that kselftest doesn't work well with their workflow to "send
> a patch" may not result in the reaction that you hope.  Especially for
> something as similar as "make O=xxx", which I think is a pretty common
> development workflow.  Anyway, I hope someone will care enough about
> kselftest to help support "make O=xxx"; I have to admit that someone
> isn't me, though.  Sorry; I just don't have the time....
> 

It wasn't my intent to be hostile.

thanks,
-- Shuah
