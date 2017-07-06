From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v10 1/3] x86/syscalls: Check address limit on user-mode
 return
Date: Thu, 6 Jul 2017 13:52:24 -0700
Message-ID: <CAJcbSZGSqm8HYMv8biOQEWvan1nma3vjKNJ1mgMz52AyJ5adGA@mail.gmail.com>
References: <20170615011203.144108-1-thgarnie@google.com>
 <CAGXu5j+byHUn_rb9jOTZqMYrc4ngmDj=a3k8QRTYrZYNSjhCkw@mail.gmail.com>
 <CAGXu5jKrJv0y70e5JiafKGcGzWoJPZM_HruZ=Y0rM1m0J4tZAA@mail.gmail.com>
 <CAJcbSZE6Og4gwhFwhy_-Jaq6GovwN3y1B6O89JmkpXHtVfDLBA@mail.gmail.com>
 <alpine.DEB.2.20.1707062247520.3239@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <alpine.DEB.2.20.1707062247520.3239@nanos>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>, Chris Metcalf <cmetcalf@mellanox.com>, Pratyush Anand <panand@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Petr Mladek <pmladek@suse.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>Will Drewry <wa>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 6, 2017 at 1:48 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 6 Jul 2017, Thomas Garnier wrote:
>> On Wed, Jun 28, 2017 at 10:52 AM, Kees Cook <keescook@chromium.org> wrote:
>> >
>> > On Tue, Jun 20, 2017 at 1:24 PM, Kees Cook <keescook@chromium.org> wrote:
>> > > On Wed, Jun 14, 2017 at 6:12 PM, Thomas Garnier <thgarnie@google.com> wrote:
>> > >> Ensure the address limit is a user-mode segment before returning to
>> > >> user-mode. Otherwise a process can corrupt kernel-mode memory and elevate
>> > >> privileges [1].
>> > >>
>> > >> The set_fs function sets the TIF_SETFS flag to force a slow path on
>> > >> return. In the slow path, the address limit is checked to be USER_DS if
>> > >> needed.
>> > >>
>> > >> The addr_limit_user_check function is added as a cross-architecture
>> > >> function to check the address limit.
>> > >>
>> > >> [1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>> > >>
>> > >> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> > >
>> > > Thanks for reworking this series!
>> > >
>> > > The bad state correctly BUGs under the LKDTM test:
>> > >
>> > > [   21.171586] lkdtm: Performing direct entry CORRUPT_USER_DS
>> > > [   21.172791] lkdtm: setting bad task size limit
>> > > [   21.173742] ------------[ cut here ]------------
>> > > [   21.174641] kernel BUG at ./include/linux/syscalls.h:220!
>> > > ...
>> > > [   21.193166] Call Trace:
>> > > [   21.193617]  ? trace_hardirqs_on_thunk+0x1a/0x1c
>> > > [   21.194443]  entry_SYSCALL64_slow_path+0x25/0x25
>> > >
>> > >
>> > > Tested-by: Kees Cook <keescook@chromium.org>
>> >
>> > Is everyone happy with this patch for x86? Does this need anything
>> > more/different?
>>
>> Asking again. Additional feedback? Anyone wants to pick-it up?
>
> Can do. This needs to be a combo of all 3 I assume as the x86 one contains
> the function used by all of them, right?

That is correct.

>
> Thanks,
>
>         tglx



-- 
Thomas
