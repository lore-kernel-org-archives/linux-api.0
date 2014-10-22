From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Wed, 22 Oct 2014 12:40:25 -0500
Message-ID: <87wq7shuk6.fsf@x220.int.ebiederm.org>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
	<CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
	<87zjcszz8y.fsf@x220.int.ebiederm.org>
	<CAHse=S-Xyk7CFn=tAGzo+tuUFt+04aBw+mGQmi=kWAaBJGALBw@mail.gmail.com>
	<CALCETrXBjLZTWVJfcsE4NA-JP9zSSgn=6ND0=cZ9BTy=CoN7pA@mail.gmail.com>
	<87ioje2ggq.fsf@x220.int.ebiederm.org>
	<CAHse=S_dpm8Do-H01Bo49a9TdYw+pSDzYomLOrBsYEcdO=Pytw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAHse=S_dpm8Do-H01Bo49a9TdYw+pSDzYomLOrBsYEcdO=Pytw@mail.gmail.com>
	(David Drysdale's message of "Wed, 22 Oct 2014 12:08:17 +0100")
Sender: linux-arch-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

David Drysdale <drysdale@google.com> writes:

> On Tue, Oct 21, 2014 at 5:29 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Mon, Oct 20, 2014 at 6:48 AM, David Drysdale <drysdale@google.com> wrote:
>>>> On Sun, Oct 19, 2014 at 1:20 AM, Eric W. Biederman
>>>> <ebiederm@xmission.com> wrote:
>>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>>
>>>>>> [Added Eric Biederman, since I think your tree might be a reasonable
>>>>>> route forward for these patches.]
>>>>>>
>>>>>> On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale@google.com> wrote:
>>>>>>> Resending, adding cc:linux-api.
>>>>>>>
>>>>>>> Also, it may help to add a little more background -- this patch is
>>>>>>> needed as a (small) part of implementing Capsicum in the Linux kernel.
>>>>>>>
>>>>>>> Capsicum is a security framework that has been present in FreeBSD since
>>>>>>> version 9.0 (Jan 2012), and is based on concepts from object-capability
>>>>>>> security [1].
>>>>>>>
>>>>>>> One of the features of Capsicum is capability mode, which locks down
>>>>>>> access to global namespaces such as the filesystem hierarchy.  In
>>>>>>> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
>>>>>>> work -- hence the need for a kernel-space
>>>>>>
>>>>>> I just found myself wanting this syscall for another reason: injecting
>>>>>> programs into sandboxes or otherwise heavily locked-down namespaces.
>>>>>>
>>>>>> For example, I want to be able to reliably do something like nsenter
>>>>>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>>>>>> it is more or less fully functional, so this should Just Work (tm),
>>>>>> except that the toybox binary might not exist in the namespace being
>>>>>> entered.  If execveat were available, I could rig nsenter or a similar
>>>>>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>>>>>> execveat.
>>>>>>
>>>>>> Is there any reason that these patches can't be merged more or less as
>>>>>> is for 3.19?
>>>>>
>>>>> Yes.  There is a silliness in how it implements fexecve.  The fexecve
>>>>> case should be use the empty string "" not a NULL pointer to indication
>>>>> that.  That change will then harmonize execveat with the other ...at
>>>>> system calls and simplify the code and remove a special case.  I believe
>>>>> using the empty string "" requires implementing the AT_EMPTY_PATH flag.
>>>>
>>>> Good point -- I'll shift to "" + AT_EMPTY_PATH.
>>>
>>> Pending a better idea, I would also see if the patches can be changed
>>> to return an error if d_path ends up with an "(unreachable)" thing
>>> rather than failing inexplicably later on.
>>
>> For my reference we are talking about
>>
>>> @@ -1489,7 +1524,21 @@ static int do_execve_common(struct filename *filename,
>>>       sched_exec();
>>>
>>>       bprm->file = file;
>>> -     bprm->filename = bprm->interp = filename->name;
>>> +     if (filename && fd == AT_FDCWD) {
>>> +             bprm->filename = filename->name;
>>> +     } else {
>>> +             pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
>>> +             if (!pathbuf) {
>>> +                     retval = -ENOMEM;
>>> +                     goto out_unmark;
>>> +             }
>>> +             bprm->filename = d_path(&file->f_path, pathbuf, PATH_MAX);
>>> +             if (IS_ERR(bprm->filename)) {
>>> +                     retval = PTR_ERR(bprm->filename);
>>> +                     goto out_unmark;
>>> +             }
>>> +     }
>>> +     bprm->interp = bprm->filename;
>>>
>>>       retval = bprm_mm_init(bprm);
>>>       if (retval)
>>
>> The interesting case for fexecve is when we either don't know what files
>> are present or we don't want to depend on which files are present.
>>
>> As Al pointed out d_path really isn't the right solution.  It fails when
>> printing /proc/self/fd/${fd}/${filename->name} would work, and the
>> "(deleted)" or "(unreachable)" strings are wrong.
>>
>> The test for today's cases should be:
>> if ((filename->name[0] == '/') || fd == AT_FDCWD) {
>>         bprm->filename = filename->name;
>> }
>>
>> To handle the case where the file descriptor is relevant.
> (s/relevant/irrelevant)
>
> Yep, good spot.
>
>> For the case where the file descriptor is relevant let me suggest
>> setting bprm->filename and bprm->interp to:
>>
>> /dev/fd/${fd}/${filename->name}
>
> I'll send out an updated patchset with this approach, but I have a slight
> reservation. Given that /dev/fd is a symlink to /proc/self/fd, this approach
> means that script invocations will always fail on a /proc-less system,
> where the previous iteration might have worked.
>
> (As it happens, this isn't a restriction that affects the things I'm
> working on, as Capsicum wouldn't allow script invocation anyway.
> However, scenarios without /proc were nominally one of the motivating
> factors for execveat in the first place...)

Which is where's Al Viro's and Peter Anvin's conversation about a
minimal filesystem that can serve the needs of /proc/self/fd comes in.

There are uses for execveat with static executables, so I think execveat
is justified.  But having a dupfs that we could potentially mount on
/dev/fd would be interesting.   As it is much less of a security
concern than /proc with all of the interfaces it provides.

>> It is more a description of what we have done but as a magic string it
>> is descriptive.  Documetation/devices.txt documents that /dev/fd/ should
>> exist, making it an unambiguous path.  Further these days the kernel
>> sets the device naming policy in dev, so I think we are strongly safe in
>> using that path in any event.
>>
>> I think execveat is interesting in the kernel because the motivating
>> cases are the cases where anything except a static executable is
>> uninteresting.
>
> FYI, there is potential in the future for something other than static
> executables -- the FreeBSD Capsicum implementation includes changes
> to the dynamic linker to get its search path as a list of pre-opened dfds
> (in LD_LIBRARY_PATH_FDS) rather than paths.

Which still leaves open the question how do you find the dynamic
linker.  Is that also a pre-opened dfd?

Using /dev/fd/$N is also the kind of thing that a shell or a script
interpret could special case instead relying on a filesystem node
to exist.

Eric
