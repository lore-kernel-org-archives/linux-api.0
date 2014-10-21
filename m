From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Mon, 20 Oct 2014 21:29:25 -0700
Message-ID: <87ioje2ggq.fsf@x220.int.ebiederm.org>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
	<CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
	<87zjcszz8y.fsf@x220.int.ebiederm.org>
	<CAHse=S-Xyk7CFn=tAGzo+tuUFt+04aBw+mGQmi=kWAaBJGALBw@mail.gmail.com>
	<CALCETrXBjLZTWVJfcsE4NA-JP9zSSgn=6ND0=cZ9BTy=CoN7pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXBjLZTWVJfcsE4NA-JP9zSSgn=6ND0=cZ9BTy=CoN7pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Mon, 20 Oct 2014 15:48:06 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Mon, Oct 20, 2014 at 6:48 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Sun, Oct 19, 2014 at 1:20 AM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>>
>>>> [Added Eric Biederman, since I think your tree might be a reasonable
>>>> route forward for these patches.]
>>>>
>>>> On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>>> Resending, adding cc:linux-api.
>>>>>
>>>>> Also, it may help to add a little more background -- this patch is
>>>>> needed as a (small) part of implementing Capsicum in the Linux kernel.
>>>>>
>>>>> Capsicum is a security framework that has been present in FreeBSD since
>>>>> version 9.0 (Jan 2012), and is based on concepts from object-capability
>>>>> security [1].
>>>>>
>>>>> One of the features of Capsicum is capability mode, which locks down
>>>>> access to global namespaces such as the filesystem hierarchy.  In
>>>>> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
>>>>> work -- hence the need for a kernel-space
>>>>
>>>> I just found myself wanting this syscall for another reason: injecting
>>>> programs into sandboxes or otherwise heavily locked-down namespaces.
>>>>
>>>> For example, I want to be able to reliably do something like nsenter
>>>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>>>> it is more or less fully functional, so this should Just Work (tm),
>>>> except that the toybox binary might not exist in the namespace being
>>>> entered.  If execveat were available, I could rig nsenter or a similar
>>>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>>>> execveat.
>>>>
>>>> Is there any reason that these patches can't be merged more or less as
>>>> is for 3.19?
>>>
>>> Yes.  There is a silliness in how it implements fexecve.  The fexecve
>>> case should be use the empty string "" not a NULL pointer to indication
>>> that.  That change will then harmonize execveat with the other ...at
>>> system calls and simplify the code and remove a special case.  I believe
>>> using the empty string "" requires implementing the AT_EMPTY_PATH flag.
>>
>> Good point -- I'll shift to "" + AT_EMPTY_PATH.
>
> Pending a better idea, I would also see if the patches can be changed
> to return an error if d_path ends up with an "(unreachable)" thing
> rather than failing inexplicably later on.

For my reference we are talking about  

> @@ -1489,7 +1524,21 @@ static int do_execve_common(struct filename *filename,
>  	sched_exec();
> 
>  	bprm->file = file;
> -	bprm->filename = bprm->interp = filename->name;
> +	if (filename && fd == AT_FDCWD) {
> +		bprm->filename = filename->name;
> +	} else {
> +		pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
> +		if (!pathbuf) {
> +			retval = -ENOMEM;
> +			goto out_unmark;
> +		}
> +		bprm->filename = d_path(&file->f_path, pathbuf, PATH_MAX);
> +		if (IS_ERR(bprm->filename)) {
> +			retval = PTR_ERR(bprm->filename);
> +			goto out_unmark;
> +		}
> +	}
> +	bprm->interp = bprm->filename;
> 
>  	retval = bprm_mm_init(bprm);
>  	if (retval)

The interesting case for fexecve is when we either don't know what files
are present or we don't want to depend on which files are present.

As Al pointed out d_path really isn't the right solution.  It fails when
printing /proc/self/fd/${fd}/${filename->name} would work, and the
"(deleted)" or "(unreachable)" strings are wrong.

The test for today's cases should be:
if ((filename->name[0] == '/') || fd == AT_FDCWD) {
	bprm->filename = filename->name;
} 

To handle the case where the file descriptor is relevant.

For the case where the file descriptor is relevant let me suggest
setting bprm->filename and bprm->interp to:

/dev/fd/${fd}/${filename->name}

It is more a description of what we have done but as a magic string it
is descriptive.  Documetation/devices.txt documents that /dev/fd/ should
exist, making it an unambiguous path.  Further these days the kernel
sets the device naming policy in dev, so I think we are strongly safe in
using that path in any event.

I think execveat is interesting in the kernel because the motivating
cases are the cases where anything except a static executable is
uninteresting.

Now it has been suggested creating a dupfs or a mini-proc.  I think that
sounds like a nice companion, to the concept of a locked down root.
But I don't think it removes the need for execveat (because we still
have the case where we don't want to care what is mounted, and are happy
to use static executables). 

Eric
