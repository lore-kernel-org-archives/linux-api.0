From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Tue, 20 Nov 2018 00:45:18 +0100
Message-ID: <20181119234515.o5dg5s2wtu6wl6m3@brauner.io>
References: <20181119103241.5229-3-christian@brauner.io>
 <201811200755.avfmktKQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201811200755.avfmktKQ%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 20, 2018 at 07:37:58AM +0800, kbuild test robot wrote:
> Hi Christian,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.20-rc3]
> [cannot apply to next-20181119]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Christian-Brauner/proc-allow-signaling-processes-via-file-descriptors/20181120-063836
> config: riscv-tinyconfig (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 8.1.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=8.1.0 make.cross ARCH=riscv 
> 
> All errors (new ones prefixed by >>):
> 
>    kernel/signal.c: In function '__do_sys_procfd_signal':
> >> kernel/signal.c:3341:7: error: implicit declaration of function 'proc_is_procfd'; did you mean 'clockid_to_fd'? [-Werror=implicit-function-declaration]
>      if (!proc_is_procfd(f.file))
>           ^~~~~~~~~~~~~~

On my radar and fixed. This happens when CONFIG_PROC_FS unset.

>           clockid_to_fd
>    cc1: some warnings being treated as errors
> 
> vim +3341 kernel/signal.c
> 
>   3314	
>   3315	/**
>   3316	 *  sys_procfd_signal - send a signal to a process through a process file
>   3317	 *                      descriptor
>   3318	 *  @fd: the file descriptor of the process
>   3319	 *  @sig: signal to be sent
>   3320	 *  @info: the signal info
>   3321	 *  @flags: future flags to be passed
>   3322	 */
>   3323	SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig, siginfo_t __user *, info,
>   3324			int, flags)
>   3325	{
>   3326		int ret;
>   3327		struct pid *pid;
>   3328		kernel_siginfo_t kinfo;
>   3329		struct fd f;
>   3330	
>   3331		/* Enforce flags be set to 0 until we add an extension. */
>   3332		if (flags)
>   3333			return -EINVAL;
>   3334	
>   3335		f = fdget_raw(fd);
>   3336		if (!f.file)
>   3337			return -EBADF;
>   3338	
>   3339		ret = -EINVAL;
>   3340		/* Is this a process file descriptor? */
> > 3341		if (!proc_is_procfd(f.file))
>   3342			goto err;
>   3343	
>   3344		pid = f.file->private_data;
>   3345		if (!pid)
>   3346			goto err;
>   3347	
>   3348		if (info) {
>   3349			ret = __copy_siginfo_from_user(sig, &kinfo, info);
>   3350			if (unlikely(ret))
>   3351				goto err;
>   3352			/*
>   3353			 * Not even root can pretend to send signals from the kernel.
>   3354			 * Nor can they impersonate a kill()/tgkill(), which adds
>   3355			 * source info.
>   3356			 */
>   3357			ret = -EPERM;
>   3358			if ((kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL) &&
>   3359			    (task_pid(current) != pid))
>   3360				goto err;
>   3361		} else {
>   3362			prepare_kill_siginfo(sig, &kinfo);
>   3363		}
>   3364	
>   3365		ret = kill_pid_info(sig, &kinfo, pid);
>   3366	
>   3367	err:
>   3368		fdput(f);
>   3369		return ret;
>   3370	}
>   3371	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
