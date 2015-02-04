From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] RFC: Offer a way for userspace to request real
 deletion of files
Date: Wed, 4 Feb 2015 09:01:23 +0100
Message-ID: <CAHO5Pa3CFWeCn4iX_THgWkb6LhKTDFq1V==E54ZyQ0+dU20BkA@mail.gmail.com>
References: <1422896713-25367-1-git-send-email-holler@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422896713-25367-1-git-send-email-holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Cc: Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@]

Hello Alexander,

The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api-u79uwXL29TaiAVqoAR/hOA@public.gmane.org See also
https://www.kernel.org/doc/man-pages/linux-api-ml.html. Please CC
linux-api@ on future iterations of this patch.

Thanks,

Michael


On Mon, Feb 2, 2015 at 6:05 PM, Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org> wrote:
>
> Hello,
>
> some people already might have noticed that I've got a bit angry that
> no filesystem nor the posix api nor the linux syscalls are offering
> the userspace a way to request real deletion of one or more files (there's
> the 's' bit, see man chattr, but it is ignored by all FS which know it).
>
> Almost all filesystems are working such, that deleting a file just
> means it doesn't appear in the list of files anymore but the contents
> of the file still might be readable on the storage.
>
> So in the last 30 years many tools were created trying to circumvent that
> inability of all filesystems. Up to encrypting the whole storage which
> seems to be the current state of art and which many people recently tried
> to recommend to me.
>
> Also I'm using that workaround already myself since many years, I still
> believe it's a very bad, complictated, cumbersome and very uncomfortable
> way to make sure contents of files are not readable anymore. Besides that,
> just relying on encryption might hit back badly, because encryption often
> suffers from bugs in the implementation, bugs or even backdoors in the
> design and Moore. That means it's unsure how long the used encryption
> will defeat any tries to read the contents of a deleted file from storage
> and the used encryption might be worthless tomorrow. Not to speak about
> the problems with the necessary key-handling.
>
> What's the answer? Easy and obvious, just (try to) overwrite the contents
> of a file by request from userspace. Filesystems do know where on the
> storage they have written the contents to, so why not just let them delete
> that stuff themself instead? It's almost unbelievable that this was not
> already done in the past 30 years.
>
> So, now, after I've got angry enough, I've tried to do it myself, it seems
> to work and wasn't really hard.
>
> Of course, the easy way I think I've found isn't really my achievement.
> Instead it relies on all the work people have already done to support the
> trim command of SSDs. So thanks to all of them. You've made the following
> simple patches possible.
>
> How does it work:
>
> - Implement a new syscall named unlinkat_s() with the same signature as
> unlinkat(). With this syscall filesystems should make the old contents
> of files unreadable and should fail if they can't. This doesn't really
> have to be reliable, because it is often impossible for a filesystem to
> make enough assumptions about the underlying storage to promise secure
> deletion. But it has to mean that the filesystem tried everything it can
> to make sure the contents are unreadabler afterwards, e.g. by overwriting
> them, using secure trim or even just using trim. I've no idea if trim
> might be enough, if I would have implemented trim, it would clear the
> trimmed blocks in flash too, making them unreadable. But I haven't done
> such and I haven't tested if that's the case.
> The new syscall isn't meant to replace unlinkat() for everyday operations,
> therefor operation speed is ignored (see below in regard to a side effect).
>
> - Instruct the filesystem that it should discard or overwrite (all) freed
> blocks while the unlinkat_s() is at work.
>
> - Kill the inode while letting the filesystem discard freed blocks or
> overwrite them. As said before, this was easy through all the work already
> done by others. There even already existed a sb_issue_zeroout() which could
> be used instead of sb_issue_discard().
>
> - Sync the filesystem, to make sure the stuff is written to the storage.
>
>
> This approach has the side effect that while a call of unlinkat_s() is at
> work, all freed blocks will be destroyed, even those which aren't beloning
> to the unlink operation but are freed by possible other running actions.
> But in my humble opinion, that's nothing to care about and it keeps the
> implementation of this feature simple. I like KISS and that's imho the
> main feature of these patches.
>
>
> Things to be aware of when reading and starting to critisize my patches:
>
> - I've never had a look before at the kernel sources in fs/*.
> - They are the result of around half a dozen hours.
> - I'm aware that these patches are imperfect. Perfectionism does cost time
> for which I often don't feel the need to spend it unpaid.
> - I don't care for comments regarding style.
> - They are a proof of concept and are an offer. They are meant for other
> users, not maintainers. I wasn't paid for doing them and I don't care much
> if they will end up in the kernel. I already have and can use them, I'm
> happy with them and I don't really need them in the official kernel as I'm
> able to easily rebase them myself (thanks to git).
> - Don't be disappointed because the patches are that simple. The idea
> counts. ;)
>
>
> Regards,
>
> Alexander Holler
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
