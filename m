From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6] fs: clear file privilege bits when mmap writing
Date: Mon, 11 Jan 2016 14:45:57 -0800
Message-ID: <CAGXu5j+UV39Q5reWOWBrtxuP6cLpweEF5e-KBV_K4moszCC24g@mail.gmail.com>
References: <20160108232727.GA23490@www.outflux.net>
	<CALYGNiOUL7ewU3+5Zoi_9qofYWwF0vpqMy=A0wS=jUFZ11haCg@mail.gmail.com>
	<CAGXu5jJaoZC7WL=MndBr915XhEpn9n3HOOhB-ue1xqyKFWxxzQ@mail.gmail.com>
	<CALYGNiPC224w7-xeo9NOX9nrHH84o+_KXBtKWtd4TPXQyQMq2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALYGNiPC224w7-xeo9NOX9nrHH84o+_KXBtKWtd4TPXQyQMq2w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, yalin wang <yalin.wang2010@gmail.com>, Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 11, 2016 at 2:39 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> On Mon, Jan 11, 2016 at 10:38 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Sun, Jan 10, 2016 at 7:48 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>> On Sat, Jan 9, 2016 at 2:27 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> Normally, when a user can modify a file that has setuid or setgid bits,
>>>> those bits are cleared when they are not the file owner or a member
>>>> of the group. This is enforced when using write and truncate but not
>>>> when writing to a shared mmap on the file. This could allow the file
>>>> writer to gain privileges by changing a binary without losing the
>>>> setuid/setgid/caps bits.
>>>>
>>>> Changing the bits requires holding inode->i_mutex, so it cannot be done
>>>> during the page fault (due to mmap_sem being held during the fault). We
>>>> could do this during vm_mmap_pgoff, but that would need coverage in
>>>> mprotect as well, but to check for MAP_SHARED, we'd need to hold mmap_sem
>>>> again. We could clear at open() time, but it's possible things are
>>>> accidentally opening with O_RDWR and only reading. Better to clear on
>>>> close and error failures (i.e. an improvement over now, which is not
>>>> clearing at all).
>>>
>>> I think this should be done in mmap/mprotect. Code in sys_mmap is trivial.
>>>
>>> In sys_mprotect you can check file_needs_remove_privs() and VM_SHARED
>>> under mmap_sem, then if needed grab reference to struct file from vma and
>>> clear suid after unlocking mmap_sem.
>>>
>>> I haven't seen previous iterations, probably this approach has known flaws.
>>
>> mmap_sem is still needed in mprotect (to find and hold the vma), so
>> it's not possible. I'd love to be proven wrong, but I didn't see a
>> way.
>
> something like this
>
> @@ -375,6 +376,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
>
>         vm_flags = calc_vm_prot_bits(prot);
>
> +restart:
>         down_write(&current->mm->mmap_sem);
>
>         vma = find_vma(current->mm, start);
> @@ -416,6 +418,21 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start,
> size_t, len,
>                         goto out;
>                 }
>
> +               if ((newflags & VM_WRITE) && !(vma->vm_flags & VM_WRITE) &&
> +                   vma->vm_file && file_needs_remove_privs(vma->vm_file)) {
> +                       struct file *file = get_file(vma->vm_file);
> +
> +                       start = vma->vm_start;
> +                       up_write(&current->mm->mmap_sem);
> +                       mutex_lock(&file_inode(file)->i_mutex);
> +                       error = file_remove_privs(file);
> +                       mutex_unlock(&file_inode(file)->i_mutex);
> +                       fput(file);
> +                       if (error)
> +                               return error;
> +                       goto restart;
> +               }
> +

Is this safe against the things Al mentioned? I still don't like the
mmap/mprotect approach because it makes the change before anything was
actually written...

-Kees

>
>
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Chrome OS & Brillo Security



-- 
Kees Cook
Chrome OS & Brillo Security
