From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 10:54:51 +0000
Message-ID: <20181114105449.GK3505@e103592.cambridge.arm.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com>
 <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com>
 <69B07026-5E8B-47FC-9313-E51E899FAFB0@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <69B07026-5E8B-47FC-9313-E51E899FAFB0@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Colascione <dancol@google.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 13, 2018 at 12:58:39PM -0800, Andy Lutomirski wrote:
> 
> > On Nov 13, 2018, at 11:39 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> > 
> > On Mon, Nov 12, 2018 at 05:19:14AM -0800, Daniel Colascione wrote:
> > 
> > [...]
> > 
> >> We can learn something from how Windows does things. On that system,
> >> what we think of as "libc" is actually two parts. (More, actually, but
> >> I'm simplifying.) At the lowest level, you have the semi-documented
> >> ntdll.dll, which contains raw system call wrappers and arcane
> >> kernel-userland glue. On top of ntdll live the "real" libc
> >> (msvcrt.dll, kernel32.dll, etc.) that provide conventional
> >> application-level glue. The tight integration between ntdll.dll and
> >> the kernel allows Windows to do very impressive things. (For example,
> >> on x86_64, Windows has no 32-bit ABI as far as the kernel is
> >> concerned! You can still run 32-bit programs though, and that works
> >> via ntdll.dll essentially shimming every system call and switching the
> >> processor between long and compatibility mode as needed.) Normally,
> >> you'd use the higher-level capabilities, but if you need something in
> >> ntdll (e.g., if you're Cygwin) nothing stops your calling into the
> >> lower-level system facilities directly. ntdll is tightly bound to the
> >> kernel; the higher-level libc, not so.
> >> 
> >> We should adopt a similar approach. Shipping a lower-level
> >> "liblinux.so" tightly bound to the kernel would not only let the
> >> kernel bypass glibc's "editorial discretion" in exposing new
> >> facilities to userspace, but would also allow for tighter user-kernel
> >> integration that one can achieve with a simplistic syscall(2)-style
> >> escape hatch. (For example, for a long time now, I've wanted to go
> >> beyond POSIX and improve the system's signal handling API, and this
> >> improvement requires userspace cooperation.) The vdso is probably too
> >> small and simplistic to serve in this role; I'd want a real library.
> > 
> > Can you expand on your reasoning here?
> > 
> > Playing devil's advocate:
> > 
> > If the library is just exposing the syscall interface, I don't see
> > why it _couldn't_ fit into the vdso (or something vdso-like).
> > 
> > If a separate library, I'd be concerned that it would accumulate
> > value-add bloat over time, and the kernel ABI may start to creep since
> > most software wouldn't invoke the kernel directly any more.  Even if
> > it's maintained in the kernel tree, its existence as an apparently
> > standalone component may encourage forking, leading to a potential
> > compatibility mess.
> > 
> > The vdso approach would mean we can guarantee that the library is
> > available and up to date at runtime, and may make it easier to keep
> > what's in it down to sane essentials.
> 
> Hmm. Putting on my vDSO hat:
> 
> The vDSO could provide all kinds of nifty things. Better exception
> handling comes to mind. But it has two major limitations that severely
> restrict what it can do:
> 
> - It can’t allocate memory. We probably want to keep it that way.
> 
> - It can’t use TLS.  Solving this without genuinely awful ABI issues
> may be extremely hard. We *could* require callers to pass a thread
> pointer in, I suppose.
> 
> Also, if we make the vDSO stateful, CRIU is going to have a blast.  We
> might need to expose explicit save and restore abilities.
> 
> As a straw man use case, it would be neat if DSOs (or the loader,
> maybe) could register a list of exception fixups per DSO.  The kernel
> could consult these lists before delivering a signal.  ISTM it wouldn’t
> be so crazy if the vDSO handled registration, although it could uses
> syscalls as well. If the vDSO did it, it would need somewhere to put
> the lists.

Fair points, though this is rather what I meant by "sane essentials".
Because there are strict limits on what can be done in the vDSO, it may
be more bloat-resistant and more conservatively maintained.

This might provide a way to push some dumb compatibility kludge code
that receives little ongoing maintenance outside the privilege wall,
whereas it has to sit in the kernel proper today.

In theory we could opt to advertise new syscalls only via vDSO entry
points, and not maintain __NR_xxx values for them (which may or may
not upset ptrace users.)  Anyway, I digress...

Cheers
---Dave
