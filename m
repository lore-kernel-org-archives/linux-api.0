From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Tue, 6 Mar 2018 19:24:14 -0800
Message-ID: <20180307032414.GA24203@kroah.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <20180306110549.GB31087@kroah.com>
 <d4fa4529-8341-8069-b80e-78773b0bb366@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d4fa4529-8341-8069-b80e-78773b0bb366@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 06, 2018 at 05:07:45PM -0800, Alexei Starovoitov wrote:
> combining multiple answers...
> 
> On 3/6/18 3:05 AM, Greg KH wrote:
> > 
> > Any chance you can add a field to your "umh module" type such that a
> > normal 'modinfo' program will be able to notice it is different easily?
> 
> ok. handling of modinfo turned out to be straightforward.
> kmod tooling worked fine with simple addition of .modinfo section.
> 
> $ modinfo bpfilter
> filename:
> /lib/modules/4.16.0-rc4-00799-g1716f0aa3039-dirty/net/bpfilter/bpfilter.ko
> umh:            Y

Nice.  But perhaps spell it out, "user_mode_helper"?  Anyway,
bikesheding now, sorry, whatever you want to call it is fine with me.

> license:        GPL
> 
> I will require umh=Y and license to be present.
> umh has to be set to Y for this 'umh modules'
> and taint of kernel will happen if license is not gpl.

Interesting, I like it :)


> Other modinfo like vermagic are not applicable here, since
> umh modules interact with kernel via normal kernel/user abi.

Very true.

> > > Since umh can crash, can be oom-ed by the kernel, killed by admin,
> > > the subsystem that uses them (like bpfilter) need to manage life
> > > time of umh on its own, so module infra doesn't do any accounting
> > > of them. They don't appear in "lsmod" and cannot be "rmmod".
> > > Multiple request_module("umh") will load multiple umh.ko processes.
> > > 
> > > Similar to kernel modules the kernel will be tainted if "umh module"
> > > has invalid signature.
> > 
> > Shouldn't we fail to load the "module" if the signature is not valid if
> > CONFIG_MODULE_SIG_FORCE=y is enabled, like we do for modules?  I run my
> > systems like that, and just "warning" isn't probably a good idea for
> > systems that want to enforce that everything is signed properly?
> 
> CONFIG_MODULE_SIG_FORCE=y is already handled by this patch.
> It's checked first for either .ko or umh.ko (before any elf parsing)
> and returns -ENOKEY to user space without any dmesg message.
> I think it's best to keep it as-is.
> The taint and warning is for 'undef SIG_FORCE' and when module
> is signed, but incorrectly.

Ah, sorry, I missed that, thanks for clearing it up.

> > Other than that, one minor question:
> > 
> > > @@ -1745,7 +1745,9 @@ static int do_execveat_common(int fd, struct filename *filename,
> > >  	sched_exec();
> > > 
> > >  	bprm->file = file;
> > > -	if (fd == AT_FDCWD || filename->name[0] == '/') {
> > > +	if (!filename) {
> > > +		bprm->filename = "/dev/null";
> > 
> > Why the use of "/dev/null" for the filename here, and elsewhere in the
> > code?  While I'm "sure" that everyone really does have /dev/null/
> > mounted in the root namespace, what is the use of it here?
> 
> filename is assumed to be non-null in several places further
> down and instead of hacking it everywhere it's cleaner to assign
> some string to it.
> I'll change it to filename = "none"
> Same in umh part.

Thanks, that makes sense.

greg k-h
