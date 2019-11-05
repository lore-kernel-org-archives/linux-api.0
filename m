From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for
 UFFD_FEATURE_EVENT_FORK
Date: Tue, 5 Nov 2019 12:30:23 -0500
Message-ID: <20191105173023.GN30717@redhat.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
 <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
 <CAKOZuev93zDGNPX+ySg_jeUg4Z3zKMcpABekUQvHA01kTVn4=A@mail.gmail.com>
 <CALCETrX=VmSjD6kLT6tuZQ4Efhc_13vZrw1mo4Z2iKqZTT-bzg@mail.gmail.com>
 <CAKOZuetu0QWUDAycTOFzC4HEbjH99EtOhb4gJnHAuovT_StpzA@mail.gmail.com>
 <20191105163316.GI30717@redhat.com>
 <CAKOZuet1Hrdd7U4VVBmXNCkE6xwiUPERRHjP=A3bX6B9A4BQRQ@mail.gmail.com>
 <20191105165556.GK30717@redhat.com>
 <CAKOZuet+fgaJR72YwYrHFdFVSOo6EWpcT8jUoh7se4cZb0V2aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuet+fgaJR72YwYrHFdFVSOo6EWpcT8jUoh7se4cZb0V2aw@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 09:02:09AM -0800, Daniel Colascione wrote:
> And you're suggesting making a security check work weirdly unlike most
> other security checks because you hope it'll get removed one day?

I didn't actually suggest that, I was only asking clarifications that
I understood correctly because up until that point you didn't seem to
say that the "permission check" needs to remain in UFFDIO_API.

> Temporary solutions aren't, and if something goes into the kernel at
> all, it's worth getting right. The general rule is that access checks
> happen at open time. The kernel has already been bitten by UFFD
> exempting itself from the normal rules (e.g., the
> read(2)-makes-a-file-descriptor thing) in the name of expediency.
> There shouldn't be any more exceptions.

It didn't occur to me that not doing the measurement in the syscall
that opens an fd is weird.

The posted patch doesn't work any different than fscrypt_ioctl_add_key
in FS_IOC_ADD_ENCRYPTION_KEY of ext4 and others, or
btrfs_ioctl_fssetxattr or a ton of other examples where permissions
are checked directly the in ioctl of the files and the measurement is
also done in the ioctl and not in the open() as you suggest as the
only non-weird solution that should exist in the kernel.

I can surely provide a lot more examples of the exact same paradigm
where the measurement of the capability is done in the ioctl, those
are the first two examples that show up so it's unlikely they're the
only ones.

So overall I didn't think this was something wrong to do, or weird or
something particularly new and I didn't look like we were bitting
anything with it. And more than in the name of expediency this simply
looks preferable to keep the complexity of the kernel low which in
turns it means it's going to be more secure and simpler to
maintain. Especially considering this code is likely to be modified
later.

Said that I've nothing contrary to do the more complex solution if
that's the correct thing to do despite more complex and despite the
code is pending for removal anyway, just I don't see any difference
between the current simple patch to what ext4_ioctl does in
FS_IOC_ADD_ENCRYPTION_KEY + FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR.
