From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Tue, 6 Mar 2018 17:07:45 -0800
Message-ID: <d4fa4529-8341-8069-b80e-78773b0bb366@fb.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <20180306110549.GB31087@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306110549.GB31087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, Alexei Starovoitov <ast@kernel.org>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

combining multiple answers...

On 3/6/18 3:05 AM, Greg KH wrote:
>
> Any chance you can add a field to your "umh module" type such that a
> normal 'modinfo' program will be able to notice it is different easily?

ok. handling of modinfo turned out to be straightforward.
kmod tooling worked fine with simple addition of .modinfo section.

$ modinfo bpfilter
filename: 
/lib/modules/4.16.0-rc4-00799-g1716f0aa3039-dirty/net/bpfilter/bpfilter.ko
umh:            Y
license:        GPL

I will require umh=Y and license to be present.
umh has to be set to Y for this 'umh modules'
and taint of kernel will happen if license is not gpl.
Other modinfo like vermagic are not applicable here, since
umh modules interact with kernel via normal kernel/user abi.

>> Since umh can crash, can be oom-ed by the kernel, killed by admin,
>> the subsystem that uses them (like bpfilter) need to manage life
>> time of umh on its own, so module infra doesn't do any accounting
>> of them. They don't appear in "lsmod" and cannot be "rmmod".
>> Multiple request_module("umh") will load multiple umh.ko processes.
>>
>> Similar to kernel modules the kernel will be tainted if "umh module"
>> has invalid signature.
>
> Shouldn't we fail to load the "module" if the signature is not valid if
> CONFIG_MODULE_SIG_FORCE=y is enabled, like we do for modules?  I run my
> systems like that, and just "warning" isn't probably a good idea for
> systems that want to enforce that everything is signed properly?

CONFIG_MODULE_SIG_FORCE=y is already handled by this patch.
It's checked first for either .ko or umh.ko (before any elf parsing)
and returns -ENOKEY to user space without any dmesg message.
I think it's best to keep it as-is.
The taint and warning is for 'undef SIG_FORCE' and when module
is signed, but incorrectly.

>
> Other than that, one minor question:
>
>> @@ -1745,7 +1745,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>>  	sched_exec();
>>
>>  	bprm->file = file;
>> -	if (fd == AT_FDCWD || filename->name[0] == '/') {
>> +	if (!filename) {
>> +		bprm->filename = "/dev/null";
>
> Why the use of "/dev/null" for the filename here, and elsewhere in the
> code?  While I'm "sure" that everyone really does have /dev/null/
> mounted in the root namespace, what is the use of it here?

filename is assumed to be non-null in several places further
down and instead of hacking it everywhere it's cleaner to assign
some string to it.
I'll change it to filename = "none"
Same in umh part.

> Also, what "namespace" does this usermode helper run in?  I'm guessing
> the "root" one, which is fine with me, but note that people have
> complained in the past about other UMH running in that namespace and not
> in the specific namespace of the "container" that they wanted it to run
> in.

right. this is something we can tweak later if really necessary.
Right now most of the bpf is root-only, so bpfilter.ko would have to run
as cap_sys_admin for now. Later we plan to tighten it to be
cap_net_admin.


On 3/6/18 11:12 AM, Linus Torvalds wrote:
 >
 > particularly for the early implementation when this is a new thing, I
 > really want a message like
 >
 >     executed user process xyz-abc as a pseudo-module
 >
 > or something in dmesg.
 >
 > I do *not* want this to be a magical way to hide things.

right. no intent of hiding anything.
The first thing bpfilter.ko does is print 'Starting bpfilter'
into /dev/console.

Long term the health check of 'umh module' and interaction with
the kernel should be standardized and though they're normal processes
seen with 'ps' would be good to see them in lsmod as well.
For now it's indeed the best to do pr_warn() message like above.
Ratelimiting is probably not necessary.


On 3/6/18 12:01 PM, Andy Lutomirski wrote:
 >
 > I imagine that usermode tooling needs to change regardless
 > because the existing tools may get rather confused if a .ko "module"

the goal is to do zero changes to user tooling.
The kmod tools handle this special .ko just fine.
Tested with modprobe, depmod, modinfo, insmod.
scripts/sign-file also works.
