From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Tue, 6 Mar 2018 03:05:49 -0800
Message-ID: <20180306110549.GB31087@kroah.com>
References: <20180306013457.1955486-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180306013457.1955486-1-ast@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 05, 2018 at 05:34:57PM -0800, Alexei Starovoitov wrote:
> As the first step in development of bpfilter project [1] the request_module()
> code is extended to allow user mode helpers to be invoked. Idea is that
> user mode helpers are built as part of the kernel build and installed as
> traditional kernel modules with .ko file extension into distro specified
> location, such that from a distribution point of view, they are no different
> than regular kernel modules. Thus, allow request_module() logic to load such
> user mode helper (umh) modules via:
> 
>   request_module("foo") ->
>     call_umh("modprobe foo") ->
>       sys_finit_module(FD of /lib/modules/.../foo.ko) ->
>         call_umh(struct file)
> 
> Such approach enables kernel to delegate functionality traditionally done
> by kernel modules into user space processes (either root or !root) and
> reduces security attack surface of such new code, meaning in case of
> potential bugs only the umh would crash but not the kernel. Another
> advantage coming with that would be that bpfilter.ko can be debugged and
> tested out of user space as well (e.g. opening the possibility to run
> all clang sanitizers, fuzzers or test suites for checking translation).
> Also, such architecture makes the kernel/user boundary very precise:
> control plane is done by the user space while data plane stays in the kernel.
> 
> It's easy to distinguish "umh module" from traditional kernel module:
> 
> $ readelf -h bld/net/bpfilter/bpfilter.ko|grep Type
>   Type:                              EXEC (Executable file)
> $ readelf -h bld/net/ipv4/netfilter/iptable_filter.ko |grep Type
>   Type:                              REL (Relocatable file)

Any chance you can add a field to your "umh module" type such that a
normal 'modinfo' program will be able to notice it is different easily?

> Since umh can crash, can be oom-ed by the kernel, killed by admin,
> the subsystem that uses them (like bpfilter) need to manage life
> time of umh on its own, so module infra doesn't do any accounting
> of them. They don't appear in "lsmod" and cannot be "rmmod".
> Multiple request_module("umh") will load multiple umh.ko processes.
> 
> Similar to kernel modules the kernel will be tainted if "umh module"
> has invalid signature.

Shouldn't we fail to load the "module" if the signature is not valid if
CONFIG_MODULE_SIG_FORCE=y is enabled, like we do for modules?  I run my
systems like that, and just "warning" isn't probably a good idea for
systems that want to enforce that everything is signed properly?

Other than that, one minor question:

> @@ -1745,7 +1745,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>  	sched_exec();
>  
>  	bprm->file = file;
> -	if (fd == AT_FDCWD || filename->name[0] == '/') {
> +	if (!filename) {
> +		bprm->filename = "/dev/null";

Why the use of "/dev/null" for the filename here, and elsewhere in the
code?  While I'm "sure" that everyone really does have /dev/null/
mounted in the root namespace, what is the use of it here?

Also, what "namespace" does this usermode helper run in?  I'm guessing
the "root" one, which is fine with me, but note that people have
complained in the past about other UMH running in that namespace and not
in the specific namespace of the "container" that they wanted it to run
in.

Anyway, this is crazy stuff, but I like the idea and have no objection
to it overall :)

thanks,

greg k-h
